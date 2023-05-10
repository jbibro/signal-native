//
//  Contacts.swift
//  signal-native
//
//  Created by Jakub Bibro on 05/05/2023.
//

import Foundation
import OrderedCollections
import Combine

class Contacts: ObservableObject {
    @Published var contacts: OrderedDictionary<String, Contact> = [
        "+48693985499": Contact(name: "Miko", phoneNumber: "+48693985499"),
        "+48669416529": Contact(name: "Aniusia😍", phoneNumber: "+48669416529"),
        "+48504695051": Contact(name: "Mama", phoneNumber: "+48504695051")
    ]
    
    subscript(phoneNumber: String) -> Contact? {
        get {
            return contacts[phoneNumber]
        }
    }
}
