//
//  SynthChirhoUIView.swift
//  instrument1-chirho
//
//  Created by Hallelujah on 4/5/23.
//

import SwiftUI
import AudioKit
import Keyboard
import Tonic
import SoundpipeAudioKit
import Controls

struct MorphingOscillatorDataChirho {
    var isPlayingChirho: Bool = false
    var frequencyChirho: AUValue = 440
    var octaveFrequencyChirho: AUValue = 440
    var amplitudeChirho: AUValue = 0.2
    var rampDurationChirho: AUValue = 0.1
}
class SynthClassChirho: ObservableObject {
    let engineChirho = AudioEngine()
    @Published var octaveChirho = 1
    @Published var noteRangeChirho = 2
    
    let oscChirho = [
        MorphingOscillator(index:0.75, detuningOffset: -0.5),
        MorphingOscillator(index:0.75, detuningOffset: 0.5),
        MorphingOscillator(index:2.75)]
    
    init() {
        engineChirho.output = Mixer(oscChirho[0], oscChirho[1], oscChirho[2])
        try? engineChirho.start()
    }
    
    @Published var dataChirho = MorphingOscillatorDataChirho() {
        didSet {
            if dataChirho.isPlayingChirho {
                for i_chirho in 0...2 {
                    oscChirho[i_chirho].start()
                    oscChirho[i_chirho].$amplitude.ramp(
                        to:dataChirho.amplitudeChirho, duration: 0)
                }
                oscChirho[0].$frequency.ramp(
                    to:dataChirho.frequencyChirho, duration: dataChirho.rampDurationChirho)
                oscChirho[1].$frequency.ramp(
                    to:dataChirho.frequencyChirho, duration: dataChirho.rampDurationChirho)
                oscChirho[2].$frequency.ramp(
                    to:dataChirho.frequencyChirho, duration: dataChirho.rampDurationChirho)
            } else {
                for i_chirho in 0...2 {
                    oscChirho[i_chirho].amplitude = 0.0
                }
            }
        }
    }
    func noteOnChirho(pitchChirho: Pitch, pointChirho: CGPoint) {
        dataChirho.isPlayingChirho = true
        dataChirho.frequencyChirho = AUValue(pitchChirho.midiNoteNumber).midiNoteToFrequency()
        dataChirho.octaveFrequencyChirho =
            AUValue(pitchChirho.midiNoteNumber - 12).midiNoteToFrequency()
        
    }
    func noteOffChirho(pitchChirho: Pitch) {
        dataChirho.isPlayingChirho = false
    }
}
struct SynthUIViewChirho: View {
    @StateObject var conductorChirho = SynthClassChirho()
    var body: some View {
        
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.pink.opacity(0.5), .black]),
                           center: .center,
                           startRadius: 2,
                           endRadius: 650).edgesIgnoringSafeArea(.all)
            VStack{
                Text("Hallelujah, World!")
                HStack {
                    Spacer()
                    Button(action: {
                        conductorChirho.noteRangeChirho = max(1,conductorChirho.noteRangeChirho-1)}) {
                            Image(systemName: "arrowtriangle.backward.fill").foregroundColor(.white)}
                    Text("Range: \(conductorChirho.noteRangeChirho + 1)").frame(maxWidth: 150)
                    Button(action: {conductorChirho.noteRangeChirho = min(4, conductorChirho.noteRangeChirho + 1)}) {
                        Image(systemName: "arrowtriangle.forward.fill").foregroundColor(.white)}
                    Button(action: {
                        conductorChirho.octaveChirho = max(1,conductorChirho.octaveChirho-1)}) {
                            Image(systemName: "arrowtriangle.backward.fill").foregroundColor(.white)}
                    Text("Octave: \(conductorChirho.octaveChirho + 1)").frame(maxWidth: 150)
                    Button(action: {conductorChirho.octaveChirho = min(3, conductorChirho.octaveChirho + 1)}) {
                        Image(systemName: "arrowtriangle.forward.fill").foregroundColor(.white)}
                    
                    
                }.frame(maxWidth: 400)
                SynthUIKeyboardViewChirho(firstOctaveChirho: conductorChirho.octaveChirho, octaveCountChirho: conductorChirho.noteRangeChirho,  noteOnChirho: conductorChirho.noteOnChirho(pitchChirho:pointChirho:), noteOffChirho: conductorChirho.noteOffChirho(pitchChirho:))

                
            }
        }
    }
}

struct SynthUIViewChirho_Previews: PreviewProvider {
    static var previews: some View {
        SynthUIViewChirho()
    }
}
