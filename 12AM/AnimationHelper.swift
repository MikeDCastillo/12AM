//
//  AnimationHelper.swift
//  12AM
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
