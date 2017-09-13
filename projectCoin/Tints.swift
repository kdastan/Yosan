//
//  Tints.swift
//  projectCoin
//
//  Created by Apple on 12.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//
import UIKit

extension UIColor {
    static let dateColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)
    static let moneyColor = UIColor(red: 137/255, green: 213/255, blue: 226/255, alpha: 1)
    static let moneyInfoColor = UIColor(red: 118/255, green: 124/255, blue: 154/255, alpha: 1)
    static let infoColor = UIColor(red: 69/255, green: 96/255, blue: 121/255, alpha: 1)
    static let backgroundColor = UIColor(red: 44/255, green: 50/255, blue: 80/255, alpha: 1)
    static let calendarTodayColor = UIColor(red: 189/255, green: 51/255, blue: 46/255, alpha: 1)
}

extension Date {
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
}

extension ViewController {
    static let descDeadline = "Here shows date when your choosen interval ends"
    static let descRemainMoney = "Total amount of money left in your balance"
    static let descButton = "Add new expense, choose category and spent money"
    static let descAvailableMoneyToday = "Available money to spend today"
    static let descAvailableMoneyTomorrow = "Available money to spend tomorrow"
    static let descChart = "Visual appearance of spent money"
    static let currencyChager = "Change currency"
}
