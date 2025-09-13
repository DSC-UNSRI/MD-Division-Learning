# 📱 Final Project Plans Review – Mobile Development Division

## 📝 Final Project Plan

### 1. Project Title
**LinguaPanel** - Comic Translation Mobile Application

---

### 2. Chosen Final Project Deliverable
- [x] **Mobile App on GitHub Repository (without publishing)**  

**Explanation:** I chose GitHub repository option because this is a complete mobile application with complex features that just too much work for pubkishing. The app includes authentication, image processing, API integration, and local storage management - making it suitable for showcasing technical capabilities without the complexity of app stores publishing.

---

### 3. Problem Statement & SDG Alignment
- **Problem Statement:** Language barriers prevent comic readers from enjoying content in foreign languages, particularly Japanese, Chinese, & Korean comics. Manual translation is time-consuming and requires language expertise.  
- **Chosen SDG:** **SDG 4: Quality Education**  
- **Justification:** LinguaPanel supports cross-language literacy access, helping comic readers from different countries understand content without language barriers. This aligns with SDG 4's goal to improve global access to education and literacy, making educational and entertainment content more accessible across cultures.  

---

### 4. Target Users & Use Cases
- **Primary Users:** comic enthusiasts, language learners, and readers who want to access comic content
- **Use Cases:**
  - Upload comic images for automatic text detection and translation
  - View translation history and manage personal translation library (local)
  - Access translated comic content on mobile devices
  - Learn languages through visual context and translated text

---

### 5. Features List
- **Authentication System:**
  - Email/password registration and login
  - Google Sign-In integration
  - Forgot password functionality
  - User profile management
- **Image Processing:**
  - Upload comic images from gallery or camera
  - Automatic text bubble detection using AI
  - OCR (Optical Character Recognition) for Japanese text
  - Translation from Japanese to English
  - Processed image display with translated text
- **Data Management:**
  - Translation history storage and retrieval
  - Local image storage with automatic cleanup
  - User profile with customizable username and avatar
- **User Interface:**
  - Modern Material Design 3 interface
  - Responsive navigation between screens
  - Progress indicators for processing
  - Error handling with user-friendly messages
- **API Integration:**
  - FastAPI backend integration for image processing
  - Configurable API endpoints
  - Connection testing and health monitoring

---

### 6. Technical Details
- **Architecture Pattern:** **MVVM (Model-View-ViewModel)** with Provider state management
- **Key Packages/Dependencies:**
  - `firebase_core`, `firebase_auth`, `cloud_firestore` - Authentication and database
  - `google_sign_in` - Google authentication
  - `provider` - State management
  - `image_picker` - Image selection from gallery/camera
  - `path_provider`, `crypto` - Local file management
  - `http`, `shared_preferences` - API communication and settings
- **Database/Storage:** 
  - **Cloud Firestore** for user data and translation history
  - **Local file storage** for images using device storage
- **Other Integrations:**
  - **FastAPI Backend** for AI-powered comic translation
  - **Roboflow API** for text bubble detection
  - **DeepSeek API** for Japanese-to-English translation
  - **EasyOCR** for text recognition

---

### 7. Deliverable-Specific Requirements

#### GitHub Repo (App without publishing):
- [x] **APK builds** for x86_64, arm64, arm32/armeabi-v7a (available in releases)
- [x] **9 pages** with multiple widgets each (Splash, Login, Register, Forgot Password, Home, Upload, History, Profile, Settings)
- [x] **Production quality** with error handling, loading states, and user feedback

---

### 8. Complexity Plan
**Technical Ambition Factors:**
- **AI Integration:** Advanced image processing with text bubble detection and OCR
- **Multi-API Integration:** Firebase, FastAPI backend, Roboflow, and DeepSeek APIs
- **Complex State Management:** MVVM architecture with multiple ViewModels
- **File Management:** Local storage with automatic cleanup and image optimization
- **Real-time Processing:** Long-running image processing with progress tracking

---

### 9. Testing Strategy
- **Integration Tests:**
  - Authentication flow (login, register, Google Sign-In)
  - Image upload and processing workflow
  - Data persistence and retrieval

---

### 10. Timeline & Milestones
- **Week 1:** Backend API integration, image processing workflow
- **Week 2:** Translation features, history management, profile system
- **Week 3:** Error handling, testing, optimization, and APK builds, Final testing, documentation

---
