//
//  GameViewController.swift
//  Piano
//
//  Created by Ibram Uppal on 11/2/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView?
    let piano = VMPianoModel()
    
    @IBAction func onPanGR(_ sender: UILongPressGestureRecognizer) {
        if let sceneView = view as? VMPianoView {
            for i in 0...sender.numberOfTouches-1 {
                if let keyName = sceneView.keyAtPoint(sender.location(ofTouch : i,
                                                                      in      : sceneView))
                {
                    switch sender.state {
                    case .began:
                        piano.playKey(keyName, true)
                        break
                        
                    case .ended, .cancelled, .failed:
                        piano.playKey(keyName, false)
                        break
                        
                    default:
                        break
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sceneView = view as? VMPianoView {
            sceneView.configurePiano(piano)
        }
    }

}
