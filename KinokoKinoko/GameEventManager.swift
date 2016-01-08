//
//  GameEventManager.swift
//  KinokoKinoko
//
//  Created by kuboxITC on 2015/12/16.
//  Copyright © 2015年 kuboxITC. All rights reserved.
//

import UIKit

class GameEventManager: UIViewController {
    
    
    var gameScore: Int = 0
    
    
    //仮 変更 背景画像
    func getBackgroundFilenameAtGameLevel(gamelevel: Int) -> String {
        
        let name: Int = Int(arc4random_uniform(3) + 2)
        
        return "bg\(name).jpg"
    }
    
    //ゲームスコア イベント数から換算
    func calcCountGameScore(gamestate: Array<Int>) -> Int {
        
        let ivents: [Int] = gamestate.filter{ $0 > 1 }
        
        let point: Int = ivents.count
        
        return point
    }
    
    /**
     イベント別 ファイル名 指定
     */
     //アニメ指定
     //効果音指定
    
    
    
    /**
     イベント配置
     - parameter Array<Int>: ゲームステータス値配列
     */
    func setStateGameIvent() -> Array<Int> {
        
        //全生成マス数 = X軸数 * Y軸数
        let gameBord: Int = 3 * 3

        //ステータスを初期化
        var gameStateStac = [Int](count: gameBord, repeatedValue: 0)
        
        //設置数 全マス数より-2 最低１つ
        let setIivent = Int(arc4random_uniform(7) + 1)
        
        //イベントID 0&1 は予約済み
        //let iventNumber = Int(arc4random_uniform(7) + 2)
        
        for var i = 0; i <= setIivent; i++ {
            
            //設置先 重複はイベント無しと判定
            let stacNumber = Int(arc4random_uniform(8))
            
            if gameStateStac[stacNumber] == 0 {
                
                //ステージごとにイベントが単一の場合
                //gameStateStac[stacNumber] = iventNumber
                
                //イベント種類が入り乱れる場合
                gameStateStac[stacNumber] = Int(arc4random_uniform(7) + 2)
                
            }
            
        }
        
        return gameStateStac
    }
    

    /**
     イベント別 ファイル名 ランダム取得
     - parameter eventType: reset/normal/poison/rare
     */
    func getItemPathAtRandom(eventType: String) -> String {
        
        //配列を返す
        //var item: Dictionary = ["number": 0, "filePath": ""]
        
        var name: String
        
        switch eventType {
            
        case "normal":
            name = String(arc4random_uniform(4) + 10)
            
        case "poison":
            name = String(arc4random_uniform(3) + 100)
            
            
        default:
            name = "_ground"
        }
        
        //アイテム種別を返さないver
        return "kino\(name).png"
        
    }
    
    
    /**
    ゲームタイム表示用 コンマ以下 もっとスマートに。
     - parameter label: UILabel
     - parameter count: Int
     */
    func setGameTimeFraction(label: UILabel, count: Int) {
        
        let timeFraction = 100 - (count % 100)
        
        //コンマ以下表示 非効率
        if 100 == timeFraction {
            label.text = "00"
            
        } else {
            label.text = NSString(format: "%02d", timeFraction) as String
            
        }
        
    }

    
    /**
     ゲーム得点 表示用ゼロ詰め
     - parameter label: UILabel
     - parameter scoreReset: Bool
     */
    func setGameScoreLabel(label: UILabel, magnification: Int) {
        
        gameScore = gameScore + magnification
        
        label.text = ((NSString(format: "%07d", gameScore)) as String)
        
    }
    
    
    /**
     フェードイン メッセージ割り当て
     - parameter textType: 0=start, 1=timeup, 2=win
     - parameter label: UILabel
     - parameter button: UIButton
     */
    func setMessageFadeinLabels(textType: Int, label: UILabel, button: UIButton) {
        
        switch textType {
            
        //開始時
        case 0:
            label.text = "Ready?"
            button.setTitle("Go", forState: .Normal)
            break
            
        //終了時
        case 1:
            label.text = "TIME UP!"
            button.setTitle("Try Again", forState: .Normal)
            break
            
        //継続時
        case 2:
            label.text = "You Win!"
            button.setTitle("Next Stage", forState: .Normal)
            break
            
            //
        default:
            label.text = ""
            button.setTitle("", forState: .Normal)
            break
        }
        
    }
    
}