# 🏠 DTT Real Estate Assessment

This repository contains the implementation of the **DTT Real Estate App**, developed as part of the internship assessment for **DTT**.  
The application simulates a real estate browsing experience, where users can view available houses, explore details, and manage favorites — all with smooth animations and offline handling.

---

## 🚀 Features
- **Overview Screen** – Displays all houses fetched from the API with key details (price, city, bedrooms, etc.).
- **Detail Screen** – Shows detailed property info and location view.
- **Search Functionality** – Filter homes by city or postal code.
- **Wishlist Feature** – Add or remove favorite houses for quick access.
- **Offline Handling** – Detects network status and shows a “No Internet” state when offline.
- **Animations** – Smooth screen transitions and subtle motion effects for enhanced UX.
- **Info Screen** – Displays app and developer information.

---

## 🛠️ Tech Stack
- **Framework**: Flutter (3.35.7 • channel stable)
- **Language**: Dart (3.9.2)
- **API**: REST API → `https://intern.d-tt.nl/api/house`
- **Libraries Used**:
  - `connectivity_plus` – for network monitoring
  - `geolocator` – for user location and distance calculation
  - `http` – for API communication

---

## ⚙️ Setup Instructions
1. Clone the repository  
   ```bash
   git clone https://github.com/rmonisha1123/DTT_Real_Estate_Assessment.git
