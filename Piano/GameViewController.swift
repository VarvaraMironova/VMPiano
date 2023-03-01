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
    let piano = VMPianoModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sceneView = view as? VMPianoView {
            sceneView.configurePiano(piano)
        }
    }

}
