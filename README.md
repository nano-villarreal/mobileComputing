Name of Project: Chore Management App

Team Members: Jon Brown, Emiliano Villareal, Vineel Mandava, Dagmawi Gebreyes (did not participate)

Dependencies: Xcode 14.0, Swift 5.7, Firebase Packages: FirebaseFireStore, FirebaseAuth, FirebaseFirestoreSwift, FirebaseDatabase

Instructions: 

* Use an iPhone 14 Pro simulator
* If packages don’t work:
    * Remove existing package dependencies
    * Add package: [https://github.com/firebase/firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk)
    * Select specific packages: FirebaseAuth, FirebaseFirestore, FirebaseFirestoreSwift
* Use this test account for logging in:
    * Email: williambulko@gmail.com
    * Password: password
* Sample list of joinable rooms:
    * Room Name: MyApartment, Password: myapartment123
    * Room Name: TestApartment, Password: testroom
* Settings and Rooms Joined are saved by user in Firebase (i.e if a User switches to Dark Mode it will save their preference and display Dark Mode on each login)

Required Features:

* Login/register path with Firebase
* Settings Screen. The three behaviors we implemented were:
    * Toggle Dark mode on/off
    * Toggle Notifications on/off
    * Slider to change font size throughout app
* Non-Default fonts/colors used

Two major elements used:

* Multithreading
    * Used to control when certain functions were run (welcome animation, updating screen, etc.) to make sure functions don’t overlap and cause issues
* SwiftUI
    * Used to design the page that shows the tasks completed for whichever room the user is looking at

Minor Elements used:

* Two Additional View types, The two that we used were:
    * Sliders (font slider), switches (toggle settings), also used segmented controller for Log In/Sign Up page
    
* One of the following:
    * Table View: used to display rooms and to display the tasks that need to be completed within the room
    
* Two of the following:
    * Alerts: appears when removing a task from the list of tasks in a room
    * User Defaults: stored default objects with NSString and NSArray data types
    
* At least one of the following per team member (only 3 because of non-participant):
    * Local notifications: notification appears after you join a room notifying you that the room has been joined
    * Gesture Recognition: When viewing a room, ability to swipe up on the screen to view completed tasks
    * Animation: welcome screen was implemented using animation

Work Distribution Table:
* Login / Register: Allows user to create account and login - Jon (100%)
* UI Design: Design that allows users to interact with the application - Jon (33%), Emiliano (33%), Vineel (33%)
* Settings: Allows users to toggle dark mode, toggle notifications, and change font size - Jon (100%)
* SwiftUI: Used SwiftUI to show completed tasks - Vineel (100%)
* Create/Join Room Functionality: Implemented View Controllers for users to create and join rooms - Emiliano (100%)
* Completed Tasks Functionality: Worked with the Firebase Database to keep track of and display completed tasks per room - Emiliano (100%)
* Firebase Database: Set up the database on Firebase with necessary fields for each user and room - Jon (50%), Emiliano (25%), Vineel (25%)
* Alerts/Notifications: Created Local Notifications for when users join rooms and Alerts for when they complete a task - Vineel (100%)
* Welcome Animation: Displays animated welcome screen when logging in - Jon (100%)
* Table Views: Functionality to populate list of rooms/tasks from the Firebase Database - Jon (33%), Emiliano (33%), Vineel (33%)
* Multithreading: Controlling when functions run so as to not interfere with other functions being called - Jon (33%), Emiliano (33%), Vineel (33%)
* Gesture Recognition: Allows users to swipe up on screen to view completed tasks - Emiliano (100%)
* Project conception/wireframe design - Brainstormed project ideas and made wireframe to visualize project - Jon (33%), Emiliano (33%), Vineel (33%)
