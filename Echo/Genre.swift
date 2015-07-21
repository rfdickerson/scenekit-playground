//
//  Genre.swift
//  Echo
//
//  Created by Robert Dickerson on 7/10/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit

class GenreView : UIView  {
    
    var name : String
    var size : CGFloat
    var selected : Bool
    
    let selectedColor = UIColor(red: 13/256, green: 213/256, blue: 216/256, alpha: 1.0)
    let unselectedColor = UIColor(red: 13/256, green: 120/256, blue: 131/256, alpha: 1.0)
    
    override init(frame: CGRect)
    {
        name = "Jazz"
        size = 50.0
        selected = false
        
        super.init(frame: frame)
        self.setup("Default")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        name = "Jazz"
        size = 50.0
        selected = false
        
        super.init(coder: aDecoder)
        
        setup("Default")
        
    }
    
    func setup(text: String)
    {
        //let x: CGFloat = 50
        //let y: CGFloat = 50
        
        backgroundColor = self.unselectedColor
        
        //var randomNumber : Int = Int(rand()) % 10
        
        /*
        var size : CGFloat = 50
        if (randomNumber < 2)
        {
            size = 150
        }
        else if (randomNumber < 5)
        {
            size = 100
        }
        else
        {
            size = 75
        }
        */
        
        let s : CGFloat = 100.0
        
        let rect = CGRectMake(self.frame.minX, super.frame.minY, size, size)
        
        super.frame = rect
        
        self.layer.cornerRadius = size/2
        
        
        let label = UILabel(frame: CGRectMake(0,0,size,size))
        
        
        label.text = text
        
        
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        addSubview(label)

    }
    
    
    func toggle()
    {
        
        if !selected
        {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.backgroundColor = self.selectedColor
            
            }, completion: {
                (value: Bool) in
                
                self.selected = true
            })

        }
        
    else
    {
    
    UIView.animateWithDuration(0.2, animations: {
    
    self.backgroundColor = self.unselectedColor
    
    }, completion: {
    (value: Bool) in
        self.selected = false
    })
    
    }

    
    }

}
