import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive_io.dart';

import '../../../../localization/item_class.dart';
import '../checkout_pages/check_out_page.dart';

class CameraSetupPage extends StatefulWidget {

  const CameraSetupPage({super.key});


  @override
  State<CameraSetupPage> createState() => _CameraSetupPage();
}

class _CameraSetupPage extends State<CameraSetupPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  Map<String, Item> items = {};
  late Map<String, int> checkoutdata = {};
  late Map<String, int> lowercheckoutdata = {};
  List<File> capturedPictures = [];
  String destinationPath='/storage/emulated/0/Download/captured_image.zip';

  SupabaseClient get __supabase => Supabase.instance.client;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _deleteZipFile();
    _fetchItemsFromSupabase();
    _setupCameraController();
  }

  Future<void> _fetchItemsFromSupabase() async {
    try {
      final response = await __supabase.from('newitems').select();

      if (response != null) {
        setState(() {
          items = Map.fromEntries(
            (response as List<dynamic>).map((itemData) {
              return MapEntry(
                itemData['details']['name'].toString(),
                Item(
                  id: itemData['id'].toString(),
                  name: itemData['details']['name'].toString(),
                  subText: itemData['details']['subText'].toString(),
                  price: itemData['details']['price'] != null
                      ? double.tryParse(itemData['details']['price'].toString())
                      : null,
                  variants: itemData['details']['variants'] != null
                      ? List<Map<String, dynamic>>.from(itemData['details']['variants'])
                      .map((variantData) => Variant.fromJson(variantData))
                      .toList()
                      : [],
                ),
              );
            }),
          );
        });
      }
    } catch (e) {
      print('Error fetching items from Supabase: $e');
    }
  }
  void _deleteZipFile() async {
    // Specify the path to the zip file
    final filePath = destinationPath;

    // Create a File object
    final file = File(filePath);

    // Check if the file exists
    if (await file.exists()) {
      try {
        // Delete the file
        await file.delete();
        print('File deleted successfully!!!!!!!!!!!!!!!!!!.');
      } catch (e) {
        print('Error deleting file: $e');
      }
    } else {
      print('File does not exist.');
    }
  }

  Future<void> fetchData(File zipFile) async {
    String apiUrl = 'http://10.10.46.9:5000/predict';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('images', zipFile.path));
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(responseBody);
        List<List<double>> boxes = List<List<double>>.from(
            data['boxes'].map((box) => List<double>.from(box)));
        Map<String, int> detections = Map<String, int>.from(data['detections']);
        checkoutdata = detections;
        lowercheckoutdata = {};
        checkoutdata.forEach((key, value) {
          lowercheckoutdata[key.toLowerCase()] = value;
        });
        print(lowercheckoutdata);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckOutPage(items: items, checkoutdata: lowercheckoutdata),
          ),
        );
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _capturePicture() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        // Ensure the camera is not already taking a picture
        if (!cameraController!.value.isTakingPicture) {
          XFile picture = await cameraController!.takePicture();

          setState(() {
            capturedPictures.add(File(picture.path));
          });

          print('Picture captured: ${picture.path}');
        }
      } catch (e) {
        print('Error capturing picture: $e');
      }
    } else {
      print('Camera is not initialized');
    }
  }

  Future<void> _createAndSendZip(String destinationPath) async {
    try {
      // 1. Create the zip encoder.
      final archive = Archive();
      print(capturedPictures);
      print("hello");
      // 2. Add each image file to the archive.
      for (File file in capturedPictures) {
        final fileBytes = await file.readAsBytes();
        final fileName = file.path.split('/').last;
        archive.addFile(ArchiveFile(fileName, fileBytes.length, fileBytes));
      }

      // 3. Encode the archive into a zip file.
      final zipEncoder = ZipEncoder();
      final zipFileData = zipEncoder.encode(archive)!;

      // 4. Create the zip file at the specified destination path.
      final zipFile = File(destinationPath);
      await zipFile.writeAsBytes(zipFileData);

      // 5. Send the zip file to the fetchData function.
      await fetchData(zipFile);

      print('Zip file created and sent successfully!');
      print("hello");
    } catch (e) {
      print('Error creating and sending zip file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5580,
              width: MediaQuery.sizeOf(context).width * 0.84,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffBAF0B8),
                    width: 5.0,
                  ),
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: CameraPreview(
                    cameraController!,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.20,
              width: MediaQuery.sizeOf(context).width * 0.80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.09,
                        width: MediaQuery.sizeOf(context).height * 0.10,
                        decoration: const BoxDecoration(
                          color: Color(0xff56B253),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45.0),
                            topRight: Radius.circular(0.0),
                            bottomLeft: Radius.circular(45.0),
                            bottomRight: Radius.circular(0.0),
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: _capturePicture,
                            iconSize: 50,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4,),
                      const Text(
                        'Scan',
                        style: TextStyle(
                          fontFamily: 'lexend',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.09,
                        width: MediaQuery.sizeOf(context).height * 0.10,
                        decoration:const BoxDecoration(
                          color: Color(0xffBAF0B8),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(45.0),
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(45.0),
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () async {
                              // final byteData = await rootBundle.load('assets/images/your_images.zip');
                              // final tempDir = Directory.systemTemp;
                              // final tempFile = File('${tempDir.path}/your_images.zip');
                              // await tempFile.writeAsBytes(byteData.buffer.asUint8List());
                              // await fetchData(tempFile);
                              await _createAndSendZip(destinationPath);
                            },
                            iconSize: 50,
                            icon: Icon(
                              Icons.directions_walk,
                              color: Color(0xff56B253),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4,),
                      const Text(
                        'Checkout',
                        style: TextStyle(
                          fontFamily: 'lexend',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );
      });
      cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError(
            (Object e) {
          print(e);
        },
      );
    }
  }
}
