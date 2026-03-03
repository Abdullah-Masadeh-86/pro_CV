# pro_CV

A professional Flutter application for creating, managing, and sharing beautiful CVs and resumes. Built with Firebase backend and Material Design 3 for a modern, responsive user experience.

## Features

### 🎨 Professional CV Creation
- **Modern Templates**: Choose from multiple professional CV templates
- **Real-time Preview**: See changes instantly as you build your CV
- **Customizable Sections**: Add/edit personal info, work experience, education, skills, and more
- **Smart Formatting**: Automatic formatting for professional appearance

### 🔐 Secure Authentication
- **Firebase Auth**: Secure email/password authentication
- **Account Management**: Register, login, and password reset functionality
- **Data Protection**: Your CV data is securely stored and encrypted

### 📱 Responsive Design
- **Mobile First**: Optimized for phones and tablets
- **Adaptive Layout**: Different layouts for mobile, tablet, and desktop
- **Material Design 3**: Modern, accessible UI components

### ☁️ Cloud Storage
- **Firebase Backend**: Real-time data synchronization
- **Cloud Storage**: Store and access your CVs from anywhere
- **Offline Support**: Work on your CVs even without internet

### 📤 Export & Share
- **PDF Export**: Download your CV as a professional PDF
- **Share Links**: Share your CV with potential employers
- **Multiple Formats**: Support for different export formats

## Technology Stack

- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Firebase**: Backend services (Auth, Firestore, Storage)
- **BLoC**: State management
- **Material Design 3**: UI framework
- **Responsive Layout**: Adaptive design system

## Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Firebase account

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/pro_CV.git
cd pro_CV
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Firebase:
   - Create a new Firebase project
   - Add Android app with package name `com.cvapp.cv_flutter_app`
   - Download `google-services.json` and place it in `android/app/`
   - Enable Authentication, Firestore, and Storage

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── bloc/                 # BLoC state management
│   └── auth/            # Authentication BLoC
├── models/              # Data models
│   └── cv_models.dart   # CV related models
├── screens/             # UI screens
│   ├── auth/           # Authentication screens
│   ├── cv/             # CV management screens
│   └── home/           # Home screen
├── services/           # Business logic
│   └── firebase_service.dart
├── widgets/            # Reusable UI components
│   ├── cv_card.dart
│   ├── loading_widget.dart
│   └── responsive_layout.dart
└── main.dart           # App entry point
```

## Google Play Store

This app is ready for Google Play publication with:
- ✅ Proper app signing configuration
- ✅ ProGuard rules for code obfuscation
- ✅ Material Design 3 compliance
- ✅ Responsive design for all screen sizes
- ✅ Firebase integration
- ✅ Professional UI/UX

### App Metadata
- **Package Name**: `com.cvapp.cv_flutter_app`
- **App Name**: CV Builder Pro
- **Category**: Business
- **Content Rating**: Everyone
- **Target SDK**: 34 (Android 14)
- **Min SDK**: 21 (Android 5.0)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Email: support@cvbuilderpro.com
- GitHub Issues: [Create an issue](https://github.com/yourusername/pro_CV/issues)

## Screenshots

*Add screenshots of your app here*

---

 **CV Builder Pro** - Build Your Professional Future Today! 🚀
