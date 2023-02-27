//
//  VMPianoModel.swift
//  Piano
//
//  Created by Varvara Myronova on 14.02.2023.
//  Copyright © 2023 Ibram Uppal. All rights reserved.
//

import Foundation

enum VMKeyLabel: String, CaseIterable {
    case C = "C"
    case CSharp = "CSharp"
    case D = "D"
    case DSharp = "DSharp"
    case E = "E"
    case F = "F"
    case FSharp = "FSharp"
    case G = "G"
    case GSharp = "GSharp"
    case A = "A"
    case ASharp = "ASharp"
    case H = "H"
    case CHi = "CHi"
}

struct VMPianoModel {
    var keys = [VMKeyModel]()
    
    init() {
        VMKeyLabel.allCases.forEach { label in
            keys.append(VMKeyModel(label: label))
        }
    }
    
    public func playKey(_ keyName: String, _ play: Bool) {
        if let result = keys.first(
            where:
                { key in
                    key.label.rawValue == keyName
                })
        {
            result.play(play)
        }
    }
}
