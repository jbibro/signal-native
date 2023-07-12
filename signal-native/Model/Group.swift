//
//  Group.swift
//  signal-native
//
//  Created by Jakub Bibro on 17/05/2023.
//

import Foundation

struct Group: Identifiable, Hashable {
    let name: String
    var id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}
