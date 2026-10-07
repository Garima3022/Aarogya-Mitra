# SEHAT VISION - AI-Assisted Early Screening Assistant

**SEHAT VISION** ("AI-Assisted Early Screening for Everyone") is a modern, neo-brutalist Flutter frontend prototype designed specifically for rural and low-resource healthcare environments. It serves as an early screening support tool for:

1. **Diabetic Retinopathy (DR)** — Fundus/retinal image screening (`best_model.pth`)
2. **Oral Lesion / Oral Cancer** — Intraoral image screening (`UmlomoV1.pth`)

---

## 1. Project Structure

```
c:\Users\GARIMA\OneDrive\AarogyaMitra\
├── PROJECT_CONTEXT.md                # Architecture, design system & model plan
├── pubspec.yaml                      # Flutter dependencies and asset configuration
├── best_model.pth                    # Pre-trained Diabetic Retinopathy PyTorch model
├── UmlomoV1.pth                      # Pre-trained Oral Lesion PyTorch model
└── lib/
    ├── main.dart                     # App entry point & navigation shell
    ├── core/
    │   ├── constants/
    │   │   └── app_constants.dart    # Medical disclaimers, defaults, storage keys
    │   ├── theme/
    │   │   └── app_theme.dart        # Medical Neo-Brutalist design palette & borders
    │   ├── localization/
    │   │   └── app_translations.dart # English, Hindi, Bengali translation dictionaries
    │   ├── providers/
    │   │   ├── language_provider.dart
    │   │   ├── settings_provider.dart
    │   │   └── patient_provider.dart
    │   └── services/
    │       ├── voice_guidance_service.dart      # Text-to-Speech service
    │       ├── speech_recognition_service.dart  # Speech-to-Text service interface
    │       ├── image_quality_service.dart       # Live CV quality coach engine
    │       └── connectivity_service.dart        # Offline indicator service
    ├── features/
    │   ├── onboarding/
    │   │   └── presentation/onboarding_screen.dart  # Onboarding walkthrough
    │   ├── home/
    │   │   └── presentation/home_screen.dart        # Main dashboard
    │   ├── patient/
    │   │   └── presentation/patient_form_screen.dart# Voice-enabled patient form
    │   ├── smart_capture/
    │   │   └── presentation/
    │   │       ├── smart_capture_screen.dart        # Live Smart Camera Coach
    │   │       └── tutorial_modal.dart              # Step-by-step visual tutorial
    │   ├── screening/
    │   │   ├── domain/screening_repository.dart     # API / Mock repository contract
    │   │   └── presentation/screening_result_screen.dart # AI Heatmap & result report
    │   ├── history/
    │   │   └── presentation/history_screen.dart     # Recent screening records
    │   └── settings/
    │       └── presentation/settings_screen.dart    # Easy mode, guided mode, privacy
    └── shared/
        ├── models/screening_result_model.dart
        └── widgets/
            ├── neo_button.dart
            ├── neo_card.dart
            ├── status_badge.dart
            ├── voice_button.dart
            ├── guidance_banner.dart
            ├── quality_indicator_row.dart
            └── language_selector_widget.dart
```

---

## 2. How to Run the Project

Once Flutter SDK is registered in your PATH environment:

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run in Chrome / Web preview
flutter run -d chrome

# 3. Run on connected Android device / emulator
flutter run -d android
```

---

## 3. Key Dependencies
- `flutter_localizations` & `intl`: Multilingual architecture
- `provider`: Clean state management
- `camera`: Camera hardware preview stream
- `flutter_tts`: Voice guidance Text-to-Speech playback
- `speech_to_text`: Patient voice data entry
- `vibration`: Haptic feedback for quality state gates
- `http`: REST backend communication with PyTorch server

---

## 4. Demo Mode Instructions
By default, **SEHAT VISION** operates in **DEMO MODE**. 
- A persistent `DEMO MODE - MOCK AI BACKEND` banner is displayed to ensure users never confuse prototype evaluations with real medical diagnoses.
- In Smart Capture mode, press the **"Simulate Quality Issue"** pill on top right to test the live state machine transitions:
  - `LOW_LIGHT` ➔ Warning banner + Voice instruction *"Lighting is too low"*
  - `TOO_FAR` ➔ Warning banner + Voice instruction *"Move closer"*
  - `BLUR_DETECTED` ➔ Red banner + Voice instruction *"Hold phone steady"*
  - `TARGET_NOT_CENTERED` ➔ Blue banner + Voice instruction *"Center the target"*
  - `READY` ➔ Green banner + Auto-capture 3s countdown trigger

---

## 5. Backend Integration Points & Model Connections

### Model File Placement
- `best_model.pth` (114 MB, Diabetic Retinopathy)
- `UmlomoV1.pth` (9.15 MB, Oral Lesion)

### Server Deployment (FastAPI / PyTorch)
Create a Python FastAPI backend service (`server.py`) serving both PyTorch models:

```python
# server.py example
from fastapi import FastAPI, File, UploadFile
import torch

app = FastAPI()

# Load models
dr_model = torch.load("best_model.pth", map_location="cpu")
oral_model = torch.load("UmlomoV1.pth", map_location="cpu")

@app.post("/api/v1/screen/retina")
async def screen_retina(file: UploadFile = File(...)):
    # Run PyTorch inference on fundus image
    # Return classification label & Grad-CAM heatmap bytes
    return {"status": "Needs Clinical Review", "risk": "Potential DR Finding"}

@app.post("/api/v1/screen/oral")
async def screen_oral(file: UploadFile = File(...)):
    # Run PyTorch inference on intraoral image
    return {"status": "Screening Negative", "risk": "Low Risk"}
```

### Flutter API Configuration
In `lib/core/constants/app_constants.dart`, update `defaultApiBaseUrl`:
```dart
static const String defaultApiBaseUrl = 'http://<YOUR_SERVER_IP>:8000/api/v1';
```

---

## 6. How to Add New Languages
To add a new language (e.g., Tamil `ta` or Marathi `mr`):
1. Open `lib/core/localization/app_translations.dart`.
2. Add a new key entry in `_localizedValues`:
```dart
'ta': {
  'app_title': 'சேஹத் விஷன்',
  'offline_ready': 'ஆஃப்லைன் தயார்',
  // ... add corresponding translations
}
```
3. Add option to `LanguageSelectorWidget` in `lib/shared/widgets/language_selector_widget.dart`.

---

## 7. Replacing Mock Quality Analysis with Real OpenCV / CV Logic
To replace `analyzeFrameMock()` in `lib/core/services/image_quality_service.dart` with live image stream processing:
1. Pass `CameraImage` frames from `camera` package's `startImageStream()`.
2. Calculate brightness using Y-channel mean intensity: `brightness = mean(Y_plane) / 255.0`.
3. Compute sharpness/blur variance using Laplacian edge detection filter on grayscale buffer: `variance(Laplacian(gray))`.
4. Update `ImageQualityResult` properties with computed scores. The UI components (`GuidanceBanner`, `QualityIndicatorRow`, `VoiceGuidanceService`) will automatically react without requiring any code changes.
