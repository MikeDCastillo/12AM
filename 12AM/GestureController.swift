//
//  GestureController.swift
//  12AM
//
//  Created by Michael Castillo on 4/21/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CoreMotion

struct GestureController {
    
    static let shared = GestureController()
    
    var motionManager = CMMotionManager()
    let currentOpQueueOptional = OperationQueue.current
        
        // MARK: - Gyroscope Functions
    
  
        
        func deviceRotatedOnXAxis() {
            guard let currentOpQueue = currentOpQueueOptional else { return }
            
            motionManager.gyroUpdateInterval = 0.2
            motionManager.startGyroUpdates(to: currentOpQueue) { (data, error) in
                if let data = data {
                    print(data.rotationRate)
                    
                    if data.rotationRate.x > 3 {
                        
                        print("Device has been tilted greater than \(data.rotationRate)")
                    }
                }
            }
        }
        
        func deviceRotatedOnYAxis() {
            guard let currentOpQueue = currentOpQueueOptional else { return }
            
            motionManager.gyroUpdateInterval = 0.2
            motionManager.startGyroUpdates(to: currentOpQueue) { (data, error) in
                if let data = data {
                    print(data.rotationRate)
                    if data.rotationRate.y > 3 {
                        print("Device has been tilted greater than \(data.rotationRate)")
                    }
                }
            }
        }
        
        func deviceRotatedOnZAxis() {
            guard let currentOpQueue = currentOpQueueOptional else { return }
            
            motionManager.gyroUpdateInterval = 0.2
            motionManager.startGyroUpdates(to: currentOpQueue) { (data, error) in
                if let data = data {
                    print(data.rotationRate)
                    if data.rotationRate.z > 3 {
                        print("Device has been tilted greater than \(data.rotationRate)")
                    }
                }
            }
        }

}
