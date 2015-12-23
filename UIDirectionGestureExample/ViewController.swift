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
            switch state {
            case .Ended:
                let view = gesture.view!
                let translation = gesture.translation
                view.center = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
                gesture.setTranslation(CGPoint.zero, inView: view)
            default:
                break
            }
        }
        
        let gestureView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        gestureView.center = self.view.center
        gestureView.frame = self.view.bounds
        gestureView.backgroundColor = UIColor.redColor()
        gestureView.userInteractionEnabled = true
        gestureView.addGestureRecognizer(directionGesture)
        self.view.addSubview(gestureView)
        
        let movingGesture = UIMoveGesture(directionState: UIDirectionGestureState.All) { (gesture: UIDirectionGesture, state) -> (Void) in
            let moveGest = gesture as! UIMoveGesture
            switch state {
            case .Changed:
                moveGest.move()
            case .Ended:
                moveGest.changePosition()
            default:
                break
            }
            
        }
        
        let moveGestureView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 300))
        moveGestureView.backgroundColor = UIColor.blackColor()
        moveGestureView.center = self.view.center
        moveGestureView.userInteractionEnabled = true
        moveGestureView.addGestureRecognizer(movingGesture)
        self.view.addSubview(moveGestureView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

