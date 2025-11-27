# SwiftFirebaseStarter - Quick Start Guide

## ⚡ Get Running in 10 Minutes

### What You Have

✅ **27 Swift files** with complete foundation:
- All models, protocols, and services
- Shared UI components
- Utilities and extensions
- Firebase integration (commented, ready to uncomment)

### What's Missing

⏳ **Feature views and coordination** (marked with TODO):
- App coordination (AppCoordinator, RootView)
- Feature ViewModels and Views
- Unit tests
- Xcode project file

---

## 🚀 Option 1: Quick Test (5 minutes)

**Just want to see the code?**

1. Browse the files in `SwiftFirebaseStarter/`
2. Check out the architecture in `PROJECT_STATUS.md`
3. Read `README.md` for full documentation

**Key files to review:**
- `Core/Models/User.swift` & `Todo.swift` - Data models
- `Core/Services/AuthService.swift` - Firebase Auth (commented)
- `Core/Services/FirestoreService.swift` - Firestore CRUD (commented)
- `SharedUI/` - Ready-to-use components

---

## 🔧 Option 2: Create Working Xcode Project (10 minutes)

### Step 1: Create Xcode Project (2 min)

```bash
# Open Xcode
# File → New → Project → iOS App
# Name: SwiftFirebaseStarter
# Interface: SwiftUI
# Language: Swift
# Minimum: iOS 16.0
```

### Step 2: Copy Files (1 min)

```bash
# Assuming you're in the IOS-boilerplate directory
# Copy all source files to your new Xcode project
cp -r SwiftFirebaseStarter/* /path/to/YourXcodeProject/SwiftFirebaseStarter/

# In Xcode: File → Add Files, select all folders
```

### Step 3: Add Firebase (3 min)

```bash
# In Xcode:
# 1. File → Add Package Dependencies
# 2. URL: https://github.com/firebase/firebase-ios-sdk
# 3. Version: 10.20.0+
# 4. Select: FirebaseAuth, FirebaseFirestore
```

### Step 4: Setup Firebase Console (4 min)

1. Go to https://console.firebase.google.com/
2. Create project: "SwiftFirebaseStarter"
3. Add iOS app with your bundle ID
4. Download `GoogleService-Info.plist`
5. Drag into Xcode project root
6. Enable Email/Password & Anonymous in Authentication
7. Create Firestore database in test mode
8. Apply security rules from README.md

### Step 5: Uncomment Firebase Code

In these files, uncomment the Firebase imports and code:
- `Config/FirebaseManager.swift`
- `Core/Services/AuthService.swift`
- `Core/Services/FirestoreService.swift`

Look for:
```swift
// import FirebaseAuth  ← Remove //
// import FirebaseFirestore  ← Remove //

// Uncomment when Firebase is integrated:
/*
[code here]  ← Remove /* and */
*/
```

### Step 6: Test Build

```bash
# Press ⌘B in Xcode
# Should compile successfully (though app won't do much yet)
```

---

## 🎯 Option 3: Complete the Boilerplate (4-6 hours)

### Phase 4: App Coordination (1 hour)

Create these files following the patterns:

**App/AppCoordinator.swift:**
```swift
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var hasSeenOnboarding: Bool
    @Published var isAuthenticated: Bool
    @Published var currentUser: User?

    private let authService: AuthServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol

    init(
        authService: AuthServiceProtocol = FirebaseAuthService(),
        userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()
    ) {
        self.authService = authService
        self.userDefaultsService = userDefaultsService
        self.hasSeenOnboarding = userDefaultsService.hasSeenOnboarding()

        // Setup auth state listener
        Task {
            for await user in authService.observeAuthState() {
                self.currentUser = user
                self.isAuthenticated = user != nil
            }
        }
    }

    func completeOnboarding() {
        userDefaultsService.setHasSeenOnboarding(true)
        hasSeenOnboarding = true
    }
}
```

**App/RootView.swift:**
```swift
struct RootView: View {
    @StateObject private var coordinator: AppCoordinator

    init(coordinator: AppCoordinator = AppCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        Group {
            if !coordinator.hasSeenOnboarding {
                // OnboardingView(coordinator: coordinator)
                Text("Onboarding (TODO)")
            } else if !coordinator.isAuthenticated {
                // AuthView()
                Text("Auth (TODO)")
            } else {
                // MainView()
                Text("Main App (TODO)")
            }
        }
        .environmentObject(coordinator)
    }
}
```

**App/SwiftFirebaseStarterApp.swift:**
```swift
@main
struct SwiftFirebaseStarterApp: App {
    init() {
        FirebaseManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
```

### Phase 5: Features (2-3 hours)

Implement features in this order:

1. **Onboarding** (30 min)
   - Simple 3-page flow
   - Use `OnboardingPageView` for each page
   - Call `coordinator.completeOnboarding()` when done

2. **Auth** (45 min)
   - `AuthViewModel` with `AuthServiceProtocol`
   - `LoginView` and `SignUpView` forms
   - Use `PrimaryButton` and validation

3. **Home/Todos** (1 hour)
   - `TodoViewModel` with `FirestoreServiceProtocol`
   - `TodoListView` with `TodoRowView`
   - `AddTodoView` sheet
   - Use `EmptyStateView` when no todos

4. **Profile & Settings** (30 min)
   - Simple display views
   - Use `CardView` for sections
   - Stats from Firestore

### Phase 6: Tests (1 hour)

Create mock services and test ViewModels:

```swift
final class MockAuthService: AuthServiceProtocol {
    var currentUser: User?
    var shouldSucceed = true

    func signIn(email: String, password: String) async throws -> User {
        guard shouldSucceed else { throw AppError.authError("Mock error") }
        let user = User(id: "test", email: email)
        currentUser = user
        return user
    }
    // ... implement other methods
}
```

### Phase 7: Polish (30 min)

- Add app icon to Assets.xcassets
- Create Localizable.strings
- Test thoroughly

---

## 📦 What You Get

### Immediate Benefits

- ✅ **Production-ready architecture** - MVVM with protocols
- ✅ **Firebase integration** - Auth + Firestore ready
- ✅ **Reusable components** - Buttons, views, utilities
- ✅ **Error handling** - Centralized and user-friendly
- ✅ **Logging system** - Debug and production ready
- ✅ **Type-safe** - Protocols and modern Swift

### Extensibility

Everything is designed to extend easily:

```swift
// Add new service:
protocol MyNewServiceProtocol {
    func doSomething() async throws
}

final class MyNewService: MyNewServiceProtocol {
    func doSomething() async throws {
        // Implementation
    }
}

// Use in ViewModel:
class MyViewModel: ObservableObject, ViewModelProtocol {
    private let service: MyNewServiceProtocol

    init(service: MyNewServiceProtocol = MyNewService()) {
        self.service = service
    }
}
```

---

## 🤖 Using with Claude Code

This boilerplate is optimized for AI assistants:

```bash
# Example prompts:

"Create the AuthViewModel following the existing ViewModel pattern"

"Implement OnboardingView with 3 pages using the OnboardingPageView pattern"

"Add TodoViewModel that uses FirestoreServiceProtocol for CRUD operations"

"Create unit tests for AuthViewModel using MockAuthService"

"Add a profile photo upload feature"
```

---

## 📋 Checklist

### Minimal Working App

- [ ] Create Xcode project
- [ ] Copy source files
- [ ] Add Firebase SDK via SPM
- [ ] Uncomment Firebase code
- [ ] Create Firebase project
- [ ] Add GoogleService-Info.plist
- [ ] Enable auth methods
- [ ] Create Firestore database
- [ ] Apply security rules
- [ ] Create AppCoordinator
- [ ] Create RootView
- [ ] Create app entry point
- [ ] Build and run

### Complete Boilerplate

- [ ] All of above ✅
- [ ] Implement Onboarding
- [ ] Implement Auth flow
- [ ] Implement Home/Todos
- [ ] Implement Profile
- [ ] Implement Settings
- [ ] Create MainView TabView
- [ ] Write unit tests
- [ ] Add app icon
- [ ] Add localization
- [ ] Test thoroughly

---

## 🆘 Quick Troubleshooting

**Build errors:**
```bash
# Clean build folder
⌘⇧K in Xcode

# Delete DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData
```

**Firebase not working:**
```bash
# Check GoogleService-Info.plist is in project
# Check target membership is selected
# Check Firebase imports are uncommented
# Check FirebaseManager.configure() is called
```

**Can't find modules:**
```bash
# Verify SPM packages resolved
# File → Packages → Reset Package Caches
# File → Packages → Resolve Package Versions
```

---

## 📚 Next Steps

1. **Read** `README.md` for comprehensive guide
2. **Check** `PROJECT_STATUS.md` for what's done/pending
3. **Review** plan document for architecture details
4. **Start coding** using the patterns established

---

## ⚡ TL;DR

**You have:** Complete foundation (models, services, protocols, UI components)

**You need:** Create Xcode project, add Firebase, implement features

**Time:** 10 min to run | 4-6 hours to complete

**Difficulty:** Easy following established patterns

---

*Ready? Let's build something amazing!* 🚀
