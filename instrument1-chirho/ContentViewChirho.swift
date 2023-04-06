//
//  ContentView.swift
//  instrument1-chirho
//
//  Created by Hallelujah on 4/5/23.
//

import SwiftUI

enum CurrentViewChirho {
    case ContentViewChirho
    case SynthViewChirho
    
}


struct ContentViewChirho: View {
    @State public var currentViewChirho = CurrentViewChirho.ContentViewChirho

    var body: some View {
        VStack {
            Button(action: {
            }){
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hallelujah, world!")}
            SynthUIViewChirho()
        }
        .padding()
    }
}

struct ContentViewChirho_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewChirho()
    }
}
