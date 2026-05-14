# 📱 Mobile-Based Real-Time Floor Plan Detection and 3D Visualization

## 📌 Overview
This project presents a real-time floor plan detection and pseudo-3D visualization system developed using MATLAB, Computer Vision, and Image Processing techniques.  

The system captures live video from a mobile camera using DroidCam and processes architectural floor plans to detect walls, edges, and structural layouts. It also supports AprilTag-based Augmented Reality (AR) visualization.

---

# 🚀 Features

✅ Real-time mobile camera integration  
✅ Grayscale image conversion  
✅ Edge detection using Canny operator  
✅ Hough Transform wall detection  
✅ Pseudo-3D wall visualization  
✅ Live floor plan analysis  
✅ AprilTag-based AR visualization  
✅ Menu-driven interactive interface  

---

# 🛠️ Technologies Used

- MATLAB
- Computer Vision Toolbox
- Image Processing Toolbox
- DroidCam
- Augmented Reality (AR)
- Hough Transform
- Canny Edge Detection
- AprilTag Detection

---

# 📂 Project Structure

```text
AR-FloorPlan-Detection/
│
├── main.m
├── mobile_AR_menu_live.m
├── calibrated_AR.m
├── cameraParams.mat
├── calibrationSession.mat
│
├── data/
│   └── floor_plan.jpg
│
├── results/
│   ├── grayscale.png
│   ├── edges.png
│   ├── walls.png
│   └── ar_view.png
│
└── README.md
```

---

# ⚙️ Installation

## 1️⃣ Install MATLAB Toolboxes

Required:
- Computer Vision Toolbox
- Image Processing Toolbox

---

## 2️⃣ Install DroidCam

Download:
https://www.dev47apps.com/

Connect mobile camera using:
- USB
or
- WiFi

---

# ▶️ How to Run

## Run Main Project

```matlab
main
```

## Run Mobile AR Menu

```matlab
mobile_AR_menu_live
```

---

# 📷 Functional Modules

## 🔹 Original Camera View
Displays real-time mobile camera feed.

## 🔹 Grayscale Conversion
Converts RGB image into grayscale for easier processing.

## 🔹 Edge Detection
Detects floor boundaries using Canny edge detection.

## 🔹 Wall Detection
Uses Hough Transform to detect straight wall structures.

## 🔹 Static 3D Visualization
Generates pseudo-3D wall projections.

## 🔹 AprilTag AR
Detects AprilTag markers and overlays 3D AR structures.

---

# 📊 Results

The system successfully:
- Detects floor plan structures
- Identifies wall boundaries
- Generates live pseudo-3D visualization
- Performs real-time camera processing
- Supports mobile-based AR interaction

---

# ⚠️ Limitations

- Sensitive to lighting conditions
- Complex floor plans reduce accuracy
- Camera tilt affects detection
- Background noise may generate false edges

---

# 🔮 Future Improvements

- Full 3D room generation
- AI-based room segmentation
- Furniture placement system
- Unity/Android integration
- SLAM-based AR tracking

---

# 👨‍💻 Author

**Saurav Kumar**

---

# 📜 License

This project is developed for academic and educational purposes.
