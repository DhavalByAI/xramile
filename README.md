## Location Notifier App
Location Notifier is a simple Flutter application that allows users to receive notifications when their current location enters a predefined circular area on the map.

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Requirements](#requirements)
4. [Setup Instructions](#setup-instructions)
5. [Usage Instructions](#usage-instructions)
6. [Project Structure](#project-structure)
7. [Dependencies](#dependencies)

## Introduction
Location Notifier is a minimalistic app that utilizes location services and notifications to provide users with timely alerts based on their location. The app allows users to create circular geofences on the map, and notifications are triggered when the user's device enters the selected area.

## Features
- Request permissions for notifications and location on app launch.
- Interactive map screen to select and modify circular geofences.
- Adjustable radius of the circular geofence using a slider.
- Receive notifications when the device enters the geofence.
- View a list of notifications with details such as title, description, and received date.

## Requirements
- Flutter
- Dart

## Setup Instructions
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/DhavalByAI/xramile/tree/main]
   cd LocationNotifier
   
## Install dependencies:
flutter pub get

## Run the app:
flutter run

## Grant necessary permissions:
Upon launching the app, grant permissions for notifications and location.

## Usage Instructions
1.Map Screen:
Upon granting permissions, the app will open the map screen.
The map will animate to the user's current location.
Tap anywhere on the map to create a circular geofence.
Use the slider at the bottom to adjust the radius of the geofence.

2.Notifications:
Receive notifications when the device enters the selected geofence.
View a list of notifications with details on the notification screen.
Project Structure
The project follows a simple Flutter project structure. Key directories include:

## lib: Contains Dart code for the application.
assets: Placeholder for any image or asset resources.

## Dependencies
  - Flutter
  - cupertino_icons
  - location
  - google_maps_flutter
  - permission_handler
  - firebase_messaging
  - firebase_auth
  - http
  - flutter_local_notifications
  - geolocator
  - flutter_foreground_service
