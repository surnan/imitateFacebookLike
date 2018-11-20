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
        containerView.backgroundColor = UIColor.white
 
        let iconHeight: CGFloat = 38
        let padding: CGFloat = 6
        
        
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "angry") ]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            imageView.isUserInteractionEnabled = true  //needed for hit-testing
            return imageView
        })
        
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = padding
    
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding) //A
        stackView.isLayoutMarginsRelativeArrangement = true  //A - both these lines needed to make outside border
        
        let iconCount =  CGFloat(stackView.arrangedSubviews.count)
        let width =  iconCount * iconHeight  + (iconCount + 1) * padding
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.addSubview(stackView)
        containerView.layer.cornerRadius = containerView.frame.height / 2 //<-- Round the left/ride edges of white rectangle
        
        //SHADOW
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4) //move shadow to bottom (default = top) //0 = centered & 4 = down 4 pixels
        
        stackView.frame = containerView.frame
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

        if gesture.state == .began {
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
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconsContainerView.alpha = 0
            }) { (_) in
                self.iconsContainerView.removeFromSuperview()
            }
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    @objc func handleGestureChanged(gesture: UILongPressGestureRecognizer){
        let pressedLocation = gesture.location(in: self.iconsContainerView) //pressedLocation (x,y) relative to containerView NOT self.view()
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        let hitTestView = iconsContainerView.hitTest( fixedYLocation, with: nil)  //hitTest goes deepest view at that location.  For us the facial icons
        if hitTestView is UIImageView { //Testing for imageView just in case hitTest returns stackView or containerView
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first  //we know this is true because we have insider knowledge of the structure
                stackView?.subviews.forEach{$0.transform = .identity}
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)  //x stays same but elevate height of what got hit by 50 pixels
            })
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

