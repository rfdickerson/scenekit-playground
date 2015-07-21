//
//  BubblesScene.swift
//  TestSceneKit
//
//  Created by Robert Dickerson on 7/11/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit
import SpriteKit

class BubblesScene: SKScene, SKPhysicsContactDelegate {
   
    let genreList = [
            Genre(name: "Rock", popularity: 0.6),
            Genre(name: "Country", popularity: 0.4),
            Genre(name: "Blues", popularity: 0.2),
            Genre(name: "Polka", popularity: 0.3),
            Genre(name: "Hip hop", popularity: 0.3),
            Genre(name: "Folk", popularity: 0.2),
            Genre(name: "Electronic", popularity: 0.3)
    ]
    
    func genreToBubble(genre: Genre) -> Bubble?
    {
        var randomNumber : Int = Int(rand()) % 10
        let xPosition : CGFloat = CGFloat(randomNumber)*15.0 + 50.0
        let yPosition : CGFloat = CGFloat(randomNumber)*55.0

        let bubbleSize : CGFloat = CGFloat(genre.popularity * 150)
        let bubble = Bubble(label: genre.name, radius: bubbleSize)
        bubble?.position = CGPoint(x: xPosition, y: yPosition)
        
        return bubble
    }
    
    class Bubble : SKNode
    {
        var selected: Bool = false
        
        
        let selectedColor = UIColor(red: 13/256, green: 213/256, blue: 216/256, alpha: 1.0)
        let unselectedColor = UIColor(red: 13/256, green: 120/256, blue: 131/256, alpha: 1.0)
        
        var label : String!
        
        // holds the circle vector shape
        var shape : SKShapeNode!
        
        init?(label: String, radius: CGFloat)
        {
            self.label = label
            super.init()
            //super.init(circleOfRadius: radius)
            shape = SKShapeNode(circleOfRadius: radius)
            
            physicsBody = SKPhysicsBody(circleOfRadius: radius)
            //bubble.physicsBody?.dynamic = true
            physicsBody?.collisionBitMask = PhysicsCategory.All
            physicsBody?.allowsRotation = false
            
            /*
            let myPath = CGPathCreateMutable()
            CGPathAddEllipseInRect(myPath, nil, CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2))
            super.path = myPath
*/
            
            shape.fillColor = unselectedColor
            shape.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            shape.lineWidth = 0
            addChild(shape)
            
            let label = SKLabelNode(text: label)
            label.fontSize = 18
            label.fontName = "Open Sans Semi Bold"
            self.addChild(label)
            
            
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func toggle () -> Bool
        {
            
            let changeColor = SKAction.customActionWithDuration(0.2, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
                
                let n = node as! Bubble
                
                let step = elapsedTime/0.2
                
                var to = CGColorGetComponents(self.unselectedColor.CGColor)
                var from = CGColorGetComponents(self.unselectedColor.CGColor)
                
                if self.selected {
                     to = CGColorGetComponents(self.selectedColor.CGColor)
                     from = CGColorGetComponents(self.unselectedColor.CGColor)
                }
                
                
                let red = from[0] - (from[0] - to[0])*step
                let green = from[1] - (from[1] - to[1])*step
                let blue = from[2] - (from[2] - to[2])*step
                
                let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                n.shape.fillColor = color
                
            })
            
            self.runAction(changeColor)
            
            selected = !selected
            return selected
        }
    }
    
    struct PhysicsCategory {
        static let None     : UInt32 = 0
        static let All      : UInt32 = UInt32.max
        static let Bubble   : UInt32 = 0b1
        static let Wall     : UInt32 = 0b10
    }
    
    var gravity : CGVector {
        set {
            super.physicsWorld.gravity = newValue
        }
        get {
            return super.physicsWorld.gravity
        }
    }
    
    var bubbles : [Bubble] = Array()
    
    private var toggled : Bool = false
    
    let wallColor = UIColor(red: 4/256, green: 56/256, blue: 70/256, alpha: 1.0)
    let selectedColor = UIColor(red: 13/256, green: 213/256, blue: 216/256, alpha: 1.0)
    let unselectedColor = UIColor(red: 13/256, green: 120/256, blue: 131/256, alpha: 1.0)
    
    let bgColor = UIColor(red: 13/256, green: 70/256, blue: 86/256, alpha: 1.0)
    
    private var topWall : SKShapeNode?
    
    private var profilePic  = SKSpriteNode(imageNamed: "ProfilePic")
    //let topWall = SKShapeNode(rect: CGRect(x: 0,y: 0,width: 600,height: 10))
    //let bubble = SKSpriteNode(shape)
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.gravity = CGVectorMake(0, 5)
        physicsWorld.contactDelegate = self
        
        for i in 0...5
        {
                // addBubble()
        }
        
        
        let bubbles = genreList.map(genreToBubble)
        
        let wallSize: CGSize = CGSize(width: self.size.width*2, height: 200)
        let wallRect: CGRect = CGRectMake(-self.size.width/2, -100, self.size.width, 200)
        topWall = SKShapeNode(rect: wallRect)
        topWall!.fillColor = wallColor
        topWall!.lineWidth = 0
        
        topWall!.physicsBody = SKPhysicsBody(rectangleOfSize: wallSize, center: CGPoint(x:0,y: 0))
        topWall!.physicsBody?.dynamic = true
        topWall!.physicsBody?.affectedByGravity = false
        topWall!.physicsBody?.collisionBitMask = PhysicsCategory.Bubble
        topWall!.physicsBody?.mass = 1e12
        topWall!.physicsBody?.allowsRotation = false
        
        topWall!.position = CGPoint(x: size.width/2, y: 650)
        
        profilePic.size = CGSize(width: 100, height: 100)
        profilePic.position = CGPoint(x: size.width/2, y: 570)
        
    
        addChild(topWall!)
        
        for b in bubbles {
            addChild(b!)
        }
        
        addChild(profilePic)
        
        /*
        let newBubble = Bubble(label: "Jazz", radius: 50)!
        addChild(newBubble)
        newBubble.position = CGPoint(x: 50, y: 50)
        
        newBubble.toggle()
        
        let newBubble2 = Bubble(label: "Rock", radius: 50)!
        addChild(newBubble2)
        newBubble2.position = CGPoint(x: 100, y: 50)
        */
        
        let physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        self.physicsBody = physicsBody
        //addChild(physicsBody)
        
        /**
        let wallSize: CGSize = CGSize(width: 10, height: 600)
        let wallRect: CGRect = CGRect(x: 320, y: 0, width: 10, height: 600)
        
        // bubble.physicsBody?.collisionBitMask
        
        
        topWall.position = CGPoint(x: 0, y: 600)
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 600,height: 10))
        topWall.physicsBody?.mass = 1e12
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.All
        
        let rightWall = SKShapeNode(rect: wallRect)
        rightWall.position = CGPoint(x: 320, y: 0)
        rightWall.physicsBody = SKPhysicsBody(rectangleOfSize: wallSize)
        rightWall.physicsBody?.mass = 1e12
        rightWall.physicsBody?.affectedByGravity = false
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.All
        
        addChild(rightWall)
        addChild(topWall)
        
        **/
        
        backgroundColor = self.bgColor
   
       
    }
    
    func shinkBar()
    {
        let moveNodeUp : SKAction = SKAction.moveBy( CGVector(dx: 0, dy: 100), duration: 0.2)
        //moveNodeUp.timingMode = .EaseIn
        
        let moveNodeDown : SKAction = SKAction.moveBy( CGVector(dx: 0, dy: -100), duration: 0.4)
        //moveNodeUp.timingMode = .EaseIn
        
        if (!toggled) {
            topWall!.runAction(moveNodeUp)
        } else {
            topWall!.runAction(moveNodeDown)
        }
        
        toggled = !toggled
        
        
    }
    
    func addBubble()
    {
        var randomNumber : Int = Int(rand()) % 10
        let xPosition : CGFloat = CGFloat(randomNumber)*15.0 + 50.0
        let yPosition : CGFloat = CGFloat(randomNumber)*55.0
        
        let radius = 40.0+CGFloat(randomNumber)*5.0
        let bubble = Bubble(label: "Jazz", radius: 200)!
        
        //bubble.color = unselectedColor
        //bubble.fillColor = unselectedColor
        //bubble.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        bubble.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        //bubble.physicsBody?.dynamic = true
        bubble.physicsBody?.collisionBitMask = PhysicsCategory.All
        bubble.physicsBody?.allowsRotation = false
        
        bubble.position = CGPoint(x: xPosition, y: yPosition)
        
        let label = SKLabelNode(text: "Jazz")
        label.fontSize = 24
        label.fontName = "Open Sans Semi Bold"
        bubble.addChild(label)
        
        addChild(bubble)
        bubbles.append(bubble)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        println("Hello")
    }
    
    
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        
        let touchLocation = touch.locationInNode(self)
        
        shinkBar()
        
        for bubble in bubbles
        {
            if (bubble.shape.containsPoint(touchLocation))
            {
                println("Hit tests")
                
                bubble.toggle()
                
                //bubble.fillColor = unselectedColor
                
            }
        }
        
        
        // println (touch)
    }
    
}
