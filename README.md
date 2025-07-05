# eventsApp

EventsApp is an application for discovering, saving and sharing events in your area. It can also be used for purchasing tickets for the upcoming events.
This system consists of a desktop application designed for administrators and a mobile app tailored for end users. The desktop app is utilized for managing events, tickets, users as well as generating reports.
In contrast, the mobile app enables end users to browse currently active events, purchase tickets or share events in their area.



## Launching the Application

1. After cloning the repository, open the command line, navigate to the folder where the repository is cloned, and initiate the process of dockerization using this command:

- `docker-compose up --build`

### Desktop Application
#### Option 1
Start the desktop application by opening the **eventsappadmin** folder in VSCode and executing the following commands in the terminal:

- `flutter pub get` - to fetch dependencies
- `flutter run` - to launch the application
- Base url is "http://localhost:7294/" by default but it can be changed using `--dart-define=baseUrl=>>NEWURL<<` when running the flutter app.

#### Option 2
Navigate to fit-build-2025-07-05/Release and run eventsappadmin.exe

### Mobile Application
#### Option 1
Start the mobile application by opening the **eventsappusers** folder in VSCode and executing the following commands in the terminal:

- `flutter pub get` - to fetch dependencies
- `flutter run` - to launch the application
- Base url is "http://10.0.2.2:7294/" by default but it can be changed using `--dart-define=baseUrl=>>NEWURL<<` when running the flutter app.
- Stripe publishable key is also set by default but it can be changed using `--dart-define=publishableKey=>>NEWKEY<<` when running the flutter app.

#### Option 2
Navigate to fit-build-2025-07-05/flutter-apk and drag-and-drop app-release.apk to your android emulator

### Credentials

Desktop application:
There are two roles that have access to the admin panel: Admin and Manager.
The Manager role can manage content, events, and tickets, as well as view reports.
The Admin role has all the privileges of a Manager, with the additional ability to manage users.

- username: admin
- password: test
```
- username: desktop
- password: test
```
- username: manager
- password: test
```

Mobile application:
There are two roles that have access to the user application: Admin and User.
All users can browse events, create new events, and purchase tickets.

- username: admin
- password: test
- location: Sarajevo
```
- username: user
- password: test
- location: Sarajevo
```
- username: johndoe
- password: test
- location: Sarajevo
```
- username: janedoe
- password: test
- location: Mostar



#### Test data for Stripe:

- Card number: 4242 4242 4242 4242
- Date: You can enter any date in the future
- CVC: You can enter any 3 numbers
