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
        

        /* GOING GENERICS
//        let redView = UIView(); let blueView = UIView(); let yellowView = UIView(); let grayView = UIView()
//        redView.backgroundColor = UIColor.red; blueView.backgroundColor = UIColor.blue; yellowView.backgroundColor = UIColor.yellow; grayView.backgroundColor = UIColor.gray
//        let stackView = UIStackView()
//        [redView, blueView, yellowView, grayView].forEach{stackView.addArrangedSubview($0)}
        GOING GENERICS */
 
        let iconHeight: CGFloat = 38
        let padding: CGFloat = 6
        
        
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "angry") ]
        
//        let arrangedSubviews = [UIColor.red, .blue, .gray, .orange].map({ (currentColor) -> UIView in
//        let v = UIView()
//        v.backgroundColor = currentColor
//        v.layer.cornerRadius = iconHeight / 2
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            imageView.isUserInteractionEnabled = true  //needed for hit-testing
            return imageView
        })
        
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
//        stackView.frame = containerView.frame
        
     
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
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    @objc func handleGestureChanged(gesture: UILongPressGestureRecognizer){
        let pressedLocation = gesture.location(in: self.iconsContainerView) //pressedLocation (x,y) relative to containerView NOT self.view()
        print(pressedLocation)
        
        let hitTestView = iconsContainerView.hitTest( pressedLocation, with: nil)  //hitTest goes deepest view at that location.  For us the facial icons
        
        
        if hitTestView is UIImageView {
            hitTestView?.alpha = 0
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

