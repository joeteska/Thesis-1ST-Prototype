//
//  CurrencyManager.swift
//  Dolfin
//
//  Created by Alexandr Cizek on 06.03.2022.
//

import Foundation
import SwiftUI

class CurrencyManager{
    
    static let shared = CurrencyManager()
    
    @AppStorage("currency") var currencySign = "USD"
    
    
    func getCurrencySign() -> String{
        switch currencySign{
        case "USD":
            return "$"
        case "EUR":
            return "€"
        case "GBP":
            return "£"
        case "JPY":
            return "¥"
        case "MXN":
            return "$"
        default:
            return ""
        }
    }
}
