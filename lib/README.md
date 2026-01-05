# 🛣️ RoadSense - Smart Road Obstacle Detection

> Transforming smartphones into road safety sensors using AI and crowdsourcing

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Problem Statement

Roads worldwide suffer from poor maintenance. Authorities react to complaints rather than proactively addressing hazards. Potholes and unmarked speed breakers cause:
- 🚗 Vehicle damage
- 🤕 Accidents and injuries  
- 💰 Economic losses

## 💡 Solution

RoadSense converts every smartphone into a road quality sensor:
1. **Detect** obstacles using accelerometer/gyroscope
2. **Classify** them as potholes or speed breakers
3. **Map** locations in real-time
4. **Alert** authorities for preventive maintenance

## 🏗️ Architecture
```
Flutter App → Sensor Simulation → ML Classification → Firebase → Google Maps
```

## ✨ Features

- ✅ Real-time obstacle detection
- ✅ Automatic GPS tagging
- ✅ AI-powered classification (pothole vs speed breaker)
- ✅ Interactive map with all detected obstacles
- ✅ Live statistics dashboard
- ✅ Crowdsourced data collection

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Frontend | Flutter |
| Backend | Firebase (Firestore) |
| ML | Rule-based classifier (TensorFlow Lite ready) |
| Maps | Google Maps API |
| Sensors | Accelerometer simulation |

## 🚀 Getting Started

### Prerequisites
```bash
flutter --version  # 3.0+
firebase --version # CLI installed
```

### Installation

1. **Clone repository**
```bash
git clone https://github.com/yourusername/roadsense.git
cd roadsense
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
```bash
firebase init
# Select Firestore
# Use default settings
```

4. **Add Google Maps API Key**
- Get key from [Google Cloud Console](https://console.cloud.google.com)
- Add to `android/app/src/main/AndroidManifest.xml`
- Add to `ios/Runner/AppDelegate.swift`

5. **Run app**
```bash
flutter run
```

## 📱 Screenshots

| Home | Detection | Map |
|------|-----------|-----|
| ![Home](screenshots/home.png) | ![Detection](screenshots/detection.png) | ![Map](screenshots/map.png) |

## 🎬 Demo Video

[Watch 3-minute demo](https://youtu.be/your-demo-link)

## 🧪 Testing Approach

Since this is a prototype:
- Sensor data is **simulated** with realistic jolts
- GPS coordinates use **mock Chennai locations**
- ML model uses **threshold-based rules** (TensorFlow integration ready)

## 🗺️ Roadmap

- [ ] Real
