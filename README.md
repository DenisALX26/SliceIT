# SliceIT 🍕

SliceIt is a mobile application for ordering pizza, designed to provide a smooth and intuitive experience for customers. 
The app allows users to create accounts, log in securely, browse their profile, and view order history. 
It is currently under active development, with a focus on building a reliable backend and a clean, user-friendly mobile UI.

## 🚀 Features (Implemented)

- **User Authentication**
  - Register, log in, and manage your account securely
  - JWT-based authentication integrated with Flutter using Dio

- **Profile Management**
  - Personalized profile page showing logged-in user's name and email

- **Basic Navigation**
  - Mobile app navigation with `go_router`
  - Authentication state persistence using secure token storage

## 🛠 Tech Stack

- **Frontend (Mobile App):** Flutter, Material Design
- **Backend:** Java, Spring Boot, REST API
- **Database:** PostgreSQL (via Spring Data JPA)
- **Authentication & Security:** JWT, BCrypt password hashing
- **State Management:** Provider (Flutter)
- **HTTP Client:** Dio (Flutter)
- **Design:** Figma

## 📂 Project Structure

```
SliceIt/
│
├── backend/                # Spring Boot backend
│   ├── src/main/java/dev/sliceit/backend/
│   │   ├── controller/     # REST controllers
│   │   ├── service/        # Business logic
│   │   ├── repository/     # Database access (JPA)
│   │   └── model/          # Entities and DTOs
│   │
│   └── pom.xml             # Maven dependencies
│
├── frontend/               # Flutter mobile application
│   ├── lib/
│   │   ├── auth/           # Authentication logic
│   │   ├── config/         # App configuration & constants
│   │   ├── repository/     # API calls (Dio)
│   │   ├── screens/        # UI screens (Login, Register, Profile, etc.)
│   │   └── widgets/        # Reusable widgets
│   │
│   └── pubspec.yaml        # Flutter dependencies
│
└── README.md               # Documentation
```

## ⚙️ Installation & Setup

### Backend Setup (Spring Boot)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/SliceIt.git
   cd SliceIt/backend
   ```

2. **Configure the database:**
   - Create a PostgreSQL database (e.g., `sliceit`).
   - Update `application.properties` with your database credentials:
     ```properties
     spring.datasource.url=jdbc:postgresql://localhost:5432/sliceit
     spring.datasource.username=your_username
     spring.datasource.password=your_password
     spring.jpa.hibernate.ddl-auto=update
     ```

3. **Run the backend:**
   ```bash
   mvn spring-boot:run
   ```

### Frontend Setup (Flutter)

1. **Navigate to the frontend folder:**
   ```bash
   cd ../frontend
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

> **Note:** Make sure you have Flutter SDK installed and set up correctly.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

Built by Neacșa-Serafimescu Denis-Alexandru
