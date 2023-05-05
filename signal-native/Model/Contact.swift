//
//  Contact.swift
//  signal-native
//
//  Created by Jakub Bibro on 03/05/2023.
//

import Foundation

struct Contact: Identifiable, Hashable {
    var name: String
    
    var id: String {
        get {
            name
        }
    }
    
}
