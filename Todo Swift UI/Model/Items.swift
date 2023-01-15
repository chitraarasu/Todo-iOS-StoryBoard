//
//  Items.swift
//  Todo Swift UI
//
//  Created by kirshi on 1/13/23.
//

import Foundation
import RealmSwift

class Items: Object {
   @Persisted var title: String = ""
    @Persisted var done: Bool = false
}
