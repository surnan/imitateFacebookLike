//
//  ViewController.swift
//  facebookLike
//
//  Created by admin on 11/18/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    
    let bgImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "water"))
        return imageView  //don't translates=False because we're using 'frame'
    }()
    
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgImageView)
        bgImageView.frame = view.frame
        
        
        setupLongPressGesture()
    }
    
    fileprivate func setupLongPressGesture(){
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer){
        //triggers twice.  Once when LongPress Starts & again once it ends.  Also triggers when x/y changes
        //you can also specify the number of fingers needed to trigger this & alter time period
//        print("Long Press Triggered")  <--- triggered lots of times without .began or .ended if you hold down and move mouse
        
        if gesture.state == .began {
//            print("Long gesture = start")
            view.addSubview(iconsContainerView)
            
            let pressedLocation = gesture.location(in: self.view)
            print(pressedLocation)

            
            iconsContainerView.alpha = 0
            let centeredX = (self.view.frame.width - self.iconsContainerView.frame.width) / 2  // calculates x-coordinate to the view is centered properly
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y )  //move it to specified (x,y) & maintain invisible
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.iconsContainerView.alpha = 1
                let centeredX = (self.view.frame.width - self.iconsContainerView.frame.width) / 2  // calculates x-coordinate to the view is centered properly
                self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)  //changes x & y-coordinate
            })
            
            
            
            
        } else if gesture.state == .ended {
            iconsContainerView.removeFromSuperview()
//            print("Long gesture = complete ")
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

