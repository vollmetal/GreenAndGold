Scriptname GNG:QuantaBankInterest extends Quest

ActorValue Property QuantaBankAccount Auto Const

ActorValue Property PlayerUnityUses Auto Const

GlobalVariable Property QuantaBankAccountInterest Auto Const

Message Property InterestMessage Auto Const

Event OnInit()
    ObjectReference player = Game.GetPlayer()
    If (player.GetValue(PlayerUnityUses) > 0.0)
        StartTimer(5.0)
    EndIf
EndEvent

Event OnTimer(int aiTimerID)
    ObjectReference player = Game.GetPlayer()
    If (player.GetValue(QuantaBankAccount) > 0.0)
        float interest = (player.GetValue(QuantaBankAccount) * (QuantaBankAccountInterest.GetValue() * 0.01))
        player.ModValue(QuantaBankAccount, interest)
        InterestMessage.Show(interest)
    EndIf
EndEvent