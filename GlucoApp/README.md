# GlucoApp - Glucose Monitoring Application (Learning Project)

This project is a simple Android application designed for self-learning Kotlin and the fundamentals of mobile development, particularly focusing on modern Android development practices.

**Disclaimer:** This app is not intended for real-world use, especially for any health-related actions or medical advice. It is purely a learning exercise.

## Description

GlucoApp is a prototype for a glucose monitoring application. It showcases the integration of several modern Android development technologies to create a functional, albeit simplified, mobile application.

### Key Technologies Used

*   **Kotlin:** The primary programming language for Android development.
*   **Jetpack Compose:** Modern toolkit for building native Android UI.
*   **Hilt (Dagger):** Dependency Injection framework for managing app components and their dependencies.
*   **Room Persistence Library:** For local data storage (e.g., glucose readings).
*   **ViewModel:** Part of Android Jetpack's Architecture Components, designed to store and manage UI-related data in a lifecycle-conscious way.
*   **Jetpack Navigation:** For navigating between different screens within the application.
*   **Kotlin Coroutines:** For asynchronous programming and managing background tasks.
*   **Jetpack DataStore:** For storing small, simple data asynchronously and transactionally.

## Features (Expected)

Based on the technologies used, the app likely includes:

*   Recording and displaying glucose readings.
*   Local persistence of data.
*   Navigation between different screens (e.g., data entry, history view).
*   A modern, declarative user interface built with Jetpack Compose.

## How to Build and Run

To build and run this application, you will need Android Studio installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/unseen2004/studies.git
    cd studies/GlucoApp
    ```

2.  **Open in Android Studio:**
    Open the `GlucoApp` directory as an Android Studio project. Android Studio will automatically set up the project and download necessary dependencies.

3.  **Build the project:**
    You can build the project directly from Android Studio (Build > Make Project) or using the Gradle wrapper:
    ```bash
    ./gradlew build
    ```

4.  **Run on a device or emulator:**
    Select a target device (either a physical Android device connected via USB or an Android Emulator) in Android Studio and click the "Run" button.
    The `minSdk` version is 26, so ensure your device/emulator runs Android 8.0 (Oreo) or newer.

5.  **Clean the project (optional):**
    ```bash
    ./gradlew clean
    ```