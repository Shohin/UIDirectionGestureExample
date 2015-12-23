//
//  UIMoveGesture.swift
//  UIDirectionGestureExample
//
//  Created by User on 21.12.15.
//  Copyright © 2015 shohin. All rights reserved.
//

import UIKit

public class UIMoveGesture: UIDirectionGesture {
    
    private var movingView: UIView!
    
    public var minimumRequiredMoving: CGFloat = CGFloat(0)
    
    override init(directionState: UIDirectionGestureState, action: closure?) {
        super.init(directionState: directionState, action: action)
    }
    
    
    init(directionState: UIDirectionGestureState, movingView: UIView, action: closure?) {
        super.init(directionState: directionState, action: action)
        self.initialize(movingView)
    }
    
    private func initialize(movingView: UIView) {
        self.movingView = movingView
        self.minimumRequiredMoving = self.movingView.frame.width / 2
    }
    
    public func move() {
        self.movingView = self.movingView ?? self.view!
        self.minimumRequiredMoving = self.minimumRequiredMoving == 0 ? self.movingView.frame.width / 2 : self.minimumRequiredMoving
        let view = self.movingView
        let translation = self.translationInView(self.view)
        let location = self.locationInView(self.view)
        ////
        func newPositionByDirectionState() -> CGPoint {
            var newPos = view.center
            switch self.directionState {
            case UIDirectionGestureState.Right, UIDirectionGestureState.Left:
                newPos = CGPoint(x: newPos.x + translation.x, y: newPos.y)
            case UIDirectionGestureState.Down, UIDirectionGestureState.Up:
                newPos = CGPoint(x: newPos.x, y: newPos.y + translation.y)
            case UIDirectionGestureState.All:
                newPos = CGPoint(x: newPos.x + translation.x, y: newPos.y + translation.y)
            default:
                break
            }
            return newPos
        }
        ///////
        func moveView() {
            var pos = view.center
            pos = newPositionByDirectionState()//CGPoint(x: pos.x + translation.x, y: pos.y + translation.y)
            animate(pos)
            print("translation changed: \(translation)")
            self.setTranslation(CGPoint.zero, inView: view)
        }
        moveView()
    }
    
    ///////
    private func getAnimationVelocity(point: CGPoint) -> CGFloat  {
        let velocity = self.velocityInView(self.view)
        var duration = CGFloat(0)
        switch self.directionState {
        case UIDirectionGestureState.Right, UIDirectionGestureState.Left:
            duration = velocity.x / point.x
        case UIDirectionGestureState.Down, UIDirectionGestureState.Up:
            duration = velocity.y / point.y
        default:
            break
        }
        return fabs(duration)
    }
    ////////
    private func animate(position: CGPoint) {
        let duration = getAnimationVelocity(position)
        print("duration: \(duration)")
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.movingView.center = position
            }, completion: nil)
        //            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        //
        //                }, completion: nil)
    }
    
    ////////
    private func changeViewPosition() {
        animate(self.beginPosition)
    }
    
    private func changeRightPosition(w: CGFloat) {
        if self.view!.center.x - self.beginPosition.x < w {
            changeViewPosition()
        }
    }
    
    private func changeLeftPosition(w: CGFloat) {
        if self.beginPosition.x - self.view!.center.x < w {
            changeViewPosition()
        }
    }
    
    private func changeDownPosition(w: CGFloat) {
        if self.view!.center.y - self.beginPosition.y < w {
            changeViewPosition()
        }
    }
    
    private func changeUpPosition(w: CGFloat) {
        if self.beginPosition.y - self.view!.center.y < w {
            changeViewPosition()
        }
    }
    
    private func changeAllPosition(w: CGFloat) {
        if (self.previousTranslation.x > 0) && (self.previousTranslation.y == 0) {
            changeRightPosition(w)
        } else if (self.previousTranslation.x < 0) && (self.previousTranslation.y == 0) {
            changeLeftPosition(w)
        } else if (self.previousTranslation.x == 0) && (self.previousTranslation.y > 0) {
            changeDownPosition(w)
        } else if (self.previousTranslation.x == 0) && (self.previousTranslation.y < 0) {
            changeUpPosition(w)
        }
    }
    
    func changePosition() {
        let w = self.minimumRequiredMoving
        switch self.directionState {
        case UIDirectionGestureState.Right:
            changeRightPosition(w)
        case UIDirectionGestureState.Left:
            changeLeftPosition(w)
        case UIDirectionGestureState.Down:
            changeDownPosition(w)
        case UIDirectionGestureState.Up:
            changeUpPosition(w)
        case UIDirectionGestureState.All:
            changeAllPosition(w)
            self.lastTranslation = CGPoint.zero
        default:
            break
        }
    }
    
//    func gestureAction(sender: UIPanGestureRecognizer) {
//        let view = self.movingView ?? self.view!
//        let translation = sender.translationInView(view)
//        let location = sender.locationInView(sender.view)
//        let velocity = sender.velocityInView(sender.view)
//        
//        ///////
//        func getAnimationVelocity(point: CGPoint) -> CGFloat  {
//            var duration = CGFloat(0)
//            switch self.directionState {
//            case UIDirectionGestureState.Right, UIDirectionGestureState.Left:
//                duration = velocity.x / point.x
//            case UIDirectionGestureState.Down, UIDirectionGestureState.Up:
//                duration = velocity.y / point.y
//            default:
//                break
//            }
//            return fabs(duration)
//        }
//        ////////
//        func animate(position: CGPoint) {
//            let duration = getAnimationVelocity(position)
//            print("duration: \(duration)")
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                view.center = position
//                }, completion: nil)
//            //            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//            //
//            //                }, completion: nil)
//        }
//        ////
//        func newPositionByDirectionState() -> CGPoint {
//            var newPos = view.center
//            switch self.directionState {
//            case UIDirectionGestureState.Right, UIDirectionGestureState.Left:
//                newPos = CGPoint(x: newPos.x + translation.x, y: newPos.y)
//            case UIDirectionGestureState.Down, UIDirectionGestureState.Up:
//                newPos = CGPoint(x: newPos.x, y: newPos.y + translation.y)
//            case UIDirectionGestureState.All:
//                newPos = CGPoint(x: newPos.x + translation.x, y: newPos.y + translation.y)
//            default:
//                break
//            }
//            return newPos
//        }
//        ///////
//        func moveView() {
//            var pos = view.center
//            pos = newPositionByDirectionState()//CGPoint(x: pos.x + translation.x, y: pos.y + translation.y)
//            animate(pos)
//            print("translation changed: \(translation)")
//            sender.setTranslation(CGPoint.zero, inView: view)
//        }
//        
//        func checkRight() -> Bool {
//            return translation.x > 0
//        }
//        
//        func moveRight() {
//            if checkRight() {
//                moveView()
//            }
//        }
//        func moveLeft() {
//            if translation.x < 0 {
//                moveView()
//            }
//        }
//        
//        func moveDown() {
//            if translation.y > 0 {
//                moveView()
//            }
//        }
//        
//        func moveUp() {
//            if (translation.y < 0) {
//                moveView()
//            }
//        }
//        
//        func moveAll() {
//            moveRight()
//            moveLeft()
//            moveDown()
//            moveUp()
//        }
//        ////////
//        func changeViewPosition() {
//            animate(self.beginPosition)
//        }
//        
//        func changeRightPosition(w: CGFloat) {
//            if view.center.x - self.beginPosition.x < w {
//                changeViewPosition()
//            }
//        }
//        
//        func changeLeftPosition(w: CGFloat) {
//            if self.beginPosition.x - view.center.x < w {
//                changeViewPosition()
//            }
//        }
//        
//        func changeDownPosition(w: CGFloat) {
//            if view.center.y - self.beginPosition.y < w {
//                changeViewPosition()
//            }
//        }
//        
//        func changeUpPosition(w: CGFloat) {
//            if self.beginPosition.y - view.center.y < w {
//                changeViewPosition()
//            }
//        }
//        
//        func changeAllPosition(w: CGFloat) {
//            if (self.lastTranslation.x > 0) && (self.lastTranslation.y == 0) {
//                changeRightPosition(w)
//            } else if (self.lastTranslation.x < 0) && (self.lastTranslation.y == 0) {
//                changeLeftPosition(w)
//            } else if (self.lastTranslation.x == 0) && (self.lastTranslation.y > 0) {
//                changeDownPosition(w)
//            } else if (self.lastTranslation.x == 0) && (self.lastTranslation.y < 0) {
//                changeUpPosition(w)
//            }
//        }
//        ////////
//        switch sender.state {
//        case .Began:
//            self.beginPosition = view.center
//        case .Changed:
//            switch self.directionState {
//            case UIDirectionGestureState.Right:
//                moveRight()
//            case UIDirectionGestureState.Left:
//                moveLeft()
//            case UIDirectionGestureState.Down:
//                moveDown()
//            case UIDirectionGestureState.Up:
//                moveUp()
//            case UIDirectionGestureState.All:
//                moveAll()
//            default:
//                break
//            }
//            
//        case .Ended:
//            print("last transition: \(self.lastTranslation)")
//            let w = self.minimumRequiredMoving
//            switch self.directionState {
//            case UIDirectionGestureState.Right:
//                changeRightPosition(w)
//            case UIDirectionGestureState.Left:
//                changeLeftPosition(w)
//            case UIDirectionGestureState.Down:
//                changeDownPosition(w)
//            case UIDirectionGestureState.Up:
//                changeUpPosition(w)
//            case UIDirectionGestureState.All:
//                changeAllPosition(w)
//            default:
//                break
//            }
//            //        case .Cancelled:
//            //            break
//            //        case .Failed:
//            //            break
//            //        case .Possible:
//            //            break
//        default:
//            break
//        }
//        
//        self.action?(gesture: self, state: sender.state)
//        
//        //        print("location: \(location)")
//        //        print("translation: \(translation)")
//        //        print("velocity: \(velocity)")
//    }
}