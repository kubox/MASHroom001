//
//  SoundAndEffectManager.swift
//  KinokoKinoko
//
//  Created by kuboxITC on 2015/12/16.
//  Copyright © 2015年 kuboxITC. All rights reserved.
//

import Foundation
import AVFoundation

class SoundAndEffectManager: NSObject, AVAudioPlayerDelegate {
    
    var bgmPlayer: AVAudioPlayer?
    
    var seArray:[AVAudioPlayer] = []
    
    var masterVolume: Float = 0.5
    
    
    /**
     BGM再生
     - parameter fileName: String
     */
    func backgroundPlayer(fileName: String) {
        
        let bgmFilePath = NSBundle.mainBundle().pathForResource(fileName, ofType: ".mp3")!
        
        do {
            try bgmPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: bgmFilePath))
            
//別途音量をノーマライズ
            bgmPlayer!.volume = masterVolume
            
            bgmPlayer!.numberOfLoops = -1
            bgmPlayer!.prepareToPlay()
            bgmPlayer!.play()
            
        } catch {
            print("Error func backgroundPlayer")
        } 
        
    }
    
    /**
     効果音セットのみ 再生後の配列解放は必ず
     - parameter fileName: mp3 Filename
     */
    func soundEffectsPlayer(fileName: String) -> AVAudioPlayer {
        
        var sePlayer: AVAudioPlayer = AVAudioPlayer()
        
        let seGetItem = NSBundle.mainBundle().pathForResource(fileName, ofType: ".mp3")!
        
        do {
            try sePlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: seGetItem))
            
            sePlayer.delegate = self
//別途音量をノーマライズ
            sePlayer.volume = masterVolume
            sePlayer.prepareToPlay()
            
            //音声を重ねることで再生レスポンスを遅らせない
            seArray.append(sePlayer)

        } catch {
            print("Error func soundEffectsPlayer")
        }
        
        return sePlayer
        
    }
    
    /**
     サウンド再生後に実行されるメソッド
     - parameter player: AVAudioPlayer
     - parameter successfully: Bool
     */
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        //再生が終わった変数のインデックスを調べる
        let i:Int = seArray.indexOf(player)!
        //上記で調べたインデックスの要素を削除する。
        seArray.removeAtIndex(i)
        
    }
    
}