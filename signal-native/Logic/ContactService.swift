//
//  Contacts.swift
//  signal-native
//
//  Created by Jakub Bibro on 05/05/2023.
//

import Foundation
import OrderedCollections
import Combine
import CoreSpotlight

class ContactService: ObservableObject {
        
    @Published var contactNames: OrderedDictionary<String, String> = [
        "+48123123123": "Jan",
    ]
    
    func indexData() {
        var searchableItems = [CSSearchableItem]()
        
        contactNames.forEach {
            // Set attributes
            let attributeSet = CSSearchableItemAttributeSet(contentType: .message)
            attributeSet.displayName = $0.value
            attributeSet.identifier = $0.key
            attributeSet.kind = "Signal Contact"
            
            // Create searchable item
            let searchableItem = CSSearchableItem(uniqueIdentifier: nil, domainIdentifier: "Signal", attributeSet: attributeSet)
            searchableItems.append(searchableItem)
        }
        
        // Submit for indexing
        CSSearchableIndex.default().indexSearchableItems(searchableItems)
    }
}
