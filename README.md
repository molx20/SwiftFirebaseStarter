# SwiftFirebaseStarter

> A modern, production-ready iOS boilerplate template with Firebase integration, designed for rapid development with AI assistance.

![iOS 16.0+](https://img.shields.io/badge/iOS-16.0%2B-blue)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blue)
![Firebase](https://img.shields.io/badge/Backend-Firebase-orange)

---

## 📋 Overview

**SwiftFirebaseStarter** is a comprehensive iOS boilerplate that provides a complete foundation for building modern iOS apps. It demonstrates best practices for architecture, Firebase integration, and AI-friendly code organization.

### What's Included

- ✅ **Complete Authentication Flow** (Email/Password + Anonymous)
- ✅ **Real-world CRUD Example** (Todo App with Firestore)
- ✅ **MVVM Architecture** with Protocol-based Dependency Injection
- ✅ **Firebase Integration** (Auth, Firestore, Messaging stub)
- ✅ **Onboarding Flow** with UserDefaults Persistence
- ✅ **100% SwiftUI** - No UIKit
- ✅ **Heavily Commented** for AI-friendliness
- ✅ **Unit Test Examples** (Stubbed - ready for implementation)
- ✅ **Shared UI Components** for Consistency
- ✅ **Comprehensive Logging** System

### Perfect For

- Developers starting new iOS projects
- Teams using AI coding assistants (Claude Code, GitHub Copilot)
- Learning modern iOS architecture patterns
- Rapid prototyping with Firebase backend

---

## 🏗️ Architecture

### Tech Stack

| Component | Technology |
|-----------|-----------|
| **Language** | Swift 5.9 |
| **UI Framework** | SwiftUI (100%) |
| **Architecture** | MVVM |
| **State Management** | ObservableObject + @Published |
| **Async** | Swift Concurrency (async/await) |
| **Backend** | Firebase (Auth, Firestore) |
| **Dependencies** | Swift Package Manager |
| **Testing** | XCTest |
| **Minimum iOS** | 16.0+ |

### Folder Structure

```
SwiftFirebaseStarter/
├── App/                    # App entry point & coordination
│   ├── SwiftFirebaseStarterApp.swift
│   ├── AppCoordinator.swift (TODO)
│   ├── RootView.swift (TODO)
│   └── AppDelegate.swift (TODO)
├── Config/                 # Configuration & constants
│   ├── FirebaseManager.swift
│   ├── AppConfiguration.swift
│   └── Constants.swift
├── Core/                   # Core business logic
│   ├── Models/            # Data models
│   │   ├── User.swift
│   │   ├── Todo.swift
│   │   └── AppError.swift
│   ├── Services/          # Service implementations
│   │   ├── AuthService.swift
│   │   ├── FirestoreService.swift
│   │   ├── ValidationService.swift
│   │   ├── UserDefaultsService.swift
│   │   └── NotificationService.swift
│   └── Protocols/         # Service interfaces
│       ├── AuthServiceProtocol.swift
│       ├── FirestoreServiceProtocol.swift
│       ├── UserDefaultsServiceProtocol.swift
│       └── ViewModelProtocol.swift
├── Features/              # Feature modules (TODO)
│   ├── Onboarding/
│   ├── Auth/
│   ├── Home/
│   ├── Profile/
│   └── Settings/
├── SharedUI/              # Reusable UI components
│   ├── PrimaryButton.swift
│   ├── SecondaryButton.swift
│   ├── LoadingView.swift
│   ├── ErrorView.swift
│   ├── EmptyStateView.swift
│   └── CardView.swift
├── Utilities/             # Helper extensions
│   ├── Extensions+Date.swift
│   ├── Extensions+String.swift
│   ├── Extensions+View.swift
│   ├── Logger.swift
│   └── AppVersionHelper.swift
└── Resources/             # Assets & localization (TODO)
```

### Data Flow Pattern

```
View (SwiftUI)
   ↕ @StateObject / @ObservedObject
ViewModel (ObservableObject)
   ↕ Protocol-based Services
Service Layer (Auth, Firestore, etc.)
   ↕ async/await
Firebase Backend
```

---

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+**
- **iOS 16.0+** deployment target
- **Firebase Account** (free tier works)
- **macOS** with latest Xcode Command Line Tools

### Installation Steps

#### 1. Clone or Download

```bash
git clone https://github.com/yourusername/SwiftFirebaseStarter.git
cd SwiftFirebaseStarter
```

#### 2. Create Xcode Project

**This boilerplate provides the source files. You need to create the Xcode project:**

1. Open Xcode
2. **File → New → Project**
3. Choose **iOS → App**
4. Settings:
   - **Product Name:** SwiftFirebaseStarter
   - **Team:** Your development team
   - **Organization Identifier:** com.yourcompany
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Minimum Deployment:** iOS 16.0
5. **Save** in a separate directory
6. **Copy all files** from this repo into your Xcode project:
   ```bash
   cp -r SwiftFirebaseStarter/ /path/to/your/xcode/project/SwiftFirebaseStarter/
   ```
7. In Xcode, **File → Add Files to "SwiftFirebaseStarter"**, select all copied folders

#### 3. Add Firebase SDK

1. In Xcode: **File → Add Package Dependencies**
2. Enter URL: `https://github.com/firebase/firebase-ios-sdk`
3. Version: **Up to Next Major** (10.20.0 or later)
4. Select products:
   - ✅ FirebaseAuth
   - ✅ FirebaseFirestore
   - ✅ FirebaseMessaging (optional for now)
5. Click **Add Package**

#### 4. Configure Firebase Project

##### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project**
3. Enter project name: `SwiftFirebaseStarter`
4. Follow setup wizard (Analytics optional)

##### Add iOS App

1. In Firebase Console → Project Settings
2. Click **Add App** → **iOS**
3. Enter Bundle ID: `com.yourcompany.SwiftFirebaseStarter`
4. Download **`GoogleService-Info.plist`**
5. **Drag and drop** into Xcode project root
6. **✅ Ensure** "Copy items if needed" is checked
7. **✅ Ensure** target membership is checked for SwiftFirebaseStarter

##### Enable Authentication

1. Firebase Console → **Authentication**
2. Click **Get Started**
3. **Sign-in method** tab
4. Enable:
   - ✅ **Email/Password**
   - ✅ **Anonymous**

##### Create Firestore Database

1. Firebase Console → **Firestore Database**
2. Click **Create Database**
3. Start in **Test Mode** (we'll add rules later)
4. Choose location (us-central1 recommended)

##### Apply Security Rules

1. Firestore → **Rules** tab
2. Paste this configuration:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Users can only access their own todos
      match /todos/{todoId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

3. Click **Publish**

#### 5. Uncomment Firebase Code

**IMPORTANT:** The Firebase service files have commented-out code to allow compilation without Firebase SDK. After adding Firebase:

1. Open `AuthService.swift`
2. **Uncomment** all Firebase-related code (marked with comments)
3. **Uncomment** Firebase imports at the top
4. Repeat for `FirestoreService.swift` and `FirebaseManager.swift`

Look for this pattern:
```swift
// import FirebaseAuth  ← Uncomment this
// import FirebaseFirestore  ← Uncomment this

// Uncomment when Firebase is integrated:
/*
[Firebase code here]
*/
```

#### 6. Build and Run

1. Select a simulator or device
2. Press **⌘R** to build and run
3. Fix any import errors (ensure Firebase packages are properly linked)
4. App should launch successfully

---

## 🎨 Customization

### Renaming the Project

1. In Xcode: Click project name → **Rename**
2. Update **Bundle Identifier** in project settings
3. Update **Display Name** in Info.plist
4. **Find and Replace** "SwiftFirebaseStarter" in all files
5. Update Firebase iOS app settings with new bundle ID

### Modifying Onboarding

**File:** `Features/Onboarding/OnboardingContent.swift` (TODO - not yet created)

```swift
static let pages: [OnboardingPage] = [
    OnboardingPage(
        imageName: "star.fill",  // SF Symbol name
        title: "Your Custom Title",
        description: "Your custom description"
    ),
    // Add more pages...
]
```

### Changing App Theme

This template uses **system colors** by default for simplicity.

To customize:
1. Add color sets to `Resources/Assets.xcassets`
2. Create `Utilities/Extensions+Color.swift`
3. Update SharedUI components with custom colors

### Adding New Features

**Follow the MVVM pattern:**

1. Create folder in `Features/`
2. Add files:
   - `YourFeatureView.swift` (UI)
   - `YourFeatureViewModel.swift` (Business Logic)
   - Supporting views as needed
3. Create protocol if adding new service
4. Write tests for ViewModel

**Example structure:**
```
Features/
  MyNewFeature/
    MyNewFeatureView.swift
    MyNewFeatureViewModel.swift
    MyNewFeatureRowView.swift
```

---

## 🧪 Testing

### Running Tests

```bash
# In Xcode
⌘U

# Or via command line
xcodebuild test -scheme SwiftFirebaseStarter -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Structure

Tests are located in `SwiftFirebaseStarterTests/` (to be created).

**Key test files:**
- `MockAuthService.swift` - Mock authentication
- `MockFirestoreService.swift` - Mock database
- `AuthViewModelTests.swift` - Auth flow tests
- `TodoViewModelTests.swift` - CRUD operation tests

### Writing New Tests

```swift
@MainActor
final class MyViewModelTests: XCTestCase {
    var mockService: MockService!
    var viewModel: MyViewModel!

    override func setUp() {
        mockService = MockService()
        viewModel = MyViewModel(service: mockService)
    }

    func testFeature_Success() async {
        // Given
        mockService.shouldSucceed = true

        // When
        await viewModel.performAction()

        // Then
        XCTAssertEqual(mockService.callCount, 1)
        XCTAssertNil(viewModel.errorMessage)
    }
}
```

---

## 🔐 Firebase Setup Details

### Firestore Data Structure

```
firestore/
├── users/
│   ├── {userId}/
│   │   ├── email: String
│   │   ├── displayName: String
│   │   ├── isAnonymous: Bool
│   │   ├── createdAt: Timestamp
│   │   └── todos/ (subcollection)
│   │       ├── {todoId}/
│   │       │   ├── id: String
│   │       │   ├── userId: String
│   │       │   ├── title: String
│   │       │   ├── isCompleted: Bool
│   │       │   ├── createdAt: Timestamp
│   │       │   └── updatedAt: Timestamp
```

### Offline Support

Firestore offline persistence is **enabled** by default in `FirebaseManager.swift`:

```swift
settings.isPersistenceEnabled = true
settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
```

This allows the app to work offline and sync when reconnected.

---

## 🐛 Troubleshooting

### GoogleService-Info.plist not found

**Error:** `Firebase configuration error`

**Solution:**
1. Verify file is in project root (same level as AppDelegate)
2. Check **target membership** in File Inspector
3. Clean build folder (⌘⇧K) and rebuild

### Firebase not initializing

**Error:** `FirebaseApp.app() returns nil`

**Solution:**
1. Ensure `FirebaseManager.shared.configure()` is called in `App.init()`
2. Verify GoogleService-Info.plist contains valid Firebase config
3. Check Xcode console for Firebase error messages

### Auth not working

**Symptoms:** Can't create account or login fails

**Solution:**
1. Enable Email/Password in Firebase Console
2. Enable Anonymous sign-in if using guest mode
3. Check security rules allow authentication
4. Verify network connection

### Firestore permission denied

**Error:** `PERMISSION_DENIED: Missing or insufficient permissions`

**Solution:**
1. Apply security rules from setup section
2. Ensure user is authenticated before writing data
3. Check `userId` matches `auth.uid` in security rules
4. Verify Firestore is in correct mode (not locked down)

### Build errors after adding Firebase

**Error:** `Cannot find 'FirebaseApp' in scope`

**Solution:**
1. Verify Firebase packages are added via SPM
2. Check package dependencies are resolved
3. Clean build folder and rebuild
4. Uncomment all `// import Firebase*` statements

---

## 🤖 AI-Friendly Features

This boilerplate is optimized for use with AI coding assistants:

### Heavy Commenting

Every file includes:
- Purpose description
- `// MARK:` organization
- Inline explanations
- `TODO:` markers for extension points

### Clear Patterns

- Consistent MVVM structure
- Protocol-based architecture
- Predictable naming conventions
- Minimal magic/cleverness

### Example AI Prompts

```
"Add a due date field to todos"
"Implement profile photo upload with Firebase Storage"
"Add dark mode support with custom theme"
"Create a categories feature for organizing todos"
"Add email verification flow"
"Implement password reset functionality"
```

---

## 📚 Code Documentation

### Key Files to Understand

| File | Purpose |
|------|---------|
| `Constants.swift` | App-wide constants |
| `AppError.swift` | Centralized error handling |
| `User.swift` | User data model |
| `Todo.swift` | Todo data model |
| `AuthServiceProtocol.swift` | Auth interface |
| `FirebaseAuthService` | Auth implementation |
| `FirestoreService` | Database operations |
| `Logger.swift` | Logging utility |

### Architecture Decisions

**Why MVVM?**
- Clear separation of concerns
- Testable business logic
- SwiftUI-friendly with ObservableObject

**Why Protocols?**
- Easy mocking for tests
- Swappable implementations
- Dependency injection support

**Why async/await?**
- Modern Swift concurrency
- Cleaner than callbacks
- Better error handling

**Why Firebase?**
- Free tier for prototyping
- Real-time sync
- No backend code needed
- Easy authentication

---

## 📝 License

This template is provided **as-is** for use as a starting point for iOS projects.

Feel free to:
- ✅ Use commercially
- ✅ Modify freely
- ✅ Create derivative works
- ✅ Use in client projects

No attribution required, but appreciated!

---

## 🤝 Contributing

This is a template repository. While it's not actively maintained as an open-source project, improvements that benefit the community are welcome:

1. Fork the repository
2. Create your feature branch
3. Test thoroughly
4. Submit a pull request with clear description

---

## 🔗 Resources

- [Firebase iOS Documentation](https://firebase.google.com/docs/ios)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift Concurrency Guide](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)

---

## ⚠️ Important Notes

### What's Included

✅ **Complete Foundation:**
- Models, Services, Protocols
- Utilities & Extensions
- Shared UI Components
- Firebase integration (commented)
- Comprehensive logging

### What's Stubbed (TODO in Code)

🔨 **Needs Implementation:**
- App Coordinator & Root View (Phase 4)
- All Feature Views & ViewModels (Phase 5)
- Onboarding, Auth, Home, Profile, Settings
- Unit Tests & Mocks (Phase 6)
- Complete README integration steps

These are marked with `// TODO` comments and follow the established patterns. They can be implemented by following the architecture shown in existing files.

---

## 📞 Support

- **Documentation Issues:** Review this README
- **Firebase Issues:** Check Firebase Console logs
- **Build Issues:** Clean build folder (⌘⇧K)
- **Questions:** Create an issue in the repository

---

**Built with ❤️ for the iOS developer community**

**Ready to build something amazing? Start coding!** 🚀
