//
//  MessageDestination.swift
//  signal-native
//
//  Created by Jakub Bibro on 23/05/2023.
//

import Foundation

protocol MessageDestination: Hashable {
    var id: String { get }
}
