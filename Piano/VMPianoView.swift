//
//  VMPianoView.swift
//  Piano
//
//  Created by Varvara Myronova on 14.02.2023.
//  Copyright © 2023 Ibram Uppal. All rights reserved.
//

import SceneKit

class VMPianoView: SCNView {
    
    var keysAttached = SCNNode()
    
    var touchKeys = [UITouch:VMKeyNode]()
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scene = SCNScene()
        backgroundColor = .gray
        isMultipleTouchEnabled = true

        setupCameraAndLights()
    }
    
    //MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touchKeys[touch] == nil, let key = keyAtPoint(touch.location(in: self)) {
                touchKeys[touch] = key
                
                play(key)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let key = keyAtPoint(touch.location(in: self)) {
                touchKeys[touch] = nil
                stopPlaying(key)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let key = keyAtPoint(touch.location(in: self)){
                if let previousKey = touchKeys[touch], previousKey != key {
                    stopPlaying(previousKey)
                    play(key)
                    touchKeys[touch] = key
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let key = keyAtPoint(touch.location(in: self)) {
                touchKeys[touch] = nil
                stopPlaying(key)
            }
        }
    }
    
    //MARK: - Public
    func configurePiano(_ piano: VMPianoModel) {
        setupKeysNode()
        
        let whiteKeys = piano.keys.filter { keyModel in
            keyModel.type == .white
        }
        
        let blackKeys = piano.keys.filter { keyModel in
            keyModel.type == .black
        }
        
        for (i, keyModel) in whiteKeys.enumerated() {
            let keyNode = VMKeyNode(key: keyModel, at: i)
            keysAttached.addChildNode(keyNode)
        }

        for (i, keyModel) in blackKeys.enumerated() {
            let keyNode = VMKeyNode(key: keyModel, at: i)
            keysAttached.addChildNode(keyNode)
        }
    }
    
    //MARK: - Private
    private func setupKeysNode() {
        keysAttached.position = SCNVector3(-0.15, 0.0, 0.0)
        keysAttached.rotation = SCNVector4(1.0, 0.0, 0.0, -2.4)
        let keyScalingConstant = 0.75
        keysAttached.scale = SCNVector3(keyScalingConstant, keyScalingConstant, keyScalingConstant)
        
        if let scene = scene {
            scene.rootNode.addChildNode(keysAttached)
        }
    }
    
    private func setupCameraAndLights() {
        if let rootNode = scene?.rootNode {
            let emptyZero = SCNNode()
            emptyZero.position = SCNVector3Zero
            rootNode.addChildNode(emptyZero)
            
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.camera!.usesOrthographicProjection = true
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
            
            let spotLight = SCNNode()
            spotLight.light = SCNLight()
            spotLight.light!.type = .spot
            spotLight.light!.castsShadow = true
            spotLight.light!.shadowSampleCount = 8
            spotLight.light!.attenuationStartDistance = 0.0
            spotLight.light!.attenuationFalloffExponent = 2.0
            spotLight.light!.attenuationEndDistance = 60.0
            spotLight.light!.color = UIColor(white: 1, alpha: 1)
            spotLight.position = SCNVector3(x: 0, y: 0, z: 9)
            
            let ambiLight = SCNNode()
            ambiLight.light = SCNLight()
            ambiLight.light!.type = .ambient
            ambiLight.light!.color = UIColor(white: 0.5, alpha: 1)
            
            cameraNode.constraints = [SCNLookAtConstraint(target: emptyZero)]
            spotLight.constraints = [SCNLookAtConstraint(target: emptyZero)]
            
            rootNode.addChildNode(cameraNode)
            rootNode.addChildNode(spotLight)
            rootNode.addChildNode(ambiLight)
        }
    }
    
    private func keyAtPoint(_ point: CGPoint) -> VMKeyNode? {
        let htResults = hitTest(point, options: nil)
        
        return htResults.first?.node as? VMKeyNode
    }
    
    private func play(_ key:VMKeyNode) {
        let piano = VMPianoModel.shared
        
        if let keyName = key.name {
            piano.playKey(keyName, true)
        }
    }
    
    private func stopPlaying(_ key: VMKeyNode) {
        let piano = VMPianoModel.shared
        
        if let keyName = key.name {
            piano.playKey(keyName, false)
        }
    }
}
