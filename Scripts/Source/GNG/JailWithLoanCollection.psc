Scriptname GNG:JailWithLoanCollection extends Quest

GlobalVariable Property LoanCollectionsAmount Auto Const

Faction Property CollectionsFaction Auto Const Mandatory

MiscObject Property Credit Auto Const Mandatory

Event OnInit ()
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerJail")
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerPayFine")
    StartTimerGameTime(12.0)
EndEvent

Event OnTimerGameTime(int aiTimerID)
    
    If (CollectionsFaction.GetCrimeGold() > 0)
        
    Else
        If (LoanCollectionsAmount.GetValue() > 0.0)
            LoanCollectionsAmount.SetValue(0.0)
        EndIf
    EndIf
    StartTimerGameTime(12.0)
EndEvent

Event Actor.OnPlayerJail(Actor akSender, ObjectReference akGuard, Form akFaction, Location akLocation, int aeCrimeGold)

    If (LoanCollectionsAmount.GetValue() > 0.0)
        Game.GetPlayer().RemoveItem(Credit, LoanCollectionsAmount.GetValue() as int)
        LoanCollectionsAmount.SetValue(0.0)
    EndIf
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerJail")
EndEvent

Event Actor.OnPlayerPayFine(Actor akSender, ObjectReference akGuard, Form akFaction, int aeCrimeGold)
    
    If (LoanCollectionsAmount.GetValue() > 0.0)
        LoanCollectionsAmount.SetValue(0.0)
    EndIf
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerPayFine")
EndEvent