//
//  ViewController.swift
//  TestSceneKit
//
//  Created by Robert Dickerson on 7/11/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class ViewController: UIViewController {

    
    //@IBOutlet weak var sceneKitView: SKView!
    
    var motionManager : CMMotionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = BubblesScene(size: view.bounds.size)
        let skView = view as! SKView
        
        //let skView = bubblesView
        
        //let skView = sceneKitView
        
        skView.showsFPS = true
        scene.scaleMode = SKSceneScaleMode.Fill
        
        skView.presentScene(scene)
        
        skView.sizeToFit()
        
        // acceleration stuff
        motionManager = CMMotionManager()
        if motionManager!.deviceMotionAvailable {
            println("Motion device Found!!")
            motionManager?.deviceMotionUpdateInterval = 0.005
            
            let queue = NSOperationQueue.mainQueue()
            motionManager?.startDeviceMotionUpdatesToQueue(queue) {
                (data, error) in
                // println (data)
                
                let bubblesView = scene as BubblesScene
                bubblesView.gravity = CGVectorMake(CGFloat(-2*data.gravity.x), CGFloat(-2*data.gravity.y))
                
            }

            
            // motionManager?.startDeviceMotionUpdates()
            
        } else {
            println("Motion device not available")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

