//
//  Currency.swift
//  projectCoin
//
//  Created by Apple on 10.09.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import Foundation
import RealmSwift

class Currency: Object {

    dynamic var currencyID = UUID().uuidString
    
    dynamic var currency = ""
    
    override static func primaryKey() -> String? {
        return "currencyID"
    }

}

