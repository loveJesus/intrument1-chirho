// For God so loved the world, that He gave His only begotten Son, that all who believe in Him should not perish but have everlasting life.
// Thank You Lord Jesus Christ for being so good
// help from https://www.youtube.com/watch?v=OoYEYCCJyCA synth app ~ 100 lines of code
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
    static let initialCutoffChirho = 20_000.0
    @Published var octaveChirho = 1
    @Published var noteRangeChirho = 2
    let filterChirho : MoogLadder
    let ampEnvelopeChirho : AmplitudeEnvelope
    @Published var cutoffChirho = AUValue(initialCutoffChirho) {
        didSet {filterChirho.cutoffFrequency = AUValue(Int(cutoffChirho))}
    }
    @Published var resonanceChirho = AUValue(0.0) {
        didSet {filterChirho.resonance = AUValue(resonanceChirho)}
    }
    @Published var attackChirho = AUValue(0.0) {
        didSet {ampEnvelopeChirho.attackDuration = AUValue(attackChirho)}
    }
    @Published var decayChirho = AUValue(0.0) {
        didSet {ampEnvelopeChirho.decayDuration = AUValue(decayChirho)}
    }
    @Published var sustainChirho = AUValue(1.0) {
        didSet {ampEnvelopeChirho.sustainLevel = AUValue(sustainChirho)}
    }
    @Published var releaseChirho = AUValue(0.0) {
        didSet {ampEnvelopeChirho.releaseDuration = AUValue(releaseChirho)}
    }
    
    
    let oscChirho = [
        MorphingOscillator(index:0.75, detuningOffset: -0.5),
        MorphingOscillator(index:0.75, detuningOffset: 0.5),
        MorphingOscillator(index:2.75)]
    
    init() {
        filterChirho = MoogLadder(Mixer(oscChirho[0], oscChirho[1], oscChirho[2]), cutoffFrequency: AUValue(Self.initialCutoffChirho), resonance: AUValue(0.0))
        ampEnvelopeChirho = AmplitudeEnvelope(filterChirho, attackDuration: 0.00, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0)
        engineChirho.output = ampEnvelopeChirho
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
        ampEnvelopeChirho.openGate()
    }
    func noteOffChirho(pitchChirho: Pitch) {
        //dataChirho.isPlayingChirho = false
        ampEnvelopeChirho.closeGate()
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
                HStack{
                    VStack {
                        Text("Filt.")
                        Text("\(Int(conductorChirho.cutoffChirho))")
                        SmallKnob(value: $conductorChirho.cutoffChirho, range: 12.0 ... 20_000.0).frame(maxWidth: 50)
                    }
                    VStack {
                        Text("Res.")
                        Text("\(Int(conductorChirho.resonanceChirho*100.0))")
                        SmallKnob(value: $conductorChirho.resonanceChirho, range: 0.0 ... 1.0).frame(maxWidth: 50).padding(.bottom, 10)
                    }
                    VStack {
                        Text("Att.")
                        Text("\(Int(conductorChirho.attackChirho*1000.0))ms")
                        SmallKnob(value: $conductorChirho.attackChirho, range: 0.0 ... 10.0).frame(maxWidth: 50).padding(.bottom, 10)
                    }
                    VStack {
                        Text("Dec.")
                        Text("\(Int(conductorChirho.decayChirho*1000.0))ms")
                        SmallKnob(value: $conductorChirho.decayChirho, range: 0.0 ... 10.0).frame(maxWidth: 50).padding(.bottom, 10)
                    }
                    VStack {
                        Text("Sus.")
                        Text("\(Int(conductorChirho.sustainChirho*100.0))%")
                        SmallKnob(value: $conductorChirho.sustainChirho, range: 0.0 ... 1.0).frame(maxWidth: 50).padding(.bottom, 10)
                    }
                    VStack {
                        Text("Rel.")
                        Text("\(Int(conductorChirho.releaseChirho*1000.0))ms")
                        SmallKnob(value: $conductorChirho.releaseChirho, range: 0.0 ... 10.0).frame(maxWidth: 50).padding(.bottom, 10)
                    }
                }.padding(.bottom, 10).padding(.top, 10)

                HStack {
                    Spacer()
                    Button(action: {
                        conductorChirho.noteRangeChirho = max(1,conductorChirho.noteRangeChirho-1)}) {
                            Image(systemName: "arrowtriangle.backward.fill").foregroundColor(.white)}
                    Text("Range: \(conductorChirho.noteRangeChirho + 1)").frame(maxWidth: 150)
                    Button(action: {conductorChirho.noteRangeChirho = min(4, conductorChirho.noteRangeChirho + 1)}) {
                        Image(systemName: "arrowtriangle.forward.fill").foregroundColor(.white)}
                    Button(action: {
                        conductorChirho.octaveChirho = max(0,conductorChirho.octaveChirho-1)}) {
                            Image(systemName: "arrowtriangle.backward.fill").foregroundColor(.white)}
                    Text("Octave: \(conductorChirho.octaveChirho + 1)").frame(maxWidth: 150)
                    Button(action: {conductorChirho.octaveChirho = min(3, conductorChirho.octaveChirho + 1)}) {
                        Image(systemName: "arrowtriangle.forward.fill").foregroundColor(.white)}
                    
                    
                }.frame(maxWidth: 400)
                SynthUIKeyboardViewChirho(firstOctaveChirho: conductorChirho.octaveChirho, octaveCountChirho: conductorChirho.noteRangeChirho,  noteOnChirho: conductorChirho.noteOnChirho(pitchChirho:pointChirho:), noteOffChirho: conductorChirho.noteOffChirho(pitchChirho:)).frame(maxHeight: 600)
            }
        }.foregroundColor(.white)
    }
}

struct SynthUIViewChirho_Previews: PreviewProvider {
    static var previews: some View {
        SynthUIViewChirho()
    }
}
