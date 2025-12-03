# Smart Robocopy Hotkey

A lightweight productivity tool written in **AutoHotkey v2** that lets you instantly copy **selected files or folders** using global hotkeys — with a clean, modern popup UI that shows real progress, live MB/GB copied, and a smooth cancel option.

Because sometimes Windows Explorer copies slower than a sloth doing yoga.

---

## 🚀 Features

### ✅ Copy selected file or folder

* **Ctrl + Alt + C** chooses the source

  * If a file is selected → that file is used
  * If a folder is selected → that folder is used
  * If nothing is selected → nothing happens (safe)

### ✅ Paste into the current folder

* **Ctrl + Alt + V** copies the saved source into the folder currently open in Explorer
* Uses **robocopy /E** for reliable, fast transfers
* Never deletes anything (no `/MIR`, `/PURGE`, etc.)

### ✅ Modern progress popup (bottom-right)

* Light, clean UI
* Rounded corners
* Shows **real progress** based on actual bytes copied
* Shows **current MB/GB copied / total**
* Stays visible until the operation finishes or is cancelled

### ❌ Silent toasts (no Windows sounds)

* "Source set"
* "Copy complete"
* "Copy aborted"

### 🛑 Cancel any time

* **Ctrl + Alt + Esc** instantly aborts the copy
* The robocopy process is force-stopped
* Shows “Copy aborted ✖”

### 🪄 Portable & standalone

* You can compile this into an EXE and run it on any Windows PC — **no AutoHotkey required**.

---

## ⚡ Speed Comparison

Robocopy is significantly faster and more efficient than Windows' built-in File Explorer copy.

**Typical performance differences:**

| Method                                  | Speed (Large files) | Speed (Many small files) | Reliability |
| --------------------------------------- | ------------------- | ------------------------ | ----------- |
| Windows File Explorer                   | 80–120 MB/s         | Slow due to overhead     | Medium      |
| This tool (robocopy)                    | 150–400 MB/s        | Much faster              | High        |
| Explorer (when it “calculates forever”) | 🐌                  | 💤                       | 😭          |

Robocopy is optimized for bulk copying. Explorer is optimized for showing you a spinning blue circle.

---

## 🎹 Hotkeys

| Hotkey               | Action                            |
| -------------------- | --------------------------------- |
| **Ctrl + Alt + C**   | Set source (selected file/folder) |
| **Ctrl + Alt + V**   | Copy source into the open folder  |
| **Ctrl + Alt + Esc** | Abort the copy immediately        |
| **Ctrl + Alt + Q**   | Quit the script                   |

---

## 📁 How It Works Internally

* When copying begins, the script scans the source to calculate the **total size**.
* It also scans the destination folder to record a **baseline size**.
* During copying, every 150 ms, it measures how much the destination folder grew.
* This gives a **true, accurate progress percentage**, without parsing robocopy output.

This means your progress bar is not a "Windows-style lie bar" — it's the real thing.

---

## 🔧 Installation & Usage

### **Option A — Run the script (.ahk)**

1. Install AutoHotkey v2
2. Download `GameCopyHotkey.ahk`
3. Double-click to run

### **Option B — Compile to EXE (recommended)**

1. Right-click the `.ahk` file
2. Choose **Compile Script**
3. Use the generated `.exe` on any Windows PC — no dependencies

---

## ⚠️ Disclaimer (Important!)

This software is provided **“as is”**, without warranty of any kind.

While this tool:

* never deletes files,
* uses safe robocopy parameters, and
* avoids dangerous flags like `/MIR`,
  it is still **file-copying software**, and using it implies you understand the risks.

The author is **not responsible** for:

* data loss,
* partial files due to user-initiated cancellation,
* incorrect usage,
* folder selection errors,
* or unexpected system behavior.

> **By using this tool, you agree that you do so at your own risk.**

For legal safety, this project is licensed under the **MIT License**, which includes strong no-liability protections.

---

## 📄 License

This project is released under the **MIT License**.
You are free to use, modify, distribute, and include it in commercial or non-commercial projects, provided you include the license.

---

## 💬 Final Note

If you find this helpful, consider giving the repo a ⭐ on GitHub.
It keeps the electrons motivated to travel faster during file transfers. 😉
