//
//  AnimationHelpers.swift
//  12AM
//
//  Created by Michael Castillo on 4/28/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

struct AnimationHelper {
    
    class GameScene: SKScene {
        
        var FadeInOutAnimationSequence: SKAction {
            
            return SKAction.sequence([SKAction.fadeOut(withDuration: 1.5), SKAction.wait(forDuration: 2.0), SKAction.fadeIn(withDuration: 1.5)])
        }
        
        override func didMove(to view: SKView) {
            
            let myLabel = SKLabelNode(fontNamed: "Zapfino")
            myLabel.text = Date().timeTillString
            myLabel.fontSize = 20
        }
        
    }
    
}
