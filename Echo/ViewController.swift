//
//  ViewController.swift
//  Echo
//
//  Created by Robert Dickerson on 7/10/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Physics related things
    var animator : UIDynamicAnimator?
    var gravity : UIGravityBehavior?
    var collision : UICollisionBehavior?
    
    // references to the storyboard
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var editDoneButton: UIButton!
    @IBOutlet weak var lowerToolbar: UIToolbar!
    @IBOutlet weak var toolbarLabel: UILabel!
    
    // dynamically generated views
    private var greenLeafView : UIView!
    
    // holds whether the toolbar is extended down or not
    private var toggled : Bool = true
    
    // holds state for placing the balls
    private var ballPlacementX : CGFloat = 0.0
    private var ballPlacementY : CGFloat = 300.0
    
    // animation directives
    
    func fadeUserNameLabel(delay : NSTimeInterval )
    {
        // the username
        UIView.animateWithDuration(0.2, animations: {
            self.usernameLabel.alpha = 0.0
        })
    }
    
    func fadeToolbarLabel( enter: Bool )
    {
        let duration : NSTimeInterval = 0.4
        let delay : NSTimeInterval = enter ? 0.0 : 1.0
        let alpha : CGFloat = enter ? 0.0 : 1.0
        
        UIView.animateWithDuration(duration,
            delay: delay, options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
            
            self.toolbarLabel.alpha = alpha
            
            
            }, completion: {
                
                (finished: Bool) -> Void in
                
               
                
        })
    }
    
    func animateToolbar(enter: Bool)
    {
        let duration : NSTimeInterval = 0.5
        let delay : NSTimeInterval = enter ? 0.2 : 0.5
        let yPosition : CGFloat = enter ? -50 : -200
        
        UIView.animateWithDuration(duration,
            delay: delay,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
            
            self.topBar.frame = CGRect(x: 0,
                y: yPosition,
                width: self.topBar.frame.width,
                height: self.topBar.frame.height)
            
            }, completion: {
                
                (finished: Bool) -> Void in
                
        })
    }
    
    func animateGreenLeaf(enter: Bool)
    {
        
        let duration : NSTimeInterval = 0.5
        let delay : NSTimeInterval = enter ? 0.4 : 0.2
        
        let yPosition : CGFloat = enter ? 0.0 : -200
        
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.greenLeafView.frame = CGRect(x: 0, y: yPosition, width: self.greenLeafView.frame.width, height: self.self.greenLeafView.frame.height)
            
            }, completion: {
                
                (finished: Bool) -> Void in
                
        })
    }
    
    func animateProfilePic(enter: Bool)
    {
        let duration : NSTimeInterval = 0.5
        let yPosition : CGFloat = enter ? 60 : -200
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.profilePicView.frame = CGRect(x: self.profilePicView.frame.minX,
                y: yPosition, width: self.profilePicView.frame.width, height: self.profilePicView.frame.height)
        })
    }
    
    @IBAction func handleSwitchView(sender: AnyObject) {
        
        if toggled {
        
            
            // retracted
            
            animateToolbar(false)
            fadeToolbarLabel(false)
            animateGreenLeaf(false)
            animateProfilePic(false)
    
        } else {
           
            animateProfilePic(true)
            animateGreenLeaf(true)
            fadeToolbarLabel(true)
            animateToolbar(true)
            
        }
        
        toggled = !toggled
        
        
    }
    
    var genres : [GenreView]?
    
    let maxBubbles = 18
    var numBubbles = 0
    
    
    
    
    @IBAction func start(sender: AnyObject) {
        println("Hello!")
        
        if let b = sender.view as? GenreView
        {
            b.toggle()
            println("Changing color")
        }
    }
    
    /**
    * Creates a green vector arc
    */
    func createGreenLeaf()
    {
        let p = CGPoint(x: view.frame.width/2, y: 0)
        let radius : CGFloat = 500.0
        let startAngle : CGFloat = 0
        let endAngle : CGFloat = CGFloat(M_PI)
        let aPath = UIBezierPath(arcCenter: p, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        let greenColor = UIColor(red: 80/256, green: 219/256, blue: 158/256, alpha: 1.0)
        shapeLayer.fillColor = greenColor.CGColor
        
        shapeLayer.position = CGPoint(x: 0, y: -370)
        
        shapeLayer.path = aPath.CGPath
        
        
        self.greenLeafView.layer.addSublayer(shapeLayer)
    }
    
    func addBall(x: CGFloat, y: CGFloat, radius: CGFloat)
    {
        let rect = CGRectMake(x, y, 50, 50)
        
        let ball = GenreView(frame: rect)
        super.view.addSubview(ball)
        
        let itemBehavior = UIDynamicItemBehavior(items: [ball])
        itemBehavior.resistance = 300.0
        itemBehavior.allowsRotation = false
        itemBehavior.elasticity = 0.3
        
        collision?.addItem(ball)
        gravity?.addItem(ball)
        
        // set a touch event handler on the new ball
        let aSelector : Selector = "start:"
        let touchOnView = UITapGestureRecognizer (target: self, action: aSelector)
        
        
        ball.addGestureRecognizer(touchOnView)
        
    }
    
    func update()
    {
        
        let radius : CGFloat = 100
        if numBubbles < maxBubbles
        {
            //let xPosition : CGFloat = ballPlacementX
            //let yPosition : CGFloat = ballPlacementY
            addBall( ballPlacementX, y: ballPlacementY, radius: radius)
            
            ballPlacementX  += radius
            
            // check for new line
            if ballPlacementX > self.view.frame.width
            {
                ballPlacementY += radius
                ballPlacementX = 0.0
            }
            
            numBubbles++
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greenLeafView = UIView()
        
        // sets up the timer that will add the balls
        var timer = NSTimer.scheduledTimerWithTimeInterval( 0.1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        //animator = UIDynamicAnimator(referenceView: self.view)
        //gravity = UIGravityBehavior(items: [square])
        //gravity = UIGravityBehavior()
        //gravity?.magnitude = -0.1
        //gravity?.gravityDirection = CGVectorMake(0, 0.8)
        
        
        //collision = UICollisionBehavior(items: [square])
        collision = UICollisionBehavior()
        collision?.translatesReferenceBoundsIntoBoundary = true
        
       
        createGreenLeaf()
        
        
        self.view.addSubview(self.greenLeafView)
        
        self.usernameLabel.text = "Elizabeth Grove"
        
        self.usernameLabel.frame = CGRectMake(100, 200,
                usernameLabel.frame.size.width, usernameLabel.frame.size.height)
        
        self.usernameLabel.setNeedsLayout()
        
        self.view.bringSubviewToFront(self.usernameLabel)
        self.view.bringSubviewToFront(self.profilePicView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

