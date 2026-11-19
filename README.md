# TrackMyGym 🏋️‍♂️

**TrackMyGym** is an all-in-one gym management mobile application built with **Flutter (Dart)**. It allows gym owners and managers to streamline member enrollments, subscription plans, fee collections, attendance, and support.

---

## 📱 Reverse Engineered Screen Flow

1. **Onboarding Screen (`lib/screens/onboarding_screen.dart`)**
   - Brand banner with custom treadmill athlete silhouette
   - "TrackMyGym" title & "All-in-one gym management."
   - Email entry with direct routing to Sign Up
   - Google Sign-in action
   - Support Center & Dynamic Language Switcher triggers

2. **Support Center (`lib/screens/support_center_screen.dart`)**
   - Direct WhatsApp support launcher
   - Direct Email support launcher
   - Ticket status tracking empty state

3. **Language Settings Modal (`lib/widgets/language_selector_sheet.dart`)**
   - Live search filter for multi-language selection
   - English, Hindi (हिंदी), Hinglish, Marathi (मराठी), Gujarati (ગુજરાતી), Punjabi (ਪੰਜਾਬੀ), Kannada (ಕನ್ನಡ), etc.
   - Interactive selection state

4. **Sign Up Screen (`lib/screens/signup_screen.dart`)**
   - Gym Name, Owner Name, Country Code (+91) & Phone Number
   - Auto-filled Email Address and secure Password field with visibility toggle
   - Collapsible referral code option
   - Moves directly to Plan Creation

5. **Add Plan Screen (`lib/screens/add_plan_screen.dart`) - Step 1**
   - Progress stepper (`1 Add Plan` -> `2 Add Member` -> `3 View Dashboard`)
   - "Fill Test Data" toggle for instant exploration
   - Plan Name, Price, Duration Type (Months vs. Days), and duration selector
   - Clear instructions banner

6. **Add Member Screen (`lib/screens/add_member_screen.dart`) - Step 2**
   - Auto Membership ID generation with green availability indicator
   - Batch / Group class selection
   - Plan picker dynamically linked to created plans
   - Date pickers for Joining Date and Payment Date
   - Dynamic calculation of Due Amount (`Plan Amount - Paid Amount - Discounts`)
   - Payment reminders toggle and payment method options
   - Discount selector (Percent / Amount) and Admission Fees
   - Member Details (Email, DOB, Address, Notes)

7. **Main Dashboard & Multi-Tab Hub (`lib/screens/dashboard_screen.dart`)**
   - **Dashboard (Home)**: High-level metric tiles (Total Members, Active Plans, Revenue, Pending Dues), Quick Action shortcuts, Recent Members overview
   - **Members**: Searchable and filterable members directory with status tags
   - **Plans**: Active membership plans catalog
   - **Payments**: Transaction log and payment status monitoring
   - **Settings**: Gym profile, Language management, Support Center, and Firebase Cloud DB readiness

---

## 🚀 Running via CI/CD Pipeline Agent (GitHub Actions)

Since Flutter SDK is managed in the pipeline to keep local disk usage minimal, the repository includes a ready-to-run GitHub Actions workflow:
- `.github/workflows/flutter.yml`
- Runs `flutter pub get`, `flutter analyze`, and builds the APK on every push to `main`.

---

## ☁️ Future Firebase DB Integration

The data architecture is structured around clean models (`PlanModel`, `MemberModel`, `AppState`). To plug in Firebase:
1. Enable Firebase in Firebase Console (`trackmygym-app`).
2. Add `firebase_core` and `cloud_firestore` to `pubspec.yaml`.
3. Add `google-services.json` to `android/app/`.
