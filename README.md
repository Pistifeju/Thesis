# Thesis (Under Development)

My thesis is an iOS mobile learning application that helps students learn about human anatomy in a fun and interactive way. With the use of Augmented Reality technology, students can now visualize and explore the human body. In addition, students can also create and take quizzes to test their knowledge. Quizzes make it a powerful tool for anyone looking to improve their understanding of human anatomy.

## Features

* High-quality 3D models of human anatomy.
* Augmented Reality visualization of the human body.
* Quizzes to take and create to test understanding.
* Option to Isolate, Fade and add notes to the different parts of the human body.
* Review feature after taking a quiz.

## Screenshots (2023 Febr. 03)

<p align="center">
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/signIn.PNG" width="200"/>
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/main.PNG" width="200"/>
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/model.PNG" width="200"/>
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/ar1.PNG" width="200"/>
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/ar2.PNG" width="200"/>
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/createQ.PNG" width="200"/>
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/endOfQ.png" width="200"/>
<img src="https://github.com/Pistifeju/Thesis/blob/main/Screenshots/settingsQ.PNG" width="200"/>
</p>

## Requirements

* Apple device: iPhone SE, iPhone 6s and later.
* iOS 15.0 or later.

## Dependencies

* CocoaPods installed (if you don't have it, you can install it by running "sudo gem install cocoapods" in your terminal)
* Firebase

## How to setup the project

Please follow the steps outlined in this README file to set the application, as this is not a finished project yet. The project may not function properly without completing these steps, and you may encounter errors or issues if you attempt to run the project without configuring.

### 1. Clone the project
Clone the project from GitHub by running the following command in your terminal:
`git clone https://github.com/Pistifeju/Thesis`

### 2. Install CocoaPods (if necessary)
If you don't have CocoaPods installed on your computer, you can install it by following these steps: <br />

* Open Terminal on your Mac by pressing Command+Space and typing "Terminal" in the Spotlight search. <br />
* In Terminal, enter the following command to install CocoaPods: <br />
* `sudo gem install cocoapods`

### 3. Install Pods
After installing CocoaPods, navigate to the project directory and install the required dependencies by running the following command in your terminal: `pod install`

If you encounter the error "Signing for 'gRPC-C++-gRPCCertificates-Cpp' requires a development team." during the pod install process, follow these steps to resolve the issue:

* Open your Xcode project.
* In the project navigator on the left, select the top-level project file.
* In the main panel, select your app target.
* Select the "General" tab.
* Under "Signing," select your development team from the dropdown list.
* If you don't have a development team, click on the "Add Account..." button and follow the prompts to create a new Apple Developer account.
* After selecting your development team, try running pod install again.

### 4. Create a Firebase Project

* Go to the Firebase Console and click on the "Add project" button. https://console.firebase.google.com/
* In the "Create a project" dialog, enter a name for your project and select your country/region.
* Click on the "Create project" button to create your new Firebase project.

### 5. Add an iOS App to Your Firebase Project

* In your "Firebase Console", click on the "Add app" button under your new project.
* Enter the bundle identifier for your iOS app. (You can find the bundle identifier in the main Thesis panel > Select App Target > General Tab in Xcode)
* Click on the "Register app" button to register your app with Firebase.
* On the next screen, click on the "Download GoogleService-Info.plist" button to download the Firebase configuration file for your app.
* Add the downloaded GoogleService-Info.plist file to your Xcode project.

### 6. Enable Email Login and Firestore Database
To use authentication in the application, you need to enable it in your Firebase project. Follow these steps to enable email login:

* Go to your Firebase Console and select your project
* Click on the Authentication tab in the left sidebar
* Click on the Sign-in method tab
* Enable the Email/Password provider

To use Firestore database in the application, you need to enable it in your Firebase project. Follow these steps to enable Firestore:
* Go to your Firebase Console and select your project
* Click on the Firestore Database tab in the left sidebar
* Click on the Create Database button
* Select a location for your database and choose Start in test mode
* Click on Enable

## License

This project is licensed under the MIT License.
