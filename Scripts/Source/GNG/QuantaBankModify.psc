Scriptname GNG:QuantaBankModify extends TerminalMenu

ActorValue Property PlayerAccountAmount Auto Const

GlobalVariable Property UnityJumpInterestRate Auto Const

Message Property CreditSingular Auto Const

Message Property CreditPlural Auto Const

MiscObject Property Credit Auto Const

Int Property ModType Auto Const
{0 = deposit
1 = withdraw}

Int[] Property modAmount Auto Const

Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    DisplayUpdate(akTerminalRef)
EndEvent

Event OnTerminalMenuItemRun(int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    
    If (akTerminalBase == self)
       ObjectReference player = Game.Getplayer()

        int index = 0
        While (index < modAmount.length)
            
            If (auiMenuItemID - 1 == index)
                If (ModType == 1)
                    player.ModValue(PlayerAccountAmount, -(modAmount[index] as float))
                    player.AddItem(Credit, ModAmount[index])
                Else
                    player.ModValue(PlayerAccountAmount, modAmount[index] as float)
                    player.RemoveItem(Credit, ModAmount[index])
                EndIf
            EndIf
            index += 1
        EndWhile
        DisplayUpdate(akTerminalRef)
    EndIf
EndEvent

Function DisplayUpdate(ObjectReference akTerminalRef)
    akTerminalRef.AddTextReplacementValue("CreditAmount", Game.GetPlayer().GetValue(PlayerAccountAmount))

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