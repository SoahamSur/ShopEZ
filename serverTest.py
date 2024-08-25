from flask import Flask, request, jsonify
import torch
import numpy as np
from PIL import Image
import io
from ultralytics import YOLO
import zipfile

model = YOLO('best_2.pt')  

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    if 'images' not in request.files:
        return jsonify({"error": "No image files found in request"}), 400
    
    file = request.files['images']

    if not file:
        return jsonify({"error": "No file uploaded"}), 400

    img_bytes = file.read()

    # Unzip the folder and process each image
    detection_map = {}
    result_data = []

    with zipfile.ZipFile(io.BytesIO(img_bytes)) as archive:
        for filename in archive.namelist():
            if filename.endswith(('.png', '.jpg', '.jpeg','.webp')):
                with archive.open(filename) as img_file:
                    image = Image.open(io.BytesIO(img_file.read()))
                    
                    if image.mode != 'RGB':
                        image = image.convert('RGB')

                    # Perform prediction
                    results = model.predict(image, save=True, conf=0.20, imgsz=480)
                    
                    names = model.names

                    for r in results:
                        for c in r.boxes.cls:
                            class_name = names[int(c)]
                            if class_name not in detection_map:
                                detection_map[class_name] = 1
                            else:
                                detection_map[class_name] += 1

                        for box in r.boxes.xyxy.cpu().numpy():
                            if not np.isnan(box).any():
                                result_data.append(box.tolist())

    return jsonify({
        "detections": detection_map,
        "boxes": result_data
    })

if __name__ == '__main__':
    app.run(host= '10.10.46.9', port=5000, debug=True)
# $ curl -X POST http://127.0.0.1:5000/predict -H "Content-Type: multipart/form-data" -F "images=@TESTING.zip"
# curl -X POST http://192.168.29.96:5000/predict -H "Content-Type: multipart/form-data" -F "images=@ForTest.zip"
# http:// 10.10.46.9:5000/predict
