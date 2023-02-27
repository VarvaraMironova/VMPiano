//
//  VMKeyNode.swift
//  Piano
//
//  Created by Varvara Myronova on 14.02.2023.
//  Copyright © 2023 Ibram Uppal. All rights reserved.
//

import UIKit
import SceneKit

class VMKeyNode: SCNNode {
    
    var kvoToken: NSKeyValueObservation?
    
    deinit {
        kvoToken?.invalidate()
    }
    
    init(key: VMKeyModel, at index: Int) {
        super.init()
        
        if let pianoScene = SCNScene(named: "art.scnassets/PianoKeys.dae") {
            var keyNodeName = String()
            var x = 0.0
            var y = 0.0
            var z = 0.0
            
            if key.type == .white {
                keyNodeName = "WhiteKey"
                x = -2.0 + 0.65 * Double(index)
            } else {
                keyNodeName = "BlackKey"
                if index < 2 {
                    x = -1.7 + 0.65 * Double(index)
                } else {
                    x = -1.05 + 0.65 * Double(index)
                }
                
                y = -0.4
                z = 0.7
            }
            
            if let keyNode = pianoScene.rootNode.childNode(withName : keyNodeName,
                                                           recursively: true)
            {
                position = SCNVector3(x, y, z)
                name = key.label.rawValue
                geometry = keyNode.geometry
            }
            
            observe(keyModel: key)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe(keyModel: VMKeyModel) {
        kvoToken = keyModel.observe(\.pressed,
                                    options: (.new),
                                    changeHandler:
            {(keyModel, change) in
                self.animate(isPressed: keyModel.pressed)
            }
        )
    }
    
    private func animate(isPressed: Bool) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else { return }
            SCNTransaction.begin()
            
            if let material = strongSelf.geometry?.firstMaterial {
                if isPressed {
                    SCNTransaction.animationDuration = 0.3
                    material.emission.contents = UIColor.red
                    strongSelf.position.y += 0.2
                } else {
                    SCNTransaction.animationDuration = 0.0
                    material.emission.contents = UIColor.black
                    strongSelf.position.y -= 0.2
                }
            }
            
            SCNTransaction.commit()
        }
    }
}
