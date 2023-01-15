//
//  Category.swift
//  Todo Swift UI
//
//  Created by kirshi on 1/13/23.
//

import Foundation

import Foundation
import RealmSwift

class Category: Object {
   @Persisted var name: String = ""
    @Persisted var items: List<Items> = List<Items>()
}
