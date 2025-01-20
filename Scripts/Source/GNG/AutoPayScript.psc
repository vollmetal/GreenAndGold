Scriptname GNG:AutoPayScript extends TerminalMenu

GlobalVariable Property AutoPayActive Auto Const

GlobalVariable Property AutoPayAmount Auto Const

GlobalVariable Property AutoPayInterest Auto Const

int Property AmountModToggleButton Auto Const Mandatory

int Property ActivationToggleButton Auto Const Mandatory

int Property InterestPayToggleButton Auto Const

bool Property ModType = true Auto
{
false - Decrease
true - Increase
}

Int[] Property ModAmount Auto Const Mandatory

Message Property ModIncreaseMessage Auto Const

Message Property ModDecreaseMessage Auto Const

Message Property AutoPayActiveMessage Auto Const

Message Property AutoPayInactiveMessage Auto Const

Message Property CreditSingular Auto Const

Message Property CreditPlural Auto Const

Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    DisplayUpdate(akTerminalRef)
EndEvent

Event OnTerminalMenuItemRun(int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    
    If (akTerminalBase == self && auiMenuItemID == AmountModToggleButton)
        
        If (ModType)
            ModType = false
        Else
            ModType = true
        EndIf
    EndIf

    
    If (InterestPayToggleButton > 0)
        If (akTerminalBase == self && auiMenuItemID == InterestPayToggleButton)
        
            If (AutoPayInterest.GetValue() > 0.0)
                AutoPayInterest.SetValue(0.0)
            Else
                AutoPayInterest.SetValue(1.0)
            EndIf
        EndIf
    EndIf

    If (akTerminalBase == self && auiMenuItemID == ActivationToggleButton)
        
        If (AutoPayActive.GetValue() > 0.0)
            AutoPayActive.SetValue(0.0)
        Else
            AutoPayActive.SetValue(1.0)
        EndIf
    EndIf
    int index = 0
    While (index < ModAmount.length)
        If (akTerminalBase == self && auiMenuItemID - 1 == index)
            
            If (ModType)
                AutoPayAmount.SetValue(AutoPayAmount.GetValue() + ModAmount[index])
            Else
                AutoPayAmount.SetValue(AutoPayAmount.GetValue() - ModAmount[index])
                
                If (AutoPayAmount.GetValue() < 0.0)
                    AutoPayAmount.SetValue(0.0)
                EndIf
            EndIf
            index = ModAmount.length
        EndIf
        index += 1
    EndWhile
    DisplayUpdate(akTerminalRef)
EndEvent

Function DisplayUpdate(ObjectReference akTerminalRef)
    If (AutoPayActive.GetValue() > 0.0)
        akTerminalRef.AddTextReplacementData("AutoPayActive", AutoPayActiveMessage)
    Else
        akTerminalRef.AddTextReplacementData("AutoPayActive", AutoPayInactiveMessage)
    EndIf

    If (ModType)
        akTerminalRef.AddTextReplacementData("Increase", ModIncreaseMessage)
    Else
        akTerminalRef.AddTextReplacementData("Increase", ModDecreaseMessage)
    EndIf

    akTerminalRef.AddTextReplacementValue("AutoPayAmount", AutoPayAmount.GetValue())

    If (AutoPayInterest.GetValue() > 0.0)
        akTerminalRef.AddTextReplacementData("AutoPayInterest", AutoPayActiveMessage)
    Else
        akTerminalRef.AddTextReplacementData("AutoPayInterest", AutoPayInactiveMessage)
    EndIf

    TextPluralityCheck(AutoPayAmount, "AutoPayCreditsTextDisplay", CreditSingular, CreditPlural, akTerminalRef)
EndFunction

Function TextPluralityCheck(GlobalVariable checkedValue, string targetDataValue, Message singular, Message plural, ObjectReference akTerminalRef)
    If (checkedValue.GetValue() != 1.0)
        akTerminalRef.AddTextReplacementData(targetDataValue, plural)
    Else
        akTerminalRef.AddTextReplacementData(targetDataValue, singular)
    EndIf
EndFunction