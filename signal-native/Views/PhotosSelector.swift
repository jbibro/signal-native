//
//  PhotosPicker.swift
//  signal-native
//
//  Created by Jakub Bibro on 25/05/2023.
//

import SwiftUI

import SwiftUI
import PhotosUI
import AppKit

struct PhotosSelector: View {
    @State var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        if let selectedImageData {
            let image = NSImage(data: selectedImageData)
            Image(nsImage: image!)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
        PhotosPicker(selection: $selectedItem,
                     matching: .images) {
            Image(systemName: "photo.on.rectangle")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 20))
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.borderless)
        .onChange(of: selectedItem) { newItem in
            Task {
                // Retrive selected asset in the form of Data
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }
}

struct PhotosSelector_Previews: PreviewProvider {
    
    static var previews: some View {
        PhotosSelector()
    }
}
