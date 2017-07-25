//
//  Balance.swift
//  projectCoin
//
//  Created by Apple on 19.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import Foundation
import RealmSwift

class Balance: Object {

    dynamic var objectID = UUID().uuidString
    
    dynamic var anountBalance = 0
    dynamic var date = ""
    dynamic var deadline = ""
    
    dynamic var tomorrow = 0
    dynamic var today = 0
    dynamic var temporaryBalance = 0

    override static func primaryKey() -> String? {
        return "objectID"
    }

}
