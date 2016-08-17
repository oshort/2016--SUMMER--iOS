import Foundation

class TipCalculator
{
    let total: Double
    let taxPct: Double
    let subTotal: Double
    
    init(total: Double, taxPct: Double)
    {
        self.total = total
        self.taxPct = taxPct
        subTotal = total / (taxPct + 1)
    }
    
    func calcTipWithTipPct(tipPct: Double) -> Double
    {
        return subTotal * tipPct
    }
    
    func printPossibleTips()
    {
        print("15%: $\(calcTipWithTipPct(tipPct: 0.15))")
        print("18%: $\(calcTipWithTipPct(tipPct: 0.18))")
        print("20%: $\(calcTipWithTipPct(tipPct: 0.20))")
    }
    
    func calculateTips(tipPercentages: [Double]) -> [Int: Double]
    {
        var tipAmounts = [Int: Double]()
        for possibleTip in tipPercentages
        {
            let intPct = Int(possibleTip*100)
            tipAmounts[intPct] = calcTipWithTipPct(tipPct: possibleTip)
        }
        return tipAmounts
    }
}

let tipCalc = TipCalculator(total: 20.15, taxPct: 0.07)
//tipCalc.printPossibleTips()
tipCalc.calculateTips(tipPercentages: [0.15, 0.20, 0.25])

// tuple
let tipAndTotal = (4.00, 25.19)
tipAndTotal.0
tipAndTotal.1

let (theTipAmt, theTotal) = tipAndTotal
theTipAmt
theTotal

let tipAndTotalNamed = (tipAmt: 2.50, total: 12.80)
tipAndTotalNamed.0
tipAndTotalNamed.tipAmt

let totalBill = 21.19
let taxPercent = 0.07
let subTotal = totalBill / (taxPercent + 1)
func calcTip(tipPercent: Double) -> (tipAmount: Double, total: Double)
{
    let tipAmount = subTotal * tipPercent
    let finalTotal = totalBill + tipAmount
    return (tipAmount, finalTotal)
}
let billInfo = calcTip(tipPercent:0.20)
billInfo.tipAmount
billInfo.total










