Scriptname GNG:RegisterAccount extends TerminalMenu

Int Property AcceptMenuItem Auto Const

GlobalVariable Property AccountTracker Auto Const

Quest Property SavingsInterestQuest Auto Const
{Quest managing the interest accumulation of savings.}


Event OnTerminalMenuItemRun(int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    
    If (auiMenuItemID == AcceptMenuItem)
        AccountTracker.SetValue(1.0)
        SavingsInterestQuest.Start()
    EndIf
EndEvent