# 📱 Final Project Plans Review – Mobile Development Division

## 📝 Final Project Plan

### 1. Project Title
**greentask: Gamified Climate Action**

---

### 2. Chosen Final Project Deliverable
- [X] Mobile App on GitHub Repository (without publishing)

**Justification:**
Saya memilih opsi ini karena dengan memilih ini diharapkan bisa mengalokasikan effort agar pengembangan aplikasi dan fitur-fiturnya
---

### 3. Problem Statement & SDG Alignment
- **Problem Statement:** Banyak individu, terutama generasi muda, merasa bahwa isu perubahan iklim terlalu besar dan kontribusi personal mereka tidak berarti. Hal ini menyebabkan kurangnya motivasi untuk mengadopsi gaya hidup yang peduli lingkungan. Aksi ramah lingkungan sering dianggap sebagai hal yang membosankan sehingga tidak menarik
- **Chosen SDG:** **SDG 13: Climate Action**
- **Justification:** Greentask direncanakan untuk mengatasi masalah ini dengan mengubah aksi iklim menjadi sebuah "Task" atau misi yang bisa menarik berbagai kalangan untuk terus melakukan aksi ramah lingkungan. Dengan menggunakan sistem gamifikasi seperti poin,title dan streak, Greentask berperan untuk memberikan feedback dan juga rasa pencapaian untuk User agar memotivasi mereka untuk terus membangun kebiasaan yang ramah lingkungan.

---

### 4. Target Users & Use Cases
- **Target Users:**
  - Segala aspek individu yang tertarik pada isu lingkungan dan juga yang mau untuk membangun kebiasaan ramah lingkungan.
  - Komunitas atau organisasi lingkungan yang mencari platform untuk mengoordinasikan aksi kecil.
- **Use Cases:**
  - **Onboarding:** User baru mendaftar atau login ke aplikasi.
  - **Daily Streak:** User membuka aplikasi dan menjalankan misi setiap hari untuk mempertahankan streak mereka.
  - **Daily Mission:** User menjalankan misi untuk menambah XP,level dan streak mereka yang akan di-refresh setiap harinya
  - **Social Competition:** User memeriksa Papan Peringkat untuk melihat posisi mereka dengan user lain.
  - **Achievement Unlocked:** User menerima notifikasi saat mereka berhasil mendapatkan lencana baru.

---

### 5. Features List
- **User Authentication:** Registrasi dan Login (Email/Password & Google Sign-In).
- **Gamified Task System:** Daftar misi harian/mingguan yang diperbarui dari Firebase.
- **XP & Leveling System:** User mendapatkan XP untuk setiap misi dan bisa naik level.
- **Achievement & Badge System:** Lencana yang bisa dikoleksi untuk pencapaian tertentu (misal: menyelesaikan 10 misi hemat air).
- **Real-time Leaderboard:** Papan peringkat User berdasarkan total XP.
- **Daily Streak System:** User mempertahankan streak mereka dengan membuka dan menjalankan misi setiap hari
- **Push Notifications:** Pengingat untuk misi harian baru menggunakan Firebase Cloud Messaging (FCM).

---

### 6. Technical Details
- **Architecture Pattern:** **MVVM (Model-View-ViewModel)**, untuk memisahkan logika dari UI dan memastikan kode yang bersih dan terukur.
- **Database/Storage:** **Cloud Firestore** digunakan sebagai database NoSQL real-time untuk semua data aplikasi (profil User, misi, lencana, dll).
- **Other Integrations:** **Firebase** sebagai Backend-as-a-Service (BaaS) secara keseluruhan.

---

### 7. Deliverable-Specific Requirements

#### For GitHub Repo (App without publishing):
- **[X] Will include APK builds for x86_64, arm64, arm32/armeabi-v7aReleases
- **[X] 10+ pages with 5+ widgets each
- **[X] Meets first-stage production quality

---

### 8. Complexity Plan

---

### 9. Testing Strategy (Optional)


---

### 10. Timeline & Milestones
---
