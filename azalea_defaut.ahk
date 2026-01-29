#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook
SendMode "Event"

; =================== TUNING ===================
MinR := 150
MaxGB := 150
RedGap := 35

PollMs := 25
ClickDelayMs := 15
FightMs := 10000          ; spam click duration after red (ms)

NoRedResetMs := 80000     ; failsafe reset if no red seen (ms)

PostFightWaitMs := 250
ZeroTapDelay := 150
AfterZeroPairMs := 450
RecastClicks := 2
RecastClickGapMs := 90
AfterCastMs := 200
; ==============================================

; =================== STATE ====================
running := false
inFight := false
inReset := false

lastRedTick := 0
startTick := 0

fishCaught := 0
failsafeResets := 0
; ==============================================

; =================== GUI ======================
gMain := Gui()

; --- AZALEA ROSE THEME ---
gMain.BackColor := "C94A6A"                 ; azalea / rose pink
gMain.SetFont("s10 cFFFFFF", "Segoe UI")    ; white text

gMain.Opt("+AlwaysOnTop +ToolWindow")
gMain.Title := "Auto Fisher — Default"

; Header style
gMain.SetFont("s11 bold cFFD6E0", "Segoe UI")
gMain.AddText("w260", "Status (Default):")

; Normal text style
gMain.SetFont("s10 cFFFFFF", "Segoe UI")
txtStatus := gMain.AddText("w260", "STOPPED")

gMain.SetFont("s11 bold cFFD6E0", "Segoe UI")
gMain.AddText("w260 y+10", "Fish caught (loops):")
gMain.SetFont("s10 cFFFFFF", "Segoe UI")
txtFish := gMain.AddText("w260", "0")

gMain.SetFont("s11 bold cFFD6E0", "Segoe UI")
gMain.AddText("w260 y+10", "Failsafe resets:")
gMain.SetFont("s10 cFFFFFF", "Segoe UI")
txtResets := gMain.AddText("w260", "0")

gMain.SetFont("s11 bold cFFD6E0", "Segoe UI")
gMain.AddText("w260 y+10", "Elapsed time:")
gMain.SetFont("s10 cFFFFFF", "Segoe UI")
txtElapsed := gMain.AddText("w260", "00:00:00")

gMain.SetFont("s9 cFFFFFF", "Segoe UI")
gMain.AddText("w260 y+10", "Hotkeys: P Start | O Stop | M Exit | F9 Debug")

; Buttons
gMain.SetFont("s9 bold c5A1F2E", "Segoe UI")
btnStart := gMain.AddButton("w80 y+12", "Start")
btnStop  := gMain.AddButton("x+10 w80", "Stop")
btnExit  := gMain.AddButton("x+10 w80", "Exit")

btnStart.OnEvent("Click", (*) => StartBot())
btnStop.OnEvent("Click", (*) => StopBot())
btnExit.OnEvent("Click", (*) => ExitApp())

; Footer / Credit
gMain.SetFont("s8 italic cFFD6E0", "Segoe UI")
gMain.AddText("w260 center y+14", "Property of Azalea Guild · Made by Daniel")

gMain.OnEvent("Close", (*) => ExitApp())
gMain.Show("x20 y20")

SetTimer(UpdateGUI, 250)
; ==============================================

; =================== HOTKEYS ==================
p::StartBot()
o::StopBot()
m::ExitApp()

F9:: {
    global txtStatus, running
    MouseGetPos(&x, &y)
    col := PixelGetColor(x, y, "RGB")
    r := (col >> 16) & 0xFF
    g := (col >> 8) & 0xFF
    b := col & 0xFF
    txtStatus.Text := "DEBUG XY " x "," y " RGB " r "," g "," b
    SetTimer(() => txtStatus.Text := (running ? "RUNNING" : "STOPPED"), -1200)
}
; ==============================================

SetTimer(MainLoop, PollMs)

; =================== FUNCTIONS =================

StartBot() {
    global running, lastRedTick, startTick, fishCaught, failsafeResets, txtStatus
    running := true
    startTick := A_TickCount
    lastRedTick := A_TickCount
    fishCaught := 0
    failsafeResets := 0
    txtStatus.Text := "RUNNING"
}

StopBot() {
    global running, inFight, inReset, txtStatus
    running := false
    inFight := false
    inReset := false
    txtStatus.Text := "STOPPED"
}

UpdateGUI() {
    global running, startTick, fishCaught, failsafeResets
    global txtFish, txtResets, txtElapsed

    txtFish.Text := fishCaught
    txtResets.Text := failsafeResets

    if !running || startTick = 0 {
        txtElapsed.Text := "00:00:00"
        return
    }

    ms := A_TickCount - startTick
    sec := Floor(ms / 1000)
    hh := Floor(sec / 3600)
    mm := Floor(Mod(sec, 3600) / 60)
    ss := Mod(sec, 60)

    txtElapsed.Text := Format("{:02}:{:02}:{:02}", hh, mm, ss)
}

IsRedAt(x, y) {
    global MinR, MaxGB, RedGap
    col := PixelGetColor(x, y, "RGB")
    r := (col >> 16) & 0xFF
    g := (col >> 8) & 0xFF
    b := col & 0xFF
    return (r >= MinR)
        && (g <= MaxGB)
        && (b <= MaxGB)
        && ((r - g) >= RedGap)
        && ((r - b) >= RedGap)
}

TapZero() {
    Send("{0 down}")
    Sleep(20)
    Send("{0 up}")
}

ResetRodAndRecast() {
    global running
    global PostFightWaitMs, ZeroTapDelay, AfterZeroPairMs
    global RecastClicks, RecastClickGapMs, AfterCastMs

    if !running
        return

    Sleep(PostFightWaitMs)

    TapZero()
    Sleep(ZeroTapDelay)
    TapZero()

    Sleep(AfterZeroPairMs)

    Loop RecastClicks {
        Click("Left")
        Sleep(RecastClickGapMs)
    }

    Sleep(AfterCastMs)
}

MainLoop() {
    global running, inFight, inReset, lastRedTick
    global ClickDelayMs, FightMs, NoRedResetMs
    global fishCaught, failsafeResets, txtStatus

    if !running || inFight || inReset
        return

    MouseGetPos(&x, &y)
    redNow := IsRedAt(x, y)

    if redNow {
        lastRedTick := A_TickCount
        inFight := true
        txtStatus.Text := "FIGHTING"

        start := A_TickCount
        while running && (A_TickCount - start < FightMs) {
            Click("Left")
            Sleep(ClickDelayMs)
        }

        if running {
            ResetRodAndRecast()
            fishCaught += 1
            lastRedTick := A_TickCount
            txtStatus.Text := "RUNNING"
        }

        inFight := false
        return
    }

    if (A_TickCount - lastRedTick >= NoRedResetMs) {
        inReset := true
        txtStatus.Text := "FAILSAFE RESET"
        failsafeResets += 1

        ResetRodAndRecast()

        if running {
            lastRedTick := A_TickCount
            txtStatus.Text := "RUNNING"
        }

        inReset := false
    }
}
