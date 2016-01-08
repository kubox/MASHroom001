//
//  ViewController.swift
//  KinokoKinoko
//
//  Created by kuboxITC on 2015/12/09.
//  Copyright © 2015年 kuboxITC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ConfigViewDelegate {
    
    var seManager    = SoundAndEffectManager()
    var animManager  = AnimationManager()
    var eventManager = GameEventManager()
    
    var gameActive    = false
    var gameState     = [Int](count: 9, repeatedValue: 0)
    var gameTimelimit = 200
    var gameStageLevel = 1
    
    var timer: NSTimer = NSTimer()
    var gameTimeCount  = 0
    
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var gameBordImage: UIImageView!
    @IBOutlet weak var kinokoButton: UIButton!
    
    
    //キノコをタップ
    @IBAction func kinokobuttonPressed(sender: UIButton) {
        
        animManager.sender = sender
        animManager.target = view

        // 効果音のデフォルト
        var sePlayer = seManager.soundEffectsPlayer("win2_2")
        
        let image = UIImage(named: "kino_ground.png")!
        
        let targetTag: Int = sender.tag - 100
        
        if gameActive == true {
            
            // 通常イベント
            if gameState[targetTag] == 0 {
            
                // 仮サウンド もっとレスポンス良く。
                sePlayer.play()
                
                // 仮アニメ
                animManager.setSelectedAnimation("mini")
                
                // スコア表示更新 取る都度換算
                eventManager.setGameScoreLabel(infoScoreLabel, magnification: 50)
                
                // アイテム取得済み 図柄差し替え
                sender.setImage(image, forState: UIControlState.Normal)
                
                // イベント終了
                gameState[targetTag] = 1

            // イベント系  //値が2以上なら発生 毒の種類 2-9
            } else if gameState[targetTag] > 1 {
                
                // イベントごとの 音声ファイル名 アニメーション名 を取得
                
                // 仮SE
                sePlayer = seManager.soundEffectsPlayer("pdw4")
                sePlayer.play()
                
                // 仮アニメ
                animManager.setSelectedAnimation("big")

            }

// タップしてしまった毒キノコはイベント終了Ver
//gameState[targetTag] = 1

        }
        
        // 全アイテムを取得
        if gameState.contains(0) == false && gameActive == true {
            
            // イベント分のスコアを達成ボーナスとして 表示更新 毒キノコ数がスコアVer
            let scorePoint: Int = eventManager.calcCountGameScore(gameState) * 100
            eventManager.setGameScoreLabel(infoScoreLabel, magnification: scorePoint)
            
            gameStageLevel++
            
            timer.invalidate()
            
            gameActive = false
            
            // リポップ時の効果音
            sePlayer = seManager.soundEffectsPlayer("pdw3")
            sePlayer.play()
            
            // 停止 ゲームクリア
            /*
            eventManager.setMessageFadeinLabels(2, label: fedeInLabel, button: playAgainButton)
            animManager.animateFadeinLabel(false, label: fedeInLabel, button: playAgainButton)
            */
            
// 余りタイムで制限時間を延長Ver
//gameTimelimit = gameTimelimit + gameTimeCount
            
            setGameActive()
            
        }
        
    }
    
    
    // 制限時間のカウントダウン表記
    @IBOutlet weak var timeSecondLabel: UILabel!
    @IBOutlet weak var timeFractionLabel: UILabel!

    
    //
    @IBOutlet weak var infoScoreLabel: UILabel!
    
    
    //
    @IBOutlet weak var infoIconImage: UIImageView!

    
    // ゲーム稼働ボタン
    @IBOutlet weak var fedeInLabel: UILabel!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBAction func playAgainPressed(sender: AnyObject) {
        
        // メッセージラベルを非表示
        animManager.animateFadeinLabel(true, label: fedeInLabel, button: playAgainButton, config: playAgainButton)
        
        // ゲーム進行と設置物の初期化
        initGameBord()
        
        // ゲーム稼働
        gameActive = true
        
        // カウントダウン開始
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("countDownTimer"), userInfo: nil, repeats: true)
        
    }
    
    
    // 設定画面 モーダル 呼び出し
    @IBOutlet weak var configureButton: UIButton!
    
    @IBAction func setConfigure(sender: AnyObject) {
        
        let configview:ConfigViewController = self.storyboard!.instantiateViewControllerWithIdentifier("config") as! ConfigViewController
        
        // 透過
        configview.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        // モーダルウィンドウ
        self.presentViewController(configview as UIViewController, animated: true, completion:nil)

    }



    
    override func viewDidLoad() {
        super.viewDidLoad()

        // デバイス向け調整
        //let currentDevice: String = iOSDevice()
        
        // 保存設定の参照と設定
        getLoadNsuserdefault()
        
        // BGMの再生
        seManager.backgroundPlayer("icepuzzle")
        
        initGameBord()
        
        // メッセージのフェードイン
        eventManager.setMessageFadeinLabels(0, label: fedeInLabel, button: playAgainButton)

        // 稼働中は設定不可
        animManager.animateFadeinLabel(false, label: fedeInLabel, button: playAgainButton, config: configureButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /**
     ゲーム稼働
     */
    func setGameActive() {

        // 仮ゲームステージ 背景画像 変更
        let bgFilename: String = eventManager.getBackgroundFilenameAtGameLevel(gameStageLevel)
        backGroundImage.image = UIImage(named: bgFilename)
        
        // ゲーム進行と設置物の初期化
        initGameBord()

        // ゲーム稼働
        gameActive = true
        
        // カウントダウン開始
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("countDownTimer"), userInfo: nil, repeats: true)
        
    }
    
    
    /**
     ゲーム停止 タイムアップ時
     */
    func setTimeoutInGameover() {
        
        gameStageLevel = 1
        
        timer.invalidate()
        
        gameActive = false
        
        // 得点の内部リセット ゲームオーバー時は得点を見たいので表示更新しない
        eventManager.gameScore = 0
        
        // メッセージのフェードイン
        eventManager.setMessageFadeinLabels(1, label: fedeInLabel, button: playAgainButton)
        
        // 稼働中は設定変更は不可
        animManager.animateFadeinLabel(false, label: fedeInLabel, button: playAgainButton, config: configureButton)
    
    }
    
    
    /**
     配置の初期化
     - non
     */
    func initGameBord() {
        
        animManager.animateFadeinLabel(true, label: fedeInLabel, button: playAgainButton, config: configureButton)
        
        gameState     = [Int](count: 9, repeatedValue: 0)
        gameTimeCount = 0
        
        gameStageLevel = 1
        
        eventManager.setGameScoreLabel(infoScoreLabel, magnification: 0)
        
        timeSecondLabel.text   = String(gameTimelimit / 100) + "."
        timeFractionLabel.text = "00"
        
        generateItem()

    }

    
    /**
     制限タイムカウント 実時間ではない
     - non
     */
    func countDownTimer() {
        
        gameTimeCount++
        
        // ゲームカウント コンマ以下表示 非効率
        eventManager.setGameTimeFraction(timeFractionLabel, count: gameTimeCount)
        
        // 1ゲームカウント 秒 表示
        timeSecondLabel.text = String((gameTimelimit - gameTimeCount) / 100) + "."
        
        
        // 仮ゲームオーバー
        if gameTimeCount == gameTimelimit {

            setTimeoutInGameover()

        }

    }
    
    
    /**
     設置アイテムの格納
     - non
    */
    func generateItem() {
        
        var button: UIButton
        var itemImage: UIImage = UIImage(named: "kino_ground.png")!
        
        // 毒キノコの選定・配置
        gameState = eventManager.setStateGameIvent()
        
        for var i = 0; i < 9; i++ {
            
            // 値が2以上ならイベント発生 毒の種類 2-9
            if gameState[i] > 1 {
                
                // 毒ごとの画像を指定
                itemImage = UIImage(named: eventManager.getItemPathAtRandom("poison"))!
                
            // 通常アイテム
            } else {
            
                itemImage = UIImage(named: eventManager.getItemPathAtRandom("normal"))!
            }
            
            button = view.viewWithTag(Int(100 + i)) as! UIButton
            button.setImage(itemImage, forState: .Normal)
            
            // 設置アニメーション
            animManager.target = self.view
            animManager.sender = button
            
            // 画像 アニメーションリセット
            animManager.setSelectedAnimation("resetImageSize")
            animManager.setAnimationAtPopItem()
            
        }
        
    }
    
    
    /**
     使用しているiPhoneのモデルを推定する
     :returns: 解像度から推定される使用デバイス
     */
    func iOSDevice() -> String {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            // Retina確認 Phone6 Plusなら3?
            if 1.0 < UIScreen.mainScreen().scale {
                
                let size   = UIScreen.mainScreen().bounds.size
                let scale  = UIScreen.mainScreen().scale
                let result = CGSizeMake(size.width * scale, size.height * scale)
                
                switch result.height {
                    
                case 960:
                    return "iPhone4/4S"
                    
                case 1136:
                    return "iPhone5/5s/5c"
                    
                case 1334:
                    //fedeInLabel.font = UIFont.systemFontOfSize(32)
                    //timeSecondLabel.font = UIFont.systemFontOfSize(20)
                    //timeFractionLabel.font = UIFont.systemFontOfSize(30)
                    //playAgainButton.titleLabel?.font = UIFont.systemFontOfSize(18)
                    
                    //config
                    return "iPhone6"
                    
                case 2208:
                    return "iPhone6 Plus"
                    
                default:
                    return "unknown"
                }
                
            } else {
                return "iPhone3"
            }
            
        } else {
            
            // Retina確認
            if 1.0 < UIScreen.mainScreen().scale {
                return "iPad Retina"
                
            } else {
                return "iPad"
            }
            
        }
        
    }
    
    
    /**
     保存設定の読み込みと反映
     */
    func getLoadNsuserdefault() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        // Keyを指定して読み込み
        let easySetting: Bool = userDefaults.objectForKey("easySwitch") as! Bool
        let masterVolumeSetting: Float = userDefaults.objectForKey("masterVolume") as! Float

        configEasyMode(easySetting)
        configMasterVol(masterVolumeSetting)
        
    }
    
    
    /**
     制限時間の設定をゲーム反映
     */
    func configEasyMode(easySwitch: Bool){
        
        if easySwitch == true {
            
            gameTimelimit = 300
            
        } else {
            
            gameTimelimit = 200
            
        }

        // 表示更新
        timeSecondLabel.text = String(gameTimelimit / 100) + "."

    }
    
    
    /**
     音量の設定をゲーム反映
     */
    func configMasterVol(volumeLevel: Float) {
        
        // BGM
        seManager.bgmPlayer?.volume = volumeLevel
        
        // 効果音配列
        seManager.masterVolume = volumeLevel
        
    }

    
}

