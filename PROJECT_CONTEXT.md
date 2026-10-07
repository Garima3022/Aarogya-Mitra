# PROJECT_CONTEXT.md: SEHAT VISION (सेहत विज़न / सेहत विशन्)

## 1. Product Vision & Overview
**SEHAT VISION** ("AI-Assisted Early Screening for Everyone") is a modern, neo-brutalist rural healthcare early-screening assistant built with Flutter. It supports ASHA workers, ANMs, community health staff, and primary care nurses in low-resource settings to conduct rapid early screenings for:
1. **Diabetic Retinopathy (DR)** — Fundus/retinal image screening (`best_model.pth` target)
2. **Oral Lesions / Oral Cancer** — Intraoral image screening (`UmlomoV1.pth` target)

> **CRITICAL MEDICAL UX NOTICE:**
> SEHAT VISION is an **AI-Assisted Early Screening Support Tool**, NOT a definitive medical diagnostic tool. All UI labels, reports, and voice announcements strictly use non-diagnostic language: *"Screening Result"*, *"Potential Finding"*, *"Needs Clinical Review"*, and *"Discuss with a qualified healthcare professional"*.

---

## 2. Target Users & Operating Environment
- **Users**: ASHA workers, ANM midwives, rural health volunteers, nurses with varying levels of digital literacy.
- **Environment**: Low-cost Android smartphones, small display resolutions, portrait orientation, outdoor/indoor variable lighting, zero or intermittent cellular data.
- **Core Principle**: *"Guide the user instead of expecting the user to know what to do."*

---

## 3. Architecture & Tech Stack
- **Framework**: Flutter (Dart, Null Safety)
- **Design Paradigm**: Medical Neo-Brutalism (Bold geometry, thick 2-4px black borders, tactile cards, high contrast `#F7F5EF` background, `#0B1F3A` primary, semantic status colors).
- **State Management**: Flutter `Provider` / `ChangeNotifier` state containers (`LanguageProvider`, `VoiceGuidanceProvider`, `ScreeningProvider`, `SmartCaptureProvider`, `PatientProvider`).
- **Localization**: Architectural Arb-backed L10n architecture (`AppLocalizations`) supporting English (`en`), Hindi (`hi`), and Bengali (`bn`) with zero hardcoded strings.
- **Voice Infrastructure**:
  - `VoiceGuidanceService`: Text-to-Speech playback, speech rate/volume control, repeat instruction, intelligent debouncing.
  - `SpeechRecognitionService`: Abstracted STT interface with mock/native fallback for voice patient data entry.
- **Smart Capture Engine**:
  - `ImageQualityService`: Modular computer vision quality analyzer exposing metrics for Brightness, Sharpness/Blur, Distance, Centering/Position, Glare, and Motion Stability.
  - `SmartCaptureStateMachine`: Authoritative state machine tracking initialization, quality flags (`TOO_FAR`, `TOO_CLOSE`, `LOW_LIGHT`, `TOO_BRIGHT`, `BLUR_DETECTED`, `TARGET_NOT_CENTERED`, `HOLD_STEADY`, `READY`), auto-capture countdown, and capture dispatch.

---

## 4. Key Features & Navigation Structure

```
+-----------------------------------------------------------------------------------+
|                                 ONBOARDING FLOW                                   |
|   [Welcome / Pitch] --> [Camera Coach Info] --> [Offline Capability] --> [Lang]   |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                                   MAIN SHELL                                      |
|  Bottom Navigation: [Home] | [Screening] | [History] | [Settings & Privacy]   |
+-----------------------------------------------------------------------------------+
                                          |
                        +-----------------+-----------------+
                        |                                   |
                        v                                   v
             [Diabetic Retinopathy]                   [Oral Lesion]
                        |                                   |
                        +-----------------+-----------------+
                                          |
                                          v
                              [Patient Voice/Text Form]
                                          |
                                          v
                             [Visual & Voice Tutorial]
                                          |
                                          v
                             [SMART CAPTURE / CAMERA]
                     - Live Quality Indicators (Lighting, Distance, Blur...)
                     - Auto-Capture Ready Gate + Manual Fallback
                     - Voice Guidance & Neo-Brutalist Banners
                                          |
                                          v
                            [Image Preview & QC Audit]
                                          |
                                          v
                             [AI Processing Animation]
                                          |
                                          v
                             [Screening Result Screen]
                     - Status Badge ("Needs Clinical Review")
                     - AI Heatmap / Grad-CAM Visual Overlay
                     - Patient Explanations & Next Steps
                                          |
                                          v
                            [Export PDF / Save Report]
```

---

## 5. Design System Specifications (Medical Neo-Brutalism)
- **Background Color**: `#F7F5EF` (Soft off-white / parchment)
- **Primary Color**: `#0B1F3A` (Deep Medical Navy)
- **Borders**: Black `#111111`, 2px to 4px width, zero blur, sharp 8px corners.
- **Card Styling**: White background, 3px solid black border, 4px/4px offset shadow (`BoxShadow(color: Colors.black, offset: Offset(4, 4))`).
- **Semantic Colors**:
  - Green (`#16A34A`): Ready / Good Quality / Negative Screening
  - Yellow (`#F59E0B`): Warning / Adjust Camera / Minor Finding
  - Red (`#EF4444`): Problem / Bad Quality / Needs Clinical Review
  - Blue (`#2563EB`): Guidance / Active Voice / Info

---

## 6. Model Integration Strategy & API Layer
- **Backend Model Files**:
  - `best_model.pth` -> Retinal Fundus Diabetic Retinopathy Classifier
  - `UmlomoV1.pth` -> Intraoral Lesion / Cancer Risk Classifier
- **Service Layer**:
  - `ApiClient`: Configurable REST/HTTP client reading `API_BASE_URL` from environment/app config.
  - `ScreeningRepository`: Abstract contract implemented by `MockScreeningRepository` (for offline/demo mode) and `RemoteScreeningRepository` (for PyTorch/FastAPI backend).
  - **Demo Mode**: Explicitly highlighted with a top badge (`DEMO MODE - MOCK AI BACKEND`) to prevent false medical assumptions during prototype evaluation.

---

## 7. Localization Strategy
- Supported languages:
  - English (`en`)
  - Hindi (`hi` - हिन्दी)
  - Bengali (`bn` - বাংলা)
- Managed via `AppLocalizations` with key-value dictionaries. Easily extensible by adding `app_<lang_code>.arb` files.

---

## 8. Offline & Privacy Framework
- Status Indicator: `🟢 OFFLINE READY` persistently displayed on dashboard.
- Privacy: Zero automatic cloud telemetry; local storage; clear simple privacy disclaimers (no misleading "HIPAA" claims).
