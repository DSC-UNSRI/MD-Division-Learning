# 📱 Final Project Plans Review – Mobile Development Division

## 📝 Final Project Plan

### 1. Project Title

**Askademia** – Forum Interaktif Mahasiswa untuk Pendidikan & Karir

---

### 2. Chosen Final Project Deliverable

* [x] Mobile App on GitHub Repository (without publishing)
* [ ] Flutter/Dart Package published on pub.dev
* [ ] Mobile App published on Google Play Store

**Alasan:** Tahap awal fokus ke repository GitHub untuk menampilkan arsitektur, kode, dan fitur inti dengan kualitas production-ready. Bisa jadi stepping stone ke Play Store di fase berikutnya.

---

### 3. Problem Statement & SDG Alignment

* **Problem Statement:** Banyak mahasiswa kesulitan mencari informasi terpercaya mengenai akademik, beasiswa, magang, dan karir. Forum diskusi terpusat khusus mahasiswa masih jarang, padahal bisa jadi solusi untuk saling berbagi pengalaman.
* **Chosen SDG:**

  * **SDG 4: Quality Education**
  * (Opsional tambahan: **SDG 8: Decent Work and Economic Growth**)
* **Justification:** Aplikasi ini mendukung akses informasi pendidikan yang inklusif dan membantu mahasiswa mempersiapkan karir dan pembelajaran dengan berbagi pengetahuan, pengalaman, dan peluang.

---

### 4. Target Users & Use Cases

* **Target Users:** Mahasiswa (S1, D3, Pascasarjana) fresh graduates.
* **Use Cases:**

  * Mahasiswa bertanya soal beasiswa, magang, atau tips kuliah.
  * Senior/alumni atau semua yang punya pengalaman terkait menjawab berdasarkan pengalaman pribadi.
  * Diskusi kelompok berdasarkan topik tertentu (misalnya: “Tips Skripsi”, “Karir IT”, “Pertukaran Mahasiswa”).

---

### 5. Features List

* **Auth & Profile:** Sign up/login, buat profil mahasiswa (jurusan, kampus, minat).
* **Forum Diskusi:** Post pertanyaan, balas thread, beri upvote/like.
* **Search:** Cari topik atau pertanyaan dengan cepat.
* **Notifikasi:** Update ketika ada jawaban baru atau mention.
* **Bookmark:** Simpan thread yang relevan.
* **Moderasi:** Report spam atau konten tidak pantas.

---

### 6. Technical Details

* **Architecture Pattern:** MVC.
* **Key Packages/Dependencies:**

  * Firebase Auth (login)
  * Firebase Firestore (database forum & user)
  * Flutter Notifications (push notif)

---

### 7. Deliverable-Specific Requirements

**GitHub Repo (App without publishing):**

* Akan include APK builds (x86\_64, arm64, armeabi-v7a).
* ≥10 halaman dengan ≥5 widget custom per halaman.
* Kualitas mendekati production-ready (authentication, state management, UI konsisten).

---

### 8. Complexity Plan

* Real-time forum diskusi dengan Firebase Firestore.
* Implementasi notifikasi push berbasis topic subscription.
* Sistem searching.

---

### 9. Testing Strategy (Optional)
-

---

### 10. Timeline & Milestones

* **Week 1:** Setup project, struktur folder, auth page.
* **Week 2:** Implementasi forum (CRUD post & reply).
* **Week 3:** Fitur tambahan (search & bookmark).
* **Week 4:** Integrasi notifikasi, moderasi.
* **Week 5:** Testing, dokumentasi, finalisasi repo.
