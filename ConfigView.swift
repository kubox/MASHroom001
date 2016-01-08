//
//  ConfigView.swift
//  KinokoKinoko
//
//  Created by kuboxITC on 2015/12/21.
//  Copyright © 2015年 kuboxITC. All rights reserved.
//

import UIKit

@objc protocol ConfigViewDelegate {
    
    func configEasyMode(easySwitch: Bool)
    func configMasterVol(volumeLevel: Float)
    func getLoadNsuserdefault()
    
}

class ConfigViewController: UIViewController {
    
    
    var delegate: ConfigViewDelegate!
    
    // NSUserDefaults のインスタンス
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBOutlet weak var backButton: UIButton!
    
    
    //制限時間変更
    @IBOutlet weak var switchTimeLimit: UISwitch!

    @IBAction func configTimeLimit(sender: AnyObject) {
        
        //設定の保存
        userDefaults.setObject(switchTimeLimit.on, forKey: "easySwitch")
        userDefaults.synchronize()
        
        //反映
        self.delegate.configEasyMode(switchTimeLimit.on)

    }
    
    
    //マスターボリューム変更
    @IBOutlet weak var masterVolumeSlider: UISlider!
    
    @IBAction func configMasterVolume(sender: AnyObject) {
        
        //設定の保存
        userDefaults.setObject(masterVolumeSlider.value, forKey: "masterVolume")
        userDefaults.synchronize()
        
        //反映
        self.delegate.configMasterVol(masterVolumeSlider.value)
        
    }
    
    //ゲーム画面へ
    @IBAction func backToMain(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景透過
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        visualEffectView.frame = self.view.bounds
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)

        
        // rootViewからdelegate を設定する
        let rootView  = UIApplication.sharedApplication().keyWindow!.rootViewController as! ViewController
        self.delegate = rootView
        
        //保存設定の読み込みと値セット
        let easySetting: Bool = userDefaults.objectForKey("easySwitch") as! Bool
        let masterVolumeSetting: Float = userDefaults.objectForKey("masterVolume") as! Float
        
        switchTimeLimit.on = easySetting
        masterVolumeSlider.value = masterVolumeSetting
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
