#Requires AutoHotkey v2.0
#SingleInstance Force

; Shows the Sofle layout (overlay.png) while F13 is held.
; On the keyboard F13 sits on J of the adjust layer (hold Lower + Raise, then hold J).
; After a keymap change: update layout.html, then run render.ps1 to refresh overlay.png.

A_IconTip := "Sofle-Übersicht: Adjust + J halten"

overlay := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x08000000")  ; click-through, never takes focus
overlay.BackColor := "1b1f26"
overlay.MarginX := 0
overlay.MarginY := 0

; Fit into 90 % of the primary screen, keeping the aspect ratio
pic := overlay.Add("Picture", "w" Round(A_ScreenWidth * 0.9) " h-1", A_ScriptDir "\overlay.png")
pic.GetPos(, , &w, &h)
if (h > A_ScreenHeight * 0.9) {
    pic.Move(, , Round(w * A_ScreenHeight * 0.9 / h), Round(A_ScreenHeight * 0.9))
}

visible := false

; * = also with modifiers held; no ~ so F13 never reaches other programs
*F13:: {
    global visible
    if visible  ; ignore key repeat while held
        return
    visible := true
    overlay.Show("NoActivate AutoSize xCenter yCenter")
    WinSetTransparent(240, overlay)
}

*F13 up:: {
    global visible
    visible := false
    overlay.Hide()
}
