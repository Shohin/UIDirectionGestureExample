//
//  ViewController.swift
//  UIDirectionGestureExample
//
//  Created by User on 19.12.15.
//  Copyright © 2015 shohin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let directionGesture = UIDirectionGesture(directionState: UIDirectionGestureState.All) { (gesture: UIDirectionGesture, state) -> (Void) in
            let view = gesture.view!
            let translation = gesture.lastTranslation
            view.center = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
        }
        
        let gestureView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        gestureView.center = self.view.center
        gestureView.frame = self.view.bounds
        gestureView.backgroundColor = UIColor.redColor()
        gestureView.userInteractionEnabled = true
        gestureView.addGestureRecognizer(directionGesture)
        self.view.addSubview(gestureView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

