//
//  IntroScreenVC.swift
//  emSigner
//
//  Created by Mallikarjun on 14/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class IntroScreenVC: UIViewController,ATCWalkthroughViewControllerDelegate {

    let walkthroughs = [
      ATCWalkthroughModel(title: "Approve all documents using Electronic & Digital Signatures from Anywhere, Anytime.", subtitle: "", icon: "intro1-img"),
      ATCWalkthroughModel(title: "Send documents from your Camera, Files, Box for Signing by Multiple Parties.", subtitle: "", icon: "intro2-img"),
    ]
    
    override func viewDidLoad() {
      super.viewDidLoad()
      let walkthroughVC = self.walkthroughVC()
      walkthroughVC.delegate = self
      self.addChildViewControllerWithView(walkthroughVC)
    }
    
    func walkthroughViewControllerDidFinishFlow(_ vc: ATCWalkthroughViewController) {
      
      /*UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
        vc.view.removeFromSuperview()
        let viewControllerToBePresented = UIViewController()
        self.view.addSubview(viewControllerToBePresented.view)
      }, completion: nil)*/
      
      //This code is not for animation
      UIView.transition(with: self.view, duration: 0, options: .transitionFlipFromLeft, animations: {
        vc.view.removeFromSuperview()
         
          //var window: UIWindow?
          let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          let homeVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
          self.view.window!.rootViewController = homeVC;
          
      }, completion: nil)
    }
    
    fileprivate func walkthroughVC() -> ATCWalkthroughViewController {
      let viewControllers = walkthroughs.map { ATCClassicWalkthroughViewController(model: $0, nibName: "ATCClassicWalkthroughViewController", bundle: nil) }
      return ATCWalkthroughViewController(nibName: "ATCWalkthroughViewController",
                                          bundle: nil,
                                          viewControllers: viewControllers)
    }

}
