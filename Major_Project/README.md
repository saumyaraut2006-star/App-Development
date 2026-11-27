# Major Project: SmartInterestX

## Overview
SmartInterestX is a Flutter application for keeping track of contacts and money transactions, including interest-related records and due dates. It brings these records into one place, so users don't have to maintain them by hand.

## Objectives
- Organise contacts and their transactions
- View the details of each transaction
- Remind users about due dates
- Provide secure sign-in for users

## Features
- User authentication with Firebase
- Home screen
- Contact management
- Transaction cards and a detailed transaction view
- Local storage on the device using Hive
- Due-date reminders using notifications
- Push notification support using Firebase Cloud Messaging

## Technology Stack
| Purpose | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| Authentication | Firebase Authentication |
| Cloud database | Cloud Firestore |
| Local database | Hive |
| State management | Provider |
| Notifications | Local notifications and Firebase Cloud Messaging |

## Project Structure
- lib/main.dart : app entry point
- lib/screens : app screens
- lib/widgets : reusable UI components
- lib/providers : state management
- lib/services : storage and notification services

## How to Run
    flutter pub get
    flutter run -d chrome

Notification features may be limited on the web.

## Developer
Saumya Raut
