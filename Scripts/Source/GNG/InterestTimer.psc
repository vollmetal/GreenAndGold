Scriptname GNG:InterestTimer extends Quest
{Controls when interest is accrued on an account.}

bool Property IsDebt Auto Const

GlobalVariable Property TimerSettingDays Auto Const

GlobalVariable Property ManagedAccount Auto Const

GlobalVariable Property AccountOpened Auto Const

GlobalVariable Property InterestRate Auto Const

GlobalVariable Property AccountState Auto Const

GlobalVariable Property AutoPay Auto Const

GlobalVariable Property AutoPayAmount Auto Const

GlobalVariable Property AutoPayInterest Auto Const

GlobalVariable Property PaymentDue Auto Const

GlobalVariable Property AccountStrikes Auto Const

GlobalVariable Property MaxAccountStrikes Auto Const

GlobalVariable Property LoanCollectionsAmount Auto Const

Message Property InterestMessage Auto Const Mandatory

Message Property AutoPayMessageSuccess Auto Const

Message Property AutoPayMessageFail Auto Const

Message Property PaymentDueMessage Auto Const

Message Property StrikesAccruedMessage Auto Const

Message Property LoanCollectionsMessage Auto Const

Faction Property OwningFaction Auto Const

bool Property CloseAccountOnEmpty Auto Const

Event OnQuestInit()
    StartTimerGameTime(TimerSettingDays.GetValue() * 24.0)
EndEvent

Event OnTimerGameTime(int aiTimerID)
    ObjectReference player = Game.GetPlayer()
    MiscObject credit = Game.GetCredits()

    float interest = ManagedAccount.GetValue() * (InterestRate.GetValue() * 0.01)
    float interestPaymentDue = PaymentDue.GetValue()

    float paymentAmount = AutoPayAmount.GetValue()

    If (IsDebt)
        If (AutoPay.GetValue() > 0.0 && ManagedAccount.GetValue() > 0.0)
            If (AutoPayInterest.GetValue() > 0.0 && interestPaymentDue > 0.0)
                If (player.GetItemCount(credit) >= interestPaymentDue)
                    player.RemoveItem(credit, interestPaymentDue as int)
                    AutoPayMessageSuccess.Show(interestPaymentDue)
                    PaymentDue.SetValue(0.0)
                Else
                    float leftoverInterest = interestPaymentDue - player.GetItemCount(credit)
                    player.RemoveItem(credit, (interestPaymentDue - leftoverInterest) as int)
                    ManagedAccount.SetValue(ManagedAccount.GetValue() + leftoverInterest)
                    PaymentDue.SetValue(leftoverInterest)
                    AutoPayMessageFail.Show((interestPaymentDue - leftoverInterest))
                EndIf
            Else
                
                
                If (paymentAmount > ManagedAccount.GetValue())
                    paymentAmount = ManagedAccount.GetValue()
                    
                EndIf
                If (player.GetItemCount(credit) >= paymentAmount)
                    player.RemoveItem(credit, paymentAmount as int)
                    ManagedAccount.SetValue((ManagedAccount.GetValue() + interest) - paymentAmount)
                    PaymentDue.SetValue(interestPaymentDue - paymentAmount)
                    AutoPayMessageSuccess.Show(paymentAmount)
                Else
                    float leftoverPayment = paymentAmount - player.GetItemCount(credit)
                    player.RemoveItem(credit, (paymentAmount - leftoverPayment) as int)
                    ManagedAccount.SetValue((ManagedAccount.GetValue() + interest) - leftoverPayment)
                    PaymentDue.SetValue(interestPaymentDue - leftoverPayment)
                    AutoPayMessageFail.Show((paymentAmount - leftoverPayment))
                EndIf
            EndIf
            
        ElseIf(ManagedAccount.GetValue() > 0.0)
            ManagedAccount.SetValue(ManagedAccount.GetValue() + interest)
        EndIf

        interestPaymentDue = PaymentDue.GetValue()
            
        If (interestPaymentDue > 1.0 && ManagedAccount.GetValue() > 0.0)
            OverdraftCalc(ManagedAccount.GetValue(), AccountStrikes, OwningFaction)
        Else
            If (accountStrikes.GetValue() > 0.0)
                accountStrikes.SetValue(accountStrikes.GetValue() - 1.0)
            EndIf
        EndIf

        If (ManagedAccount.GetValue() > 0.0)
            PaymentDue.SetValue((ManagedAccount.GetValue() * (InterestRate.GetValue() * 0.01)) + interestPaymentDue)
            InterestMessage.Show(interest, ManagedAccount.GetValue())
            PaymentDueMessage.Show(PaymentDue.GetValue(), TimerSettingDays.GetValue())
            StartTimerGameTime(TimerSettingDays.GetValue() * 24.0)
        Else
            AccountState.SetValue(0.0)
            self.Stop()            
        EndIf
    Else
        ManagedAccount.SetValue(ManagedAccount.GetValue() + interest)
        InterestMessage.Show(interest, ManagedAccount.GetValue())
        If (AutoPay.GetValue() > 0.0)
            If (player.GetItemCount(credit) >= paymentAmount)
                player.RemoveItem(credit, paymentAmount as int)
                ManagedAccount.SetValue(ManagedAccount.GetValue() + paymentAmount)
                AutoPayMessageSuccess.Show(paymentAmount)
            Else
                float leftoverInterest = paymentAmount - player.GetItemCount(credit)
                player.RemoveItem(credit, (paymentAmount - leftoverInterest) as int)
                ManagedAccount.SetValue(ManagedAccount.GetValue() + leftoverInterest)
                AutoPayMessageFail.Show((paymentAmount - leftoverInterest), paymentAmount)
            EndIf
        EndIf
        StartTimerGameTime(TimerSettingDays.GetValue() * 24.0)
    EndIf
EndEvent

Function OverdraftCalc(float amount, GlobalVariable accountStrikes, Faction bountyFaction)
    
    If ((accountStrikes.GetValue() + 1) < MaxAccountStrikes.GetValue())
        accountStrikes.SetValue(accountStrikes.GetValue() + 1.0)
        StrikesAccruedMessage.Show(accountStrikes.GetValue())
    Else
        accountStrikes.SetValue(0.0)
        LoanCollectionsMessage.Show(amount)
        bountyFaction.ModCrimeGold(amount as int)
        LoanCollectionsAmount.SetValue(amount)
        ManagedAccount.SetValue(0.0)
        PaymentDue.SetValue(0.0)
        AutoPay.SetValue(0.0)
        AccountOpened.SetValue(0.0)
        

    EndIf
EndFunction