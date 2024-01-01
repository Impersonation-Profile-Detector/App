# Im-persona

Welcome to Im-persona! This Flutter application is designed to detect impersonation profiles across various Online Social Networks (OSNs). It utilizes a machine learning model along with APIs to detect fake profiles on platforms like Instagram and X.

## Project Structure

The project structure is organized for clarity and ease of development. Here's a brief overview:

```bash
.\lib
├── Screens
│   ├── camera.dart
│   ├── homepage.dart
│   ├── insta_results.dart
│   ├── onboard.dart
│   └── x_results.dart
├── Theme
│   └── theme.dart
├── Widgets
│   ├── display_insta.dart
│   └── display_x.dart
├── firebase_options.dart
├── main.dart
```

- **Screens:** Contains different screens/pages of the application, each serving a specific purpose.
- **Theme:** Holds the theme configuration for consistent styling across the app.
- **Widgets:** Reusable UI components used across multiple screens.
- **firebase_options.dart:** Configuration file for Firebase setup.
- **main.dart:** The main entry point of the Flutter application.

## Workflow

1. **Client Request:**
   - The client initiates the process by making an API call to the chosen OSN.

2. **Firebase Data Upload:**
   - The data received from the API call (json response) is uploaded to Firebase Firestore.

3. **Data Retrieval in Python:**
   - Python script retrieves the uploaded data from Firebase.

4. **Face Comparison Model:**
   - Utilizes the deepface model with VGG face comparison and OpenCV face detection to compare faces.

5. **Result Upload to Firebase:**
   - The results of face comparison are uploaded back to Firebase Firestore.

6. **Result Presentation to Client:**
   - The client is presented with the detection results.

## ML Model Details

- **Model:** Deepface
- **Face Comparison:** VGG
- **Face Detection:** OpenCV

## Getting Started

To run the project locally, follow these steps:

1. Clone the repository.
2. Set up Firebase configurations in `firebase_options.dart`.
3. Ensure Flutter is installed and run `flutter pub get` to install dependencies.
4. Run the application using `flutter run`.

## Contributions

Contributions to the project are welcome! If you find any issues or have suggestions, feel free to create a pull request or open an issue.

## License

Feel free to reach out if you have any questions or need further assistance. Happy coding!
