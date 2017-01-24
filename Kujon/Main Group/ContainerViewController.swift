//
//  ContainerViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

//

//

import UIKit
import QuartzCore


enum SlideOutState {
    case collapsed
    case leftPanelExpanded
}

class ContainerViewController: UIViewController, LeftMenuTableViewControllerDelegate {
    var centerNavigationController: UINavigationController!
    var loadedToUsos = false
    var currentState: SlideOutState = .collapsed {
        didSet {
            let shouldShowShadow = currentState != .collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }

    var leftViewController: LeftMenuTableViewController?

    let centerPanelExpandedOffset: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.kujonBlueColor()
        UIApplication.shared.statusBarStyle = .lightContent

        let centerViewController = initialController()
        (centerViewController as! NavigationDelegate).setNavigationProtocol(self)
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        centerNavigationController.navigationBar.barTintColor = UIColor.kujonBlueColor()
        centerNavigationController.navigationBar.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        centerNavigationController.navigationBar.titleTextAttributes = titleDict as? [String:AnyObject]


        centerNavigationController.navigationBar.isTranslucent = false
        centerNavigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        if(loadedToUsos){
            loadedToUsos = false
            self.centerNavigationController.pushViewController(IntroScreenViewController(nibName: "IntroScreenViewController", bundle:  Bundle.main), animated: true)
        }
    }

    private func initialController() -> UIViewController {
        if UserDataHolder.sharedInstance.isNotificationPending {
            return MessagesTableViewController()
        }
        return UserTableViewController()
    }

    func selectedMenuItem(_ menuController: LeftMenuTableViewController, menuItem: MenuItemWithController, withDelegate: Bool) {

        if let cont = (centerNavigationController.visibleViewController as? NavigationDelegate) {
            if (cont.isSecond()) {
                self.centerNavigationController.viewControllers.removeLast()
            }
        }

        if let controller = menuItem.returnViewControllerFunction()() {
            self.toggleLeftPanel()
            if (withDelegate) {
                (controller as? NavigationDelegate)?.setNavigationProtocol(self)
                self.centerNavigationController.viewControllers.removeLast()
            }
            self.centerNavigationController.pushViewController(controller, animated: true)
        }
    }


}

extension ContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer

    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        if (currentState == .collapsed && !gestureIsDraggingFromLeftToRight) {
            addLeftPanelViewController()
            return
        }
        switch (recognizer.state) {
        case .began:
            if (currentState == .collapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                }
                showShadowForCenterViewController(true)
            }
        case .changed:
            if( self.centerNavigationController.view.frame.origin.x + recognizer.translation(in: view).x > 0){
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            if (leftViewController != nil) {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(hasMovedGreaterThanHalfway)
            }
        default:
            break
        }

    }

}

extension ContainerViewController: NavigationMenuProtocol {

    func collapseSidePanel() {
        switch (currentState) {
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }

    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)

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

    func addChildSidePanelController(_ leftMenuController: LeftMenuTableViewController) {
        leftMenuController.delegate = self

        view.insertSubview(leftMenuController.view, at: 0)

        addChildViewController(leftMenuController)
        leftMenuController.didMove(toParentViewController: self)
    }


    func animateLeftPanel(_ shouldExpand: Bool) {
        guard let centerNavigationController = centerNavigationController else {
            return
        }
        if (shouldExpand) {
            currentState = .leftPanelExpanded
            if (centerNavigationController.view.frame.width - centerPanelExpandedOffset >= 0) {
                animateCenterPanelXPosition(centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            }
        } else {
            animateCenterPanelXPosition(0) { [weak self]
                _ in
                self?.currentState = .collapsed
                self?.leftViewController?.view?.removeFromSuperview()
                self?.leftViewController = nil;
            }
        }
    }

    func animateCenterPanelXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { [weak self] in
            self?.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }


    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }

}
