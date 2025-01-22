Scriptname GNG:ModifyAccount extends TerminalMenu

Int Property AccountType Auto Const
{0 = savings
1 = loan}

Int Property ModType Auto Const
{0 = deposit
1 = withdraw}

Int[] Property ModAmount Auto Const Mandatory

GlobalVariable Property PlayerAccountBalance Auto Const

GlobalVariable Property PlayerLoanBalance Auto Const

GlobalVariable Property PlayerAccountInterest Auto Const

GlobalVariable Property PlayerLoanInterest Auto Const

GlobalVariable Property PlayerLoanOpened Auto Const Mandatory

GlobalVariable Property LoanInterestPeriod Auto Const Mandatory

GlobalVariable Property SavingsInterestPeriod Auto Const Mandatory

GlobalVariable Property LoanPaymentDue Auto Const

Message Property CreditSingular Auto Const

Message Property CreditPlural Auto Const

MiscObject Property Credit Auto Const Mandatory

Quest Property SavingsInterestQuest Auto Const
{Quest managing the interest accumulation of savings.}

Quest Property LoanInterestQuest Auto Const
{Quest managing the interest accumulation of loans.}

Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    DisplayUpdate(akTerminalRef)
EndEvent

Event OnTerminalMenuItemRun(int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    
    int index = 0
    While (index < ModAmount.length)
        If (akTerminalBase == self && auiMenuItemID - 1 == index)
            If (AccountType == 0)
                If (ModType == 0)
                    ObjectReference player = Game.Getplayer()
                    
                    PlayerAccountBalance.SetValue(PlayerAccountBalance.GetValue() + (ModAmount[index] as float))
                    player.RemoveItem(Credit, ModAmount[index])
                Else
                    ObjectReference player = Game.Getplayer()
                    
                    PlayerAccountBalance.SetValue(PlayerAccountBalance.GetValue() - (ModAmount[index] as float))
                    player.AddItem(Credit, ModAmount[index])
                EndIf
            Else
                If (ModType == 0)
                    ObjectReference player = Game.Getplayer()
                    
                    PlayerLoanBalance.SetValue(PlayerLoanBalance.GetValue() - (ModAmount[index] as float))
                    player.RemoveItem(Credit, ModAmount[index])
                    LoanPaymentDue.SetValue(LoanPaymentDue.GetValue() - (ModAmount[index] as float))
                    
                    If (LoanPaymentDue.GetValue() < 0.0)
                        LoanPaymentDue.SetValue(0.0)
                    EndIf
                Else
                    ObjectReference player = Game.Getplayer()
                    
                    PlayerLoanBalance.SetValue(PlayerLoanBalance.GetValue() + (ModAmount[index] as float))
                    If (PlayerLoanOpened.GetValue() > 0.0)
                        
                    Else
                        LoanInterestQuest.Start()
                        PlayerLoanOpened.SetValue(1.0)
                    EndIf
                    player.AddItem(Credit, ModAmount[index])
                EndIf
                
                If (PlayerLoanBalance.GetValue() < 1.0)
                    LoanInterestQuest.Stop()
                    PlayerLoanOpened.SetValue(0.0)
                    PlayerLoanBalance.SetValue(0.0)
                    LoanPaymentDue.SetValue(0.0)
                EndIf
            EndIf
            index = ModAmount.length
        EndIf
        index += 1
    EndWhile
    DisplayUpdate(akTerminalRef)
EndEvent

Function DisplayUpdate(ObjectReference akTerminalRef)
    akTerminalRef.AddTextReplacementValue("Savings", PlayerAccountBalance.GetValue())
    akTerminalRef.AddTextReplacementValue("SavingsInterest", PlayerAccountInterest.GetValue())
    akTerminalRef.AddTextReplacementValue("Loan", PlayerLoanBalance.GetValue())
    akTerminalRef.AddTextReplacementValue("LoanInterest", PlayerLoanInterest.GetValue())
    akTerminalRef.AddTextReplacementValue("LoanInterestPeriod", LoanInterestPeriod.GetValue())
    akTerminalRef.AddTextReplacementValue("SavingsInterestPeriod", SavingsInterestPeriod.GetValue())
    akTerminalRef.AddTextReplacementValue("LoanPaymentDue", LoanPaymentDue.GetValue())

    TextPluralityCheck(PlayerAccountBalance, "CreditDisplaySavings", CreditSingular, CreditPlural, akTerminalRef)
    TextPluralityCheck(PlayerLoanBalance, "CreditDisplayLoan", CreditSingular, CreditPlural, akTerminalRef)
    TextPluralityCheck(LoanPaymentDue, "CreditDisplayLoanDue", CreditSingular, CreditPlural, akTerminalRef)
EndFunction

Function TextPluralityCheck(GlobalVariable checkedValue, string targetDataValue, Message singular, Message plural, ObjectReference akTerminalRef)
    If (checkedValue.GetValue() != 1.0)
        akTerminalRef.AddTextReplacementData(targetDataValue, plural)
    Else
        akTerminalRef.AddTextReplacementData(targetDataValue, singular)
    EndIf
EndFunction