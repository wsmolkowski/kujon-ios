//
//  ContainerViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore


enum SlideOutState {
    case Collapsed
    case LeftPanelExpanded
}

class ContainerViewController: UIViewController,LeftMenuTableViewControllerDelegate {

    var centerNavigationController: UINavigationController!
    let containerDictionary: [String:()->UIViewController]=["user":{return UserViewController()},"schedule":{return SchedulerViewController()}]
    var centerViewController: UserViewController = UserViewController()
    
    var currentState: SlideOutState = .Collapsed {
        didSet {
            let shouldShowShadow = currentState != .Collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftViewController: LeftMenuTableViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centerViewController.setNavigationProtocol(self)

        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
       
    }


    func selectedUpperMenuItem(menuController: LeftMenuTableViewController, menuItem: MenuItemWithController) {
       if let controller = menuItem.returnViewControllerFunction()(){
           self.toggleLeftPanel()
           (controller as! NavigationDelegate).setNavigationProtocol(self)
           self.centerNavigationController.pushViewController(controller,animated: true)
       }
    }

    func selectedLowerMenuItem(menuController: LeftMenuTableViewController, menuItem: MenuItemWithController) {
    }


}



extension ContainerViewController: NavigationMenuProtocol {
    
    
    func collapseSidePanel() {
        switch (currentState) {
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(notAlreadyExpanded)
    }
    
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = LeftMenuTableViewController()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(leftMenuController: LeftMenuTableViewController) {
        leftMenuController.delegate = self
        
        view.insertSubview(leftMenuController.view, atIndex: 0)
        
        addChildViewController(leftMenuController)
        leftMenuController.didMoveToParentViewController(self)
    }
    
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            if (CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset >= 0) {
                animateCenterPanelXPosition(CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            }
        } else {
            animateCenterPanelXPosition(0) {
                finished in
                self.currentState = .Collapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}

//extension ContainerViewController: UIGestureRecognizerDelegate {
//    // MARK: Gesture recognizer
//    
//    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
//        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
//        if (gestureIsDraggingFromLeftToRight) {
//            switch (recognizer.state) {
//            case .Began:
//                if (currentState == .Collapsed) {
//                    if (gestureIsDraggingFromLeftToRight) {
//                        addLeftPanelViewController()
//                    }
//                    
//                    showShadowForCenterViewController(true)
//                }
//            case .Changed:
//                
//                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
//                recognizer.setTranslation(CGPointZero, inView: view)
//                
//                
//            case .Ended:
//                if (leftViewController != nil) {
//                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
//                    let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
//                    animateLeftPanel(hasMovedGreaterThanHalfway)
//                }
//            default:
//                break
//                
//            }
//            
//        }else{
//            if(self.centerNavigationController.view.frame.minX>0){
//                switch (recognizer.state) {
//                case .Began:
//                    if (currentState == .Collapsed) {
//                        if (gestureIsDraggingFromLeftToRight) {
//                            addLeftPanelViewController()
//                        }
//                        
//                        showShadowForCenterViewController(true)
//                    }
//                case .Changed:
//                    
//                    recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
//                    recognizer.setTranslation(CGPointZero, inView: view)
//                    
//                    
//                case .Ended:
//                    if (leftViewController != nil) {
//                        // animate the side panel open or closed based on whether the view has moved more or less than halfway
//                        let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
//                        animateLeftPanel(hasMovedGreaterThanHalfway)
//                    }
//                default:
//                    break
//                    
//                }
//            }
//        }
//        
//        
//    }
//}

