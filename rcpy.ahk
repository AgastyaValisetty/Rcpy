#Requires AutoHotkey v2.0
#SingleInstance Force

global gSourcePath := ""
global gSourceIsFile := false
global gDestDir := ""
global gTotalBytes := 0
global gDestBaseBytes := 0
global gCopyPID := 0
global gIsCopying := false
global gProgGui
global gSizeLabel

; ---------- Silent toast ----------
ShowToast(msg, durationMs := 1500) {
    toast := Gui("+AlwaysOnTop -Caption +ToolWindow")
    toast.BackColor := "FFFFFF"
    toast.SetFont("s9", "Segoe UI")
    toast.MarginX := 10
    toast.MarginY := 6
    toast.Add("Text", "cBlack", msg)

    w := 220, h := 40
    x := A_ScreenWidth - w - 20
    y := A_ScreenHeight - h - 90
    toast.Show(Format("w{1} h{2} x{3} y{4}", w, h, x, y))

    try {
        region := DllCall("CreateRoundRectRgn"
            , "int",0,"int",0,"int",w,"int",h,"int",10,"int",10,"ptr")
        DllCall("SetWindowRgn", "ptr", toast.Hwnd, "ptr", region, "int", true)
    }

    SetTimer(() => toast.Destroy(), -durationMs)
}

; ---------- Get selected path in Explorer (file or folder) ----------
GetSelectedExplorerPath() {
    shell := ComObject("Shell.Application")
    for window in shell.Windows {
        if window.hwnd = WinActive("A") {
            sel := window.Document.SelectedItems
            if (sel.Count > 0)
                return sel.Item(0).Path   ; first selected item
            return ""
        }
    }
    return ""
}

; ---------- Get open Explorer folder (destination) ----------
GetOpenExplorerPath() {
    for window in ComObject("Shell.Application").Windows {
        if window.hwnd = WinActive("A") {
            try return window.Document.Folder.Self.Path
        }
    }
    return ""
}

; ---------- Get size of file OR folder ----------
GetPathSize(path) {
    attr := FileExist(path)
    if (!attr)
        return 0

    ; Directory
    if InStr(attr, "D") {
        total := 0
        loop files path "\*", "FR" {
            total += A_LoopFileSize
        }
        return total
    }

    ; File
    return FileGetSize(path, "B")
}

; ---------- Format bytes into MB/GB ----------
FormatBytes(bytes) {
    gb := bytes / (1024*1024*1024)
    if (gb >= 1)
        return Format("{:.2f} GB", gb)
    mb := bytes / (1024*1024)
    return Format("{:.1f} MB", mb)
}

; ---------- Ctrl+Alt+C → set SOURCE (must be selected) ----------
^!c::{
    global gSourcePath, gSourceIsFile

    sel := GetSelectedExplorerPath()
    if (sel = "") {
        ShowToast("No file/folder selected")
        return
    }

    attr := FileExist(sel)
    if (!attr) {
        ShowToast("Selection not found")
        return
    }

    gSourcePath := sel
    if InStr(attr, "D") {
        gSourceIsFile := false
        ShowToast("Source folder set ✔")
    } else {
        gSourceIsFile := true
        ShowToast("Source file set ✔")
    }
}

; ---------- Ctrl+Alt+V → start copy ----------
^!v::{
    global gSourcePath, gSourceIsFile, gDestDir, gTotalBytes, gDestBaseBytes
    global gProgGui, gIsCopying, gCopyPID, gSizeLabel

    if (gSourcePath = "") {
        ShowToast("Set a source first (Ctrl+Alt+C)")
        return
    }

    dest := GetOpenExplorerPath()
    if (dest = "") {
        ShowToast("Open destination folder in Explorer")
        return
    }
    gDestDir := dest

    if (gIsCopying) {
        ShowToast("Copy already in progress")
        return
    }

    ; Total size of what we're copying (file or folder)
    gTotalBytes := GetPathSize(gSourcePath)
    if (gTotalBytes <= 0) {
        ShowToast("Source is empty or size = 0")
        return
    }

    ; Baseline destination size (so we track only new bytes)
    gDestBaseBytes := GetPathSize(gDestDir)

    gIsCopying := true

    ; ---------- Progress Popup ----------
    gProgGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    gProgGui.BackColor := "FFFFFF"
    gProgGui.SetFont("s10", "Segoe UI")
    gProgGui.MarginX := 12
    gProgGui.MarginY := 8

    gProgGui.Add("Text", "cBlack", "Copying...")
    gSizeLabel := gProgGui.Add("Text", "cBlack", "0 MB / " . FormatBytes(gTotalBytes))
    gProgGui.Add("Progress", "vCopyBar w200 h12 cBlue BackgroundGray", 0)

    w := 230, h := 85
    x := A_ScreenWidth - w - 20
    y := A_ScreenHeight - h - 50
    gProgGui.Show(Format("w{} h{} x{} y{}", w, h, x, y))

    try {
        region := DllCall("CreateRoundRectRgn"
            , "int",0,"int",0,"int",w,"int",h,"int",14,"int",14,"ptr")
        DllCall("SetWindowRgn","ptr",gProgGui.Hwnd,"ptr",region,"int",true)
    }

    ; ---------- Build robocopy command ----------
    if (gSourceIsFile) {
        ; For a single file:
        SplitPath gSourcePath, &name, &dir
        cmd := Format('robocopy "{1}" "{2}" "{3}"', dir, gDestDir, name)
    } else {
        ; For a folder:
        cmd := Format('robocopy "{1}" "{2}" /E', gSourcePath, gDestDir)
    }

    gCopyPID := Run(cmd, , "Hide")

    SetTimer(UpdateProgress, 200)
}

; ---------- Update Progress ----------
UpdateProgress() {
    global gCopyPID, gProgGui, gTotalBytes, gDestDir, gDestBaseBytes
    global gIsCopying, gSourcePath, gSizeLabel

    if (!gIsCopying)
        return

    ; robocopy finished?
    if (!ProcessExist(gCopyPID)) {
        gIsCopying := false
        try gProgGui.Destroy()
        ShowToast("Copy complete ✔", 1800)
        SetTimer(UpdateProgress, 0)
        return
    }

    destTotal := GetPathSize(gDestDir)
    copiedBytes := destTotal - gDestBaseBytes
    if (copiedBytes < 0)
        copiedBytes := 0

    percent := (gTotalBytes > 0) ? Floor((copiedBytes / gTotalBytes) * 100) : 0
    if (percent > 100)
        percent := 100

    ; update bar + text
    try {
        gProgGui["CopyBar"].Value := percent
        gSizeLabel.Text := FormatBytes(copiedBytes) " / " FormatBytes(gTotalBytes)
    }
}

; ---------- Ctrl+Alt+Esc → cancel ----------
^!Esc::{
    global gCopyPID, gIsCopying, gProgGui

    if (!gIsCopying) {
        ShowToast("No copy running")
        return
    }

    try ProcessClose gCopyPID
    gIsCopying := false
    gCopyPID := 0

    try gProgGui.Destroy()
    ShowToast("Copy aborted ✖", 1800)
}

; ---------- Ctrl+Alt+Q → quit ----------
^!q::ExitApp
