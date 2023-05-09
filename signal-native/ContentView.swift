//
//  ContentView.swift
//  signal-native
//
//  Created by Jakub Bibro on 26/04/2023.
//

import SwiftUI

struct ContentView: View {
       
    var body: some View {
        NavigationView {
            ContactList()
        }
        .navigationTitle("Signal Native")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
