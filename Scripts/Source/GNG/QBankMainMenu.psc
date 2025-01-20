Scriptname GNG:QBankMainMenu extends TerminalMenu

ActorValue Property PlayerAccountAmount Auto Const

GlobalVariable Property UnityJumpInterestRate Auto Const

Message Property InterestPaymentMessage Auto Const

Message Property CreditSingular Auto Const

Message Property CreditPlural Auto Const

Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    DisplayUpdate(akTerminalRef)
EndEvent

Function DisplayUpdate(ObjectReference akTerminalRef)
    akTerminalRef.AddTextReplacementValue("QBCredits", Game.GetPlayer().GetValue(PlayerAccountAmount))

    akTerminalRef.AddTextReplacementValue("QBInterest", UnityJumpInterestRate.GetValue())

    TextPluralityCheck(PlayerAccountAmount, "CreditDisplay", CreditSingular, CreditPlural, akTerminalRef)
EndFunction

Function TextPluralityCheck(ActorValue checkedValue, string targetDataValue, Message singular, Message plural, ObjectReference akTerminalRef)
    If (Game.GetPlayer().GetValue(checkedValue) != 1.0)
        akTerminalRef.AddTextReplacementData(targetDataValue, plural)
    Else
        akTerminalRef.AddTextReplacementData(targetDataValue, singular)
    EndIf
EndFunction