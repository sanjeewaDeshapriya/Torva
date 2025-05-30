# 🗺️ Torva - Mobile Treasure Hunt Game

**Bridging Digital Entertainment with Real-World Adventure**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com/)
[![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios/)

## 🌟 Overview

Torva is an innovative mobile treasure hunt game that transforms digital gaming into real-world outdoor exploration. Unlike traditional mobile games that keep users glued to screens indoors, Torva encourages physical activity, social interaction, and authentic discovery by integrating GPS navigation with puzzle-based treasure hunting.

**🎯 Mission**: To reduce screen dependency while promoting outdoor engagement through interactive, location-based gameplay that bridges the digital and physical worlds.

![Torva](https://github.com/user-attachments/assets/c3968f70-32cb-487b-9013-98a704393270)


## ✨ Key Features

### 🔐 **Authentication & User Management**
- Email-based and Google Sign-In authentication
- Secure user profile management with Firebase
- Personalized user profiles with profile picture support

### 🗺️ **Interactive Treasure System**
- **Hide Treasures**: Create virtual treasures at real-world locations
- **Discover Treasures**: Find hidden treasures using GPS navigation
- **Puzzle Integration**: Solve clue-based challenges to unlock treasures
- **Interactive Maps**: Google Maps integration for seamless navigation

### 🏆 **Gamification & Social Features**
- Real-time leaderboard system with points tracking
- User achievements and progress monitoring
- Wishlist functionality for future treasure hunts
- Multiplayer collaborative treasure hunting

### 📱 **Modern Mobile Experience**
- Cross-platform support (Android & iOS)
- Responsive UI with intuitive navigation
- Real-time notifications and updates
- Dark mode support for enhanced accessibility

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Frontend** | Flutter & Dart | Cross-platform mobile development |
| **Authentication** | Firebase Auth | Secure user authentication & Google login |
| **Database** | Firebase Firestore | Real-time data storage & synchronization |
| **Backend Logic** | Firebase Cloud Functions | Server-side processing & code verification |
| **Maps** | Google Maps API | Location services & interactive mapping |
| **Notifications** | Firebase Cloud Messaging | Real-time alerts & push notifications |
| **Version Control** | Git & GitHub | Collaborative development & code management |
| **Development** | VS Code & Android Studio | IDE & debugging tools |

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (Latest stable version)
- **Dart SDK** (Included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS development on macOS)
- **Firebase CLI** (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sanjeewaDeshapriya/Torva.git
   cd Torva
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download and place the configuration files:
     - `google-services.json` in `android/app/`
     - `GoogleService-Info.plist` in `ios/Runner/`

4. **Enable Firebase services**
   - Authentication (Email/Password & Google Sign-In)
   - Cloud Firestore Database
   - Cloud Functions
   - Cloud Messaging

5. **Set up Google Maps API**
   - Enable Google Maps SDK for Android and iOS
   - Add API keys to your app configuration

6. **Run the application**
   ```bash
   # For Android
   flutter run

   # For iOS (macOS only)
   flutter run -d ios
   ```

## 📖 Usage

### For Players

1. **Sign Up/Sign In**: Create an account or sign in with Google
2. **Explore Map**: Browse the interactive map to discover nearby treasures
3. **Hunt Treasures**: Follow GPS navigation and solve puzzles to find treasures
4. **Hide Treasures**: Create your own treasure locations with custom clues
5. **Track Progress**: Monitor your points and ranking on the leaderboard
6. **Social Features**: Add treasures to your wishlist and collaborate with friends

### For Developers

The codebase is organized into several key modules:

- **Authentication Service**: Handles user login/registration
- **Treasure Service**: Manages treasure creation, discovery, and validation
- **User Service**: Handles profile management and user data
- **Location Service**: GPS tracking and distance calculations
- **Notification Service**: Real-time alerts and messaging

## 🏗️ Project Architecture

```
lib/
├── models/          # Data models and entities
├── services/        # Business logic and API services
├── screens/         # UI screens and pages
├── widgets/         # Reusable UI components
├── utils/           # Helper functions and utilities
└── main.dart        # Application entry point
```

## 🎯 Project Scope

### ✅ Current Features
- User authentication (Email & Google)
- Interactive treasure map
- GPS-based navigation
- Puzzle-solving mechanics
- Real-time leaderboard
- User profile management
- Wishlist functionality
- Cross-platform compatibility

### 🔮 Future Enhancements
- **Augmented Reality (AR)** integration for immersive treasure discovery
- **Social Media Integration** for sharing achievements
- **Scheduled Events** and organized treasure hunt competitions
- **Admin Dashboard** for content management
- **Daily Quests** and reward systems
- **Offline Map Support** for areas with limited connectivity

## 👥 Contributors

Special thanks to all developers who contributed to this project:

- **Authentication System** - Sign in/up functionality and user management
- **Treasure Management** - Creation, editing, and discovery features  
- **User Interface** - Profile screens, settings, and welcome pages
- **Leaderboard System** - Points tracking and ranking features
- **Maps Integration** - Location services and navigation
- **Backend Services** - Firebase integration and API development


### Development Guidelines

- Follow Flutter/Dart coding conventions
- Write clear, descriptive commit messages
- Include unit tests for new features
- Update documentation as needed
- Ensure cross-platform compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support & Contact

- **Project Maintainer**: [sanjeewaDeshapriya](https://github.com/sanjeewaDeshapriya)
- **Issues**: [Report bugs or request features](https://github.com/sanjeewaDeshapriya/Torva/issues)
- **Email**: Contact through GitHub for project-related inquiries

## 🙏 Acknowledgments

- **Firebase** for providing comprehensive backend services
- **Google Maps Platform** for location and mapping services
- **Flutter Community** for excellent documentation and resources
- **Open Source Community** for continuous inspiration and support
- **All Beta Testers** who provided valuable feedback during development

---

<div align="center">

**🎮 Ready to turn your neighborhood into an adventure playground?**

[Download Torva](https://github.com/sanjeewaDeshapriya/Torva/releases) • [View Documentation](https://github.com/sanjeewaDeshapriya/Torva/wiki) • [Report Issues](https://github.com/sanjeewaDeshapriya/Torva/issues)



</div>
