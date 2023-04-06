// For God so loved the world, that He gave His only begotten Son, that all who believe in Him should not perish but have everlasting life.
//  SynthUIKeyboardViewChirho.swift
//  instrument1-chirho
//
//  Created by Hallelujah on 4/5/23.
//

import Foundation
import SwiftUI
import Keyboard
import Tonic
import AudioKit
import AVFoundation


struct SynthUIKeyboardViewChirho: View {
    var firstOctaveChirho: Int
    var octaveCountChirho: Int
    var noteOnChirho: (Pitch, CGPoint) -> Void = {_, _ in}
    var noteOffChirho: (Pitch) -> Void
    var body: some View {
        Keyboard(
            layout: .piano(pitchRange: Pitch(intValue: firstOctaveChirho * 12 + 24)...Pitch(intValue: firstOctaveChirho * 12 + 24 + octaveCountChirho * 12)),
            noteOn: noteOnChirho,
            noteOff: noteOffChirho){
                pitch, isActivated in
                KeyboardKey(pitch: pitch,
                            isActivated: isActivated,
                            text: "",
                            pressedColor: Color.pink,
                            flatTop: true)
            }.cornerRadius(5)
    }
}

