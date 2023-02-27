//
//  VMKeyModel.swift
//  Piano
//
//  Created by Varvara Myronova on 14.02.2023.
//  Copyright © 2023 Ibram Uppal. All rights reserved.
//

import Foundation
import AVFoundation

class VMKeyStroke {
    var sound: AVAudioPlayer?
    
    init(keyName: VMKeyLabel) {
        let fileName = "KeySounds/\(keyName.rawValue)Key"
    
        if let path = Bundle.main.path(forResource  : fileName,
                                       ofType       : "wav")
        {
            let url = NSURL(fileURLWithPath: path)
            do {
                sound = try AVAudioPlayer(contentsOf: url as URL)
            } catch _ {
                print("No sound to play")
            }
        }
    }
    
    func play() {
        if let sound = self.sound,
           !sound.isPlaying
        {
            sound.play()
        }
    }
    
    func stop() {
        if let sound = self.sound, sound.isPlaying {
            sound.stop()
            sound.currentTime = 0
            sound.play(atTime: sound.deviceCurrentTime)
        }
    }
}

class VMKeyModel: NSObject {
    var label     : VMKeyLabel
    var keyStroke : VMKeyStroke?
    
    @objc dynamic var pressed   : Bool
    
    enum kVMKeyType {
        case white
        case black
    }
    
    lazy var type : kVMKeyType = {
        switch label {
        case .A, .C, .D, .E, .F, .G, .H, .CHi:
            return .white
            
        case .ASharp, .CSharp, .DSharp, .FSharp, .GSharp:
            return .black
        }
    }()
    
    init(label: VMKeyLabel) {
        self.label = label
        pressed = false
    }
    
    public func play(_ play: Bool) {
        pressed = play
        
        let keyStroke = VMKeyStroke(keyName: label)
        if play {
            keyStroke.play()
        } else {
            keyStroke.stop()
        }
        
        self.keyStroke = keyStroke
    }
}
