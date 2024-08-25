![Banner](https://pbs.twimg.com/profile_banners/1669056908463083520/1724575734/1080x360)

# ShopEZ

**ShopEZ** is an innovative app designed to support grassroots and suburban shopkeepers by simplifying their transaction processes and helping them efficiently track their earnings. This app aims to modernize the traditional "udharii" system, where shopkeepers extend credit to customers, by digitizing the khata (ledger) process.
The conventional pen-and-paper method is not only tedious but also prone to errors. In a world where smartphones are ubiquitous, ShopEZ offers a digital solution that ensures accuracy, reduces manual effort, and enhances the overall billing process.

## Features

- **Digital Khata Management:** Replace traditional ledgers with a digital version that automatically tracks customer dues and payments.
- **Item Recognition:** Leverages YOLOv8 for real-time item recognition to simplify billing and inventory management.
- **Customer Management:** Maintain records of all transactions and dues per customer, easily accessible through the app.
- **Seamless Transactions:** Simplifies the billing process and minimizes errors by digitizing records and using advanced models.
  
## Tech Stack

- **Frontend:** Flutter, Dart
- **Backend:** Flask, Python
- **Database:** Supabase
- **Machine Learning:** YOLOv8 (via OpenCV)
- **Dataset:** LobeFlow / Grocery Items DB by IIT Patna

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-repo/ShopEZ.git

2. **Navigate to the Project Directory:**
   ```bash
    cd ShopEZ
3. **Install Dependencies:**

  For the Flutter frontend:
  ```bash
    flutter pub get
  ```
  For the Flask backend:
  ```bash
    pip install -r requirements.txt
```
 4. **Set Up Supabase:**
    Create a Supabase project and configure the database.
    Add the necessary environment variables for Supabase in the Flutter app.

  5.**Start the Flask server:**
  
  6.**Run the Flutter app:**

## Unique Selling Points (USPs)

- **Empowering Grassroots Shopkeepers:** ShopEZ is tailored specifically for grassroots and suburban shopkeepers who often rely on traditional methods for tracking transactions. The app empowers them by providing a simple, yet effective digital solution that eliminates the hassle of maintaining paper ledgers.

- **Digitization of the "Udharii" System:** By transforming the manual khata system into a digital format, ShopEZ ensures that every transaction is accurately recorded and easily accessible. This reduces the chances of errors and mismanagement, which are common with paper-based systems.

- **SMS Reminders for Dues:** One of the standout features of ShopEZ is the ability for shopkeepers to send SMS reminders to customers who have outstanding dues. This not only helps in timely collection but also fosters better customer relationships by providing gentle and professional reminders.

- **Real-time Item Recognition:** Leveraging YOLOv8, the app offers real-time item recognition, making billing faster and more accurate. This feature is particularly beneficial in busy shops where quick transactions are crucial.

- **User-Friendly Interface:** ShopEZ is designed with a simple and intuitive interface, making it easy for shopkeepers of all tech-savviness levels to adopt and use the app effectively.

--- 
## WorkFlow
![Banner](https://i.imgur.com/LfWuvKB.png)

## Usage

- **Item Recognition:** Capture items using the app's camera, and YOLOv8 will automatically identify them and add them to the bill.
- **Customer Transactions:** Add, update, and track customer transactions, including dues and payments.
- **Reports:** Generate daily, weekly, or monthly reports to analyze shop earnings and customer dues.

## Future Scope Of Work
![Banner](https://i.imgur.com/3OK6vSv.png)

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes. Make sure to follow the contribution guidelines.
