Scriptname GNG:AccountMenuScript extends TerminalMenu

GlobalVariable Property PlayerAccountBalance Auto Const

GlobalVariable Property PlayerLoanBalance Auto Const

GlobalVariable Property PlayerAccountInterest Auto Const

GlobalVariable Property PlayerLoanInterest Auto Const

GlobalVariable Property LoanInterestPeriod Auto Const Mandatory

GlobalVariable Property SavingsInterestPeriod Auto Const Mandatory

GlobalVariable Property AutoPayLoanAmount Auto Const

GlobalVariable Property AutoPaySavingsAmount Auto Const

GlobalVariable Property AutoPaySavingsActive Auto Const

GlobalVariable Property AutoPayLoanActive Auto Const

GlobalVariable Property LoanAccountStrikes Auto Const

GlobalVariable Property LoanAccountMaxStrikes Auto Const Mandatory

Message Property ActiveMessage Auto Const

Message Property CreditSingular Auto Const

Message Property CreditPlural Auto Const

Message Property InactiveMessage Auto Const

GlobalVariable Property LoanPaymentDue Auto Const

int Property SlateDispenseID Auto Const

Potion Property AccountSlate Auto Const


Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    akTerminalRef.AddTextReplacementValue("Savings", PlayerAccountBalance.GetValue())
    akTerminalRef.AddTextReplacementValue("SavingsInterest", PlayerAccountInterest.GetValue())
    akTerminalRef.AddTextReplacementValue("Loan", PlayerLoanBalance.GetValue())
    akTerminalRef.AddTextReplacementValue("LoanInterest", PlayerLoanInterest.GetValue())
    
    akTerminalRef.AddTextReplacementValue("LoanInterestPeriod", LoanInterestPeriod.GetValue())
    akTerminalRef.AddTextReplacementValue("SavingsInterestPeriod", SavingsInterestPeriod.GetValue())
    akTerminalRef.AddTextReplacementValue("LoanPaymentDue", LoanPaymentDue.GetValue())

    
    If (AutoPaySavingsActive.GetValue() > 0.0)
        akTerminalRef.AddTextReplacementData("AutoPaySavingsActive", ActiveMessage)
    Else
        akTerminalRef.AddTextReplacementData("AutoPaySavingsActive", InactiveMessage)
    EndIf

    If (AutoPayLoanActive.GetValue() > 0.0)
        akTerminalRef.AddTextReplacementData("AutoPayLoanActive", ActiveMessage)
    Else
        akTerminalRef.AddTextReplacementData("AutoPayLoanActive", InactiveMessage)
    EndIf

    TextPluralityCheck(PlayerAccountBalance, "CreditDisplaySavings", CreditSingular, CreditPlural, akTerminalRef)
    TextPluralityCheck(AutoPaySavingsAmount, "CreditDisplayAPSavings", CreditSingular, CreditPlural, akTerminalRef)
    TextPluralityCheck(PlayerLoanBalance, "CreditDisplayLoan", CreditSingular, CreditPlural, akTerminalRef)
    TextPluralityCheck(LoanPaymentDue, "CreditDisplayLoanDue", CreditSingular, CreditPlural, akTerminalRef)
    TextPluralityCheck(AutoPayLoanAmount, "CreditDisplayLoanPayoff", CreditSingular, CreditPlural, akTerminalRef)


    akTerminalRef.AddTextReplacementValue("AutoPayLoanAmount", AutoPayLoanAmount.GetValue())
    akTerminalRef.AddTextReplacementValue("AutoPaySavingsAmount", AutoPaySavingsAmount.GetValue())
    akTerminalRef.AddTextReplacementValue("LoanAccountStrikes", LoanAccountStrikes.GetValue())
    akTerminalRef.AddTextReplacementValue("LoanAccountMaxStrikes", LoanAccountMaxStrikes.GetValue())
EndEvent

Event OnTerminalMenuItemRun(int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    
    If (akTerminalBase == self && auiMenuItemID == SlateDispenseID)
        Game.GetPlayer().AddItem(AccountSlate)
    EndIf
EndEvent

Function TextPluralityCheck(GlobalVariable checkedValue, string targetDataValue, Message singular, Message plural, ObjectReference akTerminalRef)
    If (checkedValue.GetValue() != 1.0)
        akTerminalRef.AddTextReplacementData(targetDataValue, plural)
    Else
        akTerminalRef.AddTextReplacementData(targetDataValue, singular)
    EndIf
EndFunction