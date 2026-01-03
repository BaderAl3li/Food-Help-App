# FoodShare App - Complete iOS Storyboard Project

## Overview
This is a complete iOS application project for a food donation app that connects food donors with verified NGOs and organizations. The app includes a comprehensive multi-step donation flow, organization discovery, and notification systems.

## Project Structure
```
FoodShareApp/
├── FoodShareApp.xcodeproj/
│   └── project.pbxproj
├── FoodShareApp/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Info.plist
│   ├── ViewControllers/
│   │   ├── HomeViewController.swift
│   │   ├── BasicInfoViewController.swift
│   │   ├── DonationViewControllers.swift
│   │   └── OrganizationViewControllers.swift
│   ├── Storyboards/
│   │   ├── Main.storyboard
│   │   └── LaunchScreen.storyboard
│   └── Assets.xcassets/
│       ├── AppIcon.appiconset/
│       └── AccentColor.colorset/
```

## Features Implemented

### 1. Complete Storyboard with 9 Screens:
- **Home Screen**: My Active Donations with status cards
- **Donation Step 1**: Basic Information form
- **Donation Step 2**: Add Photos with tips
- **Donation Step 3**: Quantity & Expiry details
- **Donation Step 4**: Pickup Location with map
- **Confirmation Screen**: Success state with next steps
- **Organizations List**: Searchable directory with filters
- **Organization Profile**: Detailed view with metrics
- **Notifications**: Empty state and notification feed

### 2. Navigation Flow:
- Tab Bar Controller with 5 tabs (Home, Donation, Discover, Notifications, Profile)
- Sequential navigation through donation steps
- Proper segues between all screens

### 3. UI Components:
- Custom form fields with purple borders (#BA9CFE)
- Rounded corners and shadows throughout
- Status badges with appropriate colors
- Filter chips and search functionality
- Metric cards with impact statistics

### 4. Design System:
- **Primary Color**: Purple (#4A249D / #7B61FF)
- **Secondary Color**: Light Purple (#BA9CFE)
- **Status Colors**: Green (#34C759), Red (#FF3B30), Orange (#FFA500)
- **Typography**: Poppins font family (with San Francisco fallback)
- **Spacing**: 8px base unit, 16px between sections
- **Border Radius**: 12-16px for cards, 10px for form fields

## Technical Specifications

### Compatibility:
- **Xcode Version**: 13.0+
- **iOS Deployment Target**: 15.0
- **macOS Compatibility**: 12.0.1+
- **Device Support**: iPhone and iPad (Universal)

### Architecture:
- MVC pattern with separate view controllers
- Storyboard-based UI with Auto Layout constraints
- Programmatic styling in view controllers
- Asset catalog for colors and icons

## Key View Controllers:

### HomeViewController
- Displays active donations with status cards
- Implements card styling with shadows and rounded corners

### BasicInfoViewController
- Multi-field form with validation
- Category picker with action sheet
- Custom form field styling

### DonationViewControllers
- AddPhotosViewController: Photo grid with tips
- QuantityExpiryViewController: Form with date picker
- PickupLocationViewController: Address form with map preview
- ConfirmationViewController: Success state with action buttons

### OrganizationViewControllers
- OrganizationListViewController: Searchable list with filters
- OrganizationProfileViewController: Scrollable profile with metrics
- NotificationViewController: Empty state implementation

## Setup Instructions:

1. Open `FoodShareApp.xcodeproj` in Xcode 13 or later
2. Select your development team in project settings
3. Choose target device (iPhone or iPad)
4. Build and run the project

## Design Features:

### Form Styling:
- Purple borders with shadows
- Consistent padding and margins
- Placeholder text styling
- Interactive elements with proper states

### Card Components:
- Donation cards with status badges
- Organization cards with metrics
- Summary cards with structured information
- Proper spacing and typography hierarchy

### Navigation:
- Tab bar with system icons
- Sequential flow through donation steps
- Back navigation support
- Proper view controller transitions

## Color Palette:
```swift
Primary Purple: #4A249D
Secondary Purple: #BA9CFE
Background White: #FFFFFF
Card Background: #F8F8F8
Text Primary: #000000
Text Secondary: #666666
Text Placeholder: #ADADAD
Status Green: #34C759
Status Red: #FF3B30
Status Orange: #FFA500
```

This project is ready to run in Xcode 13 on macOS 12.0.1 and provides a complete foundation for a food donation application with all screens, navigation, and styling implemented according to the design specifications.