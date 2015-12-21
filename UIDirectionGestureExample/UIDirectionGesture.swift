//
//  UIDirectionGesture.swift
//  UIDirectionGestureExample
//
//  Created by User on 19.12.15.
//  Copyright © 2015 shohin. All rights reserved.
//

import UIKit

public struct UIDirectionGestureState: OptionSetType {
    private enum State: Int, CustomStringConvertible {
        case None = 0, Left = 1, Right = 2, Up = 4, Down = 8
        var description : String {
            var shift = 0
            while (rawValue >> shift != 1){ shift++ }
            return ["Left","Right","Up","Down"][shift]
        }
    }
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    private init(_ state: State) {
        self.rawValue = state.rawValue
    }
    static let None: UIDirectionGestureState = UIDirectionGestureState(State.None)
    static let Up: UIDirectionGestureState = UIDirectionGestureState(State.Up)
    static let Down: UIDirectionGestureState = UIDirectionGestureState(State.Down)
    static let Left: UIDirectionGestureState = UIDirectionGestureState(State.Left)
    static let Right: UIDirectionGestureState = UIDirectionGestureState(State.Right)
    static let LeftRight: UIDirectionGestureState = [.Left, .Right]
    static let LeftUp: UIDirectionGestureState = [.Left, .Up]
    static let LeftDown: UIDirectionGestureState = [.Left, .Down]
    static let RightUp: UIDirectionGestureState = [.Right, .Up]
    static let RightDown: UIDirectionGestureState = [.Right, .Down]
    static let UpDown: UIDirectionGestureState = [.Up, .Down]
    static let All: UIDirectionGestureState = [.Left, .Right, .Up, .Down]
}

public class UIDirectionGesture: UIPanGestureRecognizer {
    typealias closure = ((gesture: UIDirectionGesture, state: UIGestureRecognizerState) -> (Void))
    
    public var directionState: UIDirectionGestureState = UIDirectionGestureState.None
    
    var beginPosition: CGPoint = CGPoint.zero
    
    var lastTranslation: CGPoint = CGPoint.zero
    
    var action: closure?
    
    private let positiveMax = CGFloat(50)
    private let negativeMax = CGFloat(-50)
    
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        NSException(name: "Initialize", reason: "cannot call this mehtod", userInfo: nil).raise()
    }
    
    init(directionState: UIDirectionGestureState, action: closure? = nil) {
        super.init(target: nil, action: nil)
        self.directionState = directionState
        self.action = action
        self.addTarget(self, action: "gesture:")
    }
    
    func gesture(sender: UIPanGestureRecognizer) {
        let view = sender.view
        let translation = sender.translationInView(view)
        let location = sender.locationInView(sender.view)
        let velocity = sender.velocityInView(sender.view)
        
        print("translation: \(translation)")
        print("location: \(location)")
        print("velocity: \(velocity)")
        
        /////
        func gestureAct() {
            self.action?(gesture: self, state: sender.state)
        }
        /////
        func checkRight() -> Bool {
            return translation.x > 0 && translation.y < positiveMax && translation.y > negativeMax
        }
        
        func checkLeft() -> Bool {
            return translation.x < 0 && translation.y < positiveMax && translation.y > negativeMax
        }
        
        func checkUp() -> Bool {
            return translation.y > 0 && translation.x < positiveMax && translation.x > negativeMax
        }
        
        func checkDown() -> Bool {
            return translation.y < 0 && translation.x < positiveMax && translation.x > negativeMax
        }
        
        /////
        func rightDirection() {
            if checkRight() {
                gestureAct()
            }
        }
        
        func leftDirection() {
            if checkLeft() {
                gestureAct()
            }
        }
        
        func upDirection() {
            if checkUp() {
                gestureAct()
            }
        }
        
        func downDirection() {
            if checkDown() {
                gestureAct()
            }
        }
        
        func leftRightDirection() {
            if checkLeft() {
                gestureAct()
            } else if checkRight() {
                gestureAct()
            }
        }
        
        func leftUpDirection() {
            if checkLeft() {
                gestureAct()
            } else if checkUp() {
                gestureAct()
            }
        }
        
        func leftDownDirection() {
            if checkLeft() {
                gestureAct()
            } else if checkDown() {
                gestureAct()
            }
        }
        
        func rightUpDirection() {
            if checkRight() {
                gestureAct()
            } else if checkUp() {
                gestureAct()
            }
        }
        
        func rightDownDirection() {
            if checkRight() {
                gestureAct()
            } else if checkDown() {
                gestureAct()
            }
        }
        
        func upDownDirection() {
            if checkUp() {
                gestureAct()
            } else if checkDown() {
                gestureAct()
            }
        }
        
        func allDirection() {
            if checkRight() {
                gestureAct()
            } else if checkLeft() {
                gestureAct()
            } else if checkUp() {
                gestureAct()
            } else if checkDown() {
                gestureAct()
            }
        }
        
        ////////
        switch sender.state {
        case .Began:
            self.beginPosition = view!.center
        case .Changed:
            self.lastTranslation = translation
        case .Ended:
            print("last transition: \(self.lastTranslation)")
            switch self.directionState {
            case UIDirectionGestureState.Right:
                rightDirection()
            case UIDirectionGestureState.Left:
                leftDirection()
            case UIDirectionGestureState.Down:
                downDirection()
            case UIDirectionGestureState.Up:
                upDirection()
            case UIDirectionGestureState.LeftRight:
                leftRightDirection()
            case UIDirectionGestureState.LeftUp:
                leftUpDirection()
            case UIDirectionGestureState.LeftDown:
                leftDownDirection()
            case UIDirectionGestureState.RightUp:
                rightUpDirection()
            case UIDirectionGestureState.RightDown:
                rightDownDirection()
            case UIDirectionGestureState.UpDown:
                upDownDirection()
            case UIDirectionGestureState.All:
                allDirection()
            default:
                break
            }
            //        case .Cancelled:
            //            break
            //        case .Failed:
            //            break
            //        case .Possible:
            //            break
        default:
            break
        }
        self.lastTranslation = translation
    }
}