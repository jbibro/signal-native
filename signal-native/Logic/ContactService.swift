//
//  Contacts.swift
//  signal-native
//
//  Created by Jakub Bibro on 05/05/2023.
//

import Foundation
import OrderedCollections
import Combine

class ContactService: ObservableObject {
        
    @Published var contactNames: OrderedDictionary<String, String> = [
        "+48693985499": "Miko",
        "+48669416529": "Aniusia😍",
        "+48504695051": "Mama"
    ]
    
    subscript(id: String) -> String? {
        get {
            return contactNames[id]
        }
    }
}
