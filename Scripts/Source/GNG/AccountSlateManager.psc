Scriptname GNG:AccountSlateManager extends ActiveMagicEffect

ObjectReference Property TargetTerminal Auto Const Mandatory
Potion Property AccountSlate Auto Const Mandatory

Event OnInit()
    Utility.Wait(1.0)
    TargetTerminal.Activate(Game.GetPlayer())
    Game.GetPlayer().AddItem(AccountSlate)
EndEvent