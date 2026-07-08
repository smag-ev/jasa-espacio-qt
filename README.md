# JASA Espacio

JASAEspacio is a desktop software application designed to combine live space telemetry tracking with interactive 3D visualizations. Built for amateur astronomers and space enthusiasts, the application serves as a central hub for monitoring orbital assets and assessing local outdoor observation conditions.

## 🌟 Features

- **Login/Signup:** Registration and authentication system to secure user access and profiles.
- **Feedback:** Built-in interface for users to submit system reviews and bug reports.
- **Models:** Interactive, rotatable 3D visualizations of Earth, the Moon, and the JWST.
- **Stargazing Places:** A curated directory highlighting optimal global locations for night-sky viewing.
- **Top Space Wonders:** An educational catalog showcasing remarkable deep-space anomalies.
- **Stargaze Condition Calculator:** An automation engine providing baseline visibility scores based on the Bortle scale.
- **Location's Stargaze Situation:** A live screen displaying real-time weather and cloud coverage for the user's exact coordinates.
- **ISS Tracker:** An active mapping module tracking the real-time position and trajectory of the International Space Station.

## 🛠️ Tech Stack

- **Backend:** C++ 
- **Frontend:** Qt6 / QML

## 📋 Requirements

Before launching the app, ensure your system has the following:
- **Operating System:** Windows 10/11
- **System Font:** The `Century Gothic` font family must be installed locally on your operating system for the UI text elements to render correctly.
- **Network Access:** An active internet connection is required to fetch real-time API telemetry data feeds.

## 🚀 How to Run

The application is pre-compiled and ready to execute immediately without any installation setup:

1. **Download and extract** the application folder.
2. Locate the main executable file inside the root directory.
3. **Double-click `JASAEspacio.exe`** to launch the app.

## ⚠️ Performance Note

The application currently experiences a performance issue, a small lag while navigating through sections for the first time. This lag occurs because the system processes highly complex, multi-part 3D models while simultaneously managing live data feeds in the background. Rather than stripping down asset detail for an easy fix, these bottlenecks were kept as a practical study in graphics optimization, requiring deep-dives into asynchronous asset loading and memory management to balance interface fidelity with execution efficiency.