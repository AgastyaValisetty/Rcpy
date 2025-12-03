# Smart Robocopy Hotkey

A lightweight AutoHotkey v2 tool that lets you quickly copy **selected files or folders** using global hotkeys. It shows a clean popup with **real progress**, MB/GB copied, and lets you cancel instantly.

Because Windows Explorer sometimes copies slower than a sloth doing yoga.

---

## 🚀 Features

* Copy **selected file or folder** (Ctrl + Alt + C)
* Paste into **current folder** (Ctrl + Alt + V)
* Clean, minimal **progress popup** with real byte‑based progress
* Shows **MB/GB copied** in real time
* Silent notifications (no Windows sounds)
* Cancel instantly (Ctrl + Alt + Esc)
* Portable — can be compiled to EXE

---

## ⚡ Speed Comparison

Robocopy is significantly faster and more efficient than Windows' built‑in File Explorer copy.

**Typical performance differences:**

| Method                                  | Speed (Large files) | Speed (Many small files) | Reliability |
| --------------------------------------- | ------------------- | ------------------------ | ----------- |
| Windows File Explorer                   | 80–120 MB/s         | Slow due to overhead     | Medium      |
| This tool (robocopy)                    | 150–400 MB/s        | Much faster              | High        |

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

## 📁 How It Works

* Detects the exact file or folder you selected
* Calculates total size for accurate progress
* Tracks destination folder growth to compute real percentage
* Uses `robocopy /E` behind the scenes (safe, no deletions)

The progress bar isn't a Windows "lie bar" — it's actually telling the truth.

---

## 🔧 Installation

**Option A — Run as script**

1. Install AutoHotkey v2
2. Run `rcpy.ahk`

**Option B — Compile to EXE**
Download `RCPY.exe` and run it.

---

## ⚠️ Disclaimer (Important!)

This software is provided **“as is”**, without warranty of any kind.

While this tool:

* never deletes files,
* uses safe robocopy parameters, and
* avoids dangerous flags like `/MIR`,
  it is still **file‑copying software**, and using it implies you understand the risks.

The author is **not responsible** for:

* data loss,
* partial files due to user‑initiated cancellation,
* incorrect usage,
* folder selection errors,
* or unexpected system behavior.

> **By using this tool, you agree that you do so at your own risk.**

For legal safety, this project is licensed under the **MIT License**, which includes strong no‑liability protections.

---

## 📄 License

This project is released under the **MIT License**.
You are free to use, modify, distribute, and include it in commercial or non‑commercial projects, provided you include the license.

---

## 💬 Final Note

If you find this helpful, consider giving the repo a ⭐ on GitHub.
It keeps the electrons motivated to travel faster during file transfers. 😌
