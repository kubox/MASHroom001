//
//  SecondViewController.swift
//  KinokoKinoko
//
//  Created by kuboxITC on 2015/12/21.
//  Copyright © 2015年 kuboxITC. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectView.frame = self.view.bounds
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
        
        BackButton.addTarget(self, action: "backToMain:", forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func backToMain(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}