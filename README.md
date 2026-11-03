# NotchFocus 🎯

> A minimal, distraction-free macOS menu bar (BUILT FOR MY OWN PRODUCTIVITY WHILE DOING A WORK. HOPE YOU LIKE IT!)
---

## 📖 Overview

**NotchFocus** transforms the unused area around your MacBook display notch into a high-utility productivity hub. Sitting at the top-center of your screen, NotchFocus stays pinned above your open windows across all macOS spaces and full-screen apps without cluttering your Dock.

With a single glance or click, you can track your focus sessions, manage short/long breaks, and jot down quick notes without ever switching contexts.

---

## ✨ Features

- **🖤 Sleek Notch Integration**: Borderless floating panel (`NSPanel`) pinned at the top-center of your primary display. Custom bottom-curved geometry seamlessly hugs the physical MacBook notch.
- **⏱️ Smart Pomodoro Timer**:
  - Classic **25 min Focus** / **5 min Short Break** intervals.
  - Automatic **15 min Long Break** every 4 completed sessions.
  - Play, pause, skip, and reset controls with completed session counters.
  - Native system audio alert (`NSSound.beep()`) on phase completion.
- **📝 Instant Sticky Notes**:
  - Dedicated **Notes** button right beside the timer in the top bar.
  - Directly opens a dropdown card tray to create, edit, and delete notes.
  - Color-coded pastel cards for visual organization.
  - Auto-saved locally in JSON format at `~/Library/Application Support/NotchFocus/notes.json`.
- **🎛️ Menu Bar Companion**:
  - Discrete `timer` status bar icon in your macOS menu bar.
  - Quick actions to toggle notes, show/hide the notch overlay, or quit the application.
  - Runs as an accessory app (`.accessory` activation policy) — zero Dock clutter.
- **🔒 Private & Lightweight**:
  - **No external dependencies** (pure Swift, SwiftUI, and AppKit).
  - **No screen recording or accessibility capture permissions required** — 100% safe to use alongside DRM-protected streaming, online exams, and video courses.
  - Zero analytics, telemetry, or network activity.

---

## 🚀 Getting Started

### Prerequisites

- **macOS 13.0 (Ventura)** or later.
- Apple Silicon (M1/M2/M3/M4) or Intel Mac.
- **Xcode Command Line Tools** (installed via `xcode-select --install`).

### Installation & Running

1. **Clone the repository**:
   ```bash
   git clone https://github.com/<your-username>/NotchFocus.git
   cd NotchFocus
   ```

2. **Run immediately using Swift Package Manager**:
   ```bash
   swift run
   ```

3. *(Optional)* **Build an optimized release binary**:
   ```bash
   swift build -c release
   ```
   The compiled executable will be located in `.build/release/NotchFocus`. You can move this binary to your `/Applications` or `~/bin` folder.

---

## ⌨️ Controls & Shortcuts

| Action | Location / Trigger |
| :--- | :--- |
| **Play / Pause Timer** | Click the Play/Pause icon in the top notch bar |
| **Toggle Sticky Notes** | Click **Notes** beside the timer, or press `Cmd+N` in the menu bar menu |
| **Show / Hide Overlay** | Click the Menu Bar icon → **Show / Hide Notch** (`Cmd+H`) |
| **Add New Note** | Click the `+` button in the expanded notes view |
| **Delete Note** | Click the `✕` on any note card |
| **Quit App** | Menu Bar icon → **Quit** (`Cmd+Q`) |

---

## 📁 Project Structure

```
NotchFocus/
├── Package.swift           // Swift Package Manager configuration (macOS 13+)
├── README.md               // Project documentation & setup instructions
└── Sources/
    └── NotchFocus/
        ├── main.swift         // App lifecycle, NSApplication delegate & menu bar item
        ├── NotchWindow.swift  // Borderless NSPanel anchored to the screen notch
        ├── PomodoroView.swift // Timer logic, phase management & SwiftUI timer controls
        ├── NotesView.swift    // Sticky notes cards UI & local JSON persistence
        └── ContentView.swift  // Unified notch layout combining timer & notes
```

---

## 🛠️ Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI + AppKit (`NSPanel`, `NSHostingView`, `NSStatusBar`)
- **Build System**: Swift Package Manager (no `.xcodeproj` required)
- **Dependencies**: None (Apple Native SDKs only)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
