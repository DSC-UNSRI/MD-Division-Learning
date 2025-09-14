# 📱 Final Project Plans Review – Mobile Development Division

## 📝 Final Project Plan

### 1. Project Title

**Espress Yo Self** - A Modern Coffee Shop Loyalty & Sustainability App

---

### 2. Chosen Final Project Deliverable

(Choose **one** from the options)

- [x] Mobile App on GitHub Repository (without publishing)
- [ ] Flutter/Dart Package published on pub.dev
- [ ] Mobile App published on Google Play Store

**Explanation:** I chose GitHub Repository option because the project is already well-structured with comprehensive documentation, includes APK builds for multiple architectures (x86_64, arm64, arm32/armeabi-v7a), has 10+ screens with 5+ widgets each, and meets production quality standards with proper Clean Architecture implementation.

---

### 3. Problem Statement & SDG Alignment

- **Problem Statement:** Traditional coffee shop loyalty programs lack environmental consciousness and fail to incentivize sustainable consumer behavior, while customers struggle to track their impact on sustainability efforts.
- **Chosen SDG:** SDG 12 - Responsible Consumption and Production
- **Justification:** The app promotes sustainable coffee consumption by offering bonus rewards (50% extra points) for eco-friendly coffee purchases, encouraging customers to make environmentally conscious choices while tracking their sustainability impact through a digital reward system.

---

### 4. Target Users & Use Cases

- **Intended Users:** Coffee enthusiasts aged 18-45, environmentally conscious consumers, regular coffee shop customers, and tech-savvy individuals who prefer digital loyalty programs.
- **Use Cases:**
  - Scan QR codes after coffee purchases to earn points and stamps
  - Track sustainability impact through eco-friendly purchase rewards
  - Collect digital stamps to earn free coffee (10 stamps = 1 free coffee)
  - Manage user profiles with photo uploads
  - View detailed transaction history and rewards earned
  - Redeem rewards and track redemption history

---

### 5. Features List

- QR Code scanning for transaction tracking
- Digital stamp collection system (10 stamps = free coffee)
- Points-based loyalty program with sustainability bonuses (50% extra for eco-friendly purchases)
- User authentication (Email/Password + Google Sign-In)
- Profile management with photo upload via Supabase Storage
- Real-time transaction history tracking
- Rewards catalog and redemption system
- Firebase real-time point calculations
- Push notifications support
- Dark/Light theme toggle
- Sustainability impact tracking and environmental awareness features

---

### 6. Technical Details

- **Architecture Pattern:** Clean Architecture with MVVM pattern using Riverpod for state management
- **Key Packages/Dependencies:** Flutter Riverpod 2.6.1 (State Management), Firebase Suite (Auth, Firestore, Analytics, Crashlytics, Performance), Supabase 2.0.0 (Storage), Go Router 15.1.1 (Navigation), Mobile Scanner 5.0.1 (QR Code), Google Sign In 6.3.0, Freezed 3.0.6 (Code Generation), JSON Serializable
- **Database/Storage:** Firebase Firestore (NoSQL database), Supabase Storage (File storage), Shared Preferences (Local storage)
- **Other Integrations:** Firebase Analytics & Crashlytics, Camera & Gallery access, Permission handling, Image caching and processing, Real-time data synchronization

---

### 7. Deliverable-Specific Requirements

#### If GitHub Repo (App without publishing):

- ✅ Will include APK builds for x86_64, arm64, arm32/armeabi-v7a
- ✅ 10+ pages with 5+ widgets each (Home, Rewards, History, Profile, QR Scanner, Auth, User Form, Edit Profile, Reward Detail screens)
- ✅ Meets first-stage production quality with comprehensive documentation and clean architecture

---

### 8. Complexity Plan

The project demonstrates technical ambition through:

- **Complete Firebase Integration:** Authentication, Firestore, Analytics, Crashlytics, Performance monitoring
- **Supabase Integration:** Additional backend services for enhanced storage capabilities
- **Clean Architecture Implementation:** Proper separation with Domain, Data, and Presentation layers
- **Advanced State Management:** Riverpod with complex reactive data flows and providers
- **Real-time Features:** Live transaction updates, real-time reward status, instant point calculations
- **Device Integration:** Camera access, QR scanning, permission handling, image processing
- **Code Generation:** Freezed for data classes, JSON serialization for API handling
- **Multi-platform Support:** Android, iOS, Web, Windows, macOS, Linux compatibility
- **Security Implementation:** Secure authentication, encrypted storage, proper Firestore security rules

---

### 9. Testing Strategy (Optional)

Based on the existing test structure:

- **Unit tests:** Domain layer entities and use cases, repository implementations, view model logic, authentication flows
- **Integration tests:** QR scanning functionality, database operations, rewards redemption process, real-time data synchronization

---

### 10. Timeline & Milestones

- **Week 1:** Architecture setup, Firebase/Supabase configuration, authentication implementation
- **Week 2:** Core features - QR scanning, points system, stamp collection
- **Week 3:** User interface development, rewards system, transaction history
- **Week 4:** Profile management, sustainability features, real-time updates
- **Week 5:** Testing, optimization, documentation, APK builds for multiple architectures
- **Week 6:** Final polishing, performance monitoring, deployment preparation