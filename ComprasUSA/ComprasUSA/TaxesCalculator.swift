//
//  TaxesCalculator.swift
//  ComprasUSA
//
//  Created by Vitor Gomes on 22/05/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import Foundation

class TaxesCalculator {
    
    static let shared = TaxesCalculator()
    var dolar: Double = 3.5
    var iof: Double = 6.38
    var statetax: Double = 7.0
    var shoppingValue: Double = 0
    
    let formatter = NumberFormatter() //usando o number formatter
    
    //variaveis computadas
    var shoppingValueinReal: Double {
        return shoppingValue * dolar
    }
    
    var stateTaxValue: Double {
        return shoppingValue * statetax / 100
    }
    
    var iofValue: Double {
        return (shoppingValue + statetax) * iof / 100
    }
    
    func calculate(usingCreditCard: Bool) -> Double {
        var finalValue = shoppingValue + stateTaxValue
        if usingCreditCard {
            finalValue += iofValue
        }        
        return finalValue * dolar
    }
    
    func convertToDouble(_ string: String) -> Double {
        formatter.numberStyle = .none
        return formatter.number(from: string)!.doubleValue
    }
    
    func getFormattedValue(of value: Double, withCurrency currency: String) -> String {
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(for: value)!
    }
    
    private init() {
        formatter.usesGroupingSeparator = true
    }
}
