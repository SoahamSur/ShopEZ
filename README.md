---

# ShopEZ

**ShopEZ** is an innovative app designed to support grassroots and suburban shopkeepers by simplifying their transaction processes and helping them efficiently track their earnings. This app aims to modernize the traditional "udharii" system, where shopkeepers extend credit to customers, by digitizing the khata (ledger) process. The conventional pen-and-paper method is not only tedious but also prone to errors. In a world where smartphones are ubiquitous, ShopEZ offers a digital solution that ensures accuracy, reduces manual effort, and enhances the overall billing process.

## Features

- **Digital Khata Management:** Replace traditional ledgers with a digital version that automatically tracks customer dues and payments.
- **Item Recognition:** Leverages YOLOv8 for real-time item recognition to simplify billing and inventory management.
- **Customer Management:** Maintain records of all transactions and dues per customer, easily accessible through the app.
- **Seamless Transactions:** Simplifies the billing process and minimizes errors by digitizing records and using advanced models.
  
## Tech Stack

- **Frontend:** Flutter
- **Backend:** Flask, Python
- **Database:** Supabase
- **Machine Learning:** YOLOv8 (via OpenCV)
- **Dataset:** LobeFlow / Grocery Items DB by IIT Patna

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-repo/ShopEZ.git
   ```
2. **Navigate to the Project Directory:**
   ```bash
   cd ShopEZ
   ```
3. **Install Dependencies:**
   - For the Flutter frontend:
     ```bash
     flutter pub get
     ```
   - For the Flask backend:
     ```bash
     pip install -r requirements.txt
     ```

4. **Set Up Supabase:**
   - Create a Supabase project and configure the database.
   - Add the necessary environment variables for Supabase in the Flutter app.

5. **Run the Application:**
   - Start the Flask server:
     ```bash
     python app.py
     ```
   - Run the Flutter app:
     ```bash
     flutter run
     ```

## Usage

- **Item Recognition:** Capture items using the app's camera, and YOLOv8 will automatically identify them and add them to the bill.
- **Customer Transactions:** Add, update, and track customer transactions, including dues and payments.
- **Reports:** Generate daily, weekly, or monthly reports to analyze shop earnings and customer dues.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes. Make sure to follow the contribution guidelines.
