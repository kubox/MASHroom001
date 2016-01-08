//
//  AnimationManeger.swift
//  KinokoKinoko
//
//  Created by kuboxITC on 2015/12/16.
//  Copyright © 2015年 kuboxITC. All rights reserved.
//

import UIKit

class AnimationManager: UIViewController {
    
    var sender: UIButton?
    
    var target: UIView?
    
    
    /**
     フェードイン 動作
     - parameter hidden: Bool
     */
    func animateFadeinLabel(hidden: Bool, label: UILabel, button: UIButton, config: UIButton) {
        
        if hidden == true {
            
            label.hidden  = true
            button.hidden = true
            config.hidden = true
            
            label.center  = CGPointMake(label.center.x - 400, label.center.y)
            button.center = CGPointMake(button.center.x - 400, button.center.y)
            
        } else {
            
            //設定アイコンは微回転
            sender = config
            setAnimationAtAnimationType("angle")
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                label.hidden  = false
                button.hidden = false
                config.hidden = false
                
                label.center  = CGPointMake(label.center.x + 400, label.center.y)
                button.center = CGPointMake(button.center.x + 400, button.center.y)
            })
            
        }
        
    }
    
    /**
     アイテム設置時アニメ
     */
    func setAnimationAtPopItem() {
        
        // アニメーションの時間を2秒に設定.
        UIView.animateWithDuration(0.4,
            
            // 遅延時間.
            delay: 0.0,
            
            // バネの弾性力. 小さいほど弾性力は大きくなる.
            usingSpringWithDamping: 0.5,
            
            // 初速度.
            initialSpringVelocity: 1.5,
            
            // 一定の速度.
            options: UIViewAnimationOptions.CurveLinear,
            
            animations: { () -> Void in
                
                self.sender!.layer.position = CGPointMake(self.target!.frame.width-100, 100)
                
                // アニメーション完了時の処理
            }) { (Bool) -> Void in
        }
        
    }
    
    
    /**
もっとスマートに。
     ボタン画像のアニメ選択・実行
     - parameter animationtype: String
     */
    func setSelectedAnimation(animationtype: String) {
        
        //変形を設定するCGAffineTransformのインスタンス
        var transformAnimation:CGAffineTransform = CGAffineTransformIdentity
        
        //アニメーションの所要時間を持つ変数 デフォルト
        var duration:Double = 0.3
        
        switch animationtype {
        
            //縮小
            case "mini":
                transformAnimation = CGAffineTransformMakeScale(0.85, 0.85)
                duration = 0.5
                break
            
            //拡大
            case "big":
                transformAnimation = CGAffineTransformMakeScale(1.65, 1.65)
                break
            
            //上移動
            case "above":
                transformAnimation = CGAffineTransformMakeTranslation(0, -20)
                break
            
            //回転
            case "rotat":
                transformAnimation = CGAffineTransformMakeRotation(CGFloat(0.25*M_PI))
                break
            
            //反転
            case "scale":
                transformAnimation = CGAffineTransformMakeScale(-1, 1)
                break
            
            default:
                transformAnimation = CGAffineTransformMakeScale(1, 1)
                duration = 0.0
                break
        }
        
        
        //アニメーション
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.sender!.transform = transformAnimation
            })
            { (Bool) -> Void in
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.sender!.transform = CGAffineTransformIdentity
                    })
                    { (Bool) -> Void in
                }
        }
        
    }
    
    
    func setAnimationAtAnimationType(animationType: String) {
    
        switch animationType {
            
            /*
            回転アニメーション.
            */
            case "angle":
            self.sender!.transform = CGAffineTransformMakeRotation(0)
            
            // radianで回転角度を指定(90度).
            let angle:CGFloat = CGFloat(M_PI_2)
            
            // アニメーションの秒数を設定(3秒).
            UIView.animateWithDuration(0.5,
            
            animations: { () -> Void in
            
                // 回転用のアフィン行列を生成.
                self.sender!.transform = CGAffineTransformMakeRotation(angle)
                },
                completion: { (Bool) -> Void in
            })
            break
        
            /*
            伸縮アニメーション.
            */
            case "scale":
            self.sender!.transform = CGAffineTransformMakeScale(1, 1)
        
            // アニメーションの時間を3秒に設定.
            UIView.animateWithDuration(3.0,
        
            animations: { () -> Void in
            // 縮小用アフィン行列を作成.
            self.sender!.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }) // 連続したアニメーション処理.
            { (Bool) -> Void in
                UIView.animateWithDuration(3.0,
                    // アニメーション中の処理.
                    animations: { () -> Void in
                    // 拡大用アフィン行列を作成.
                    self.sender!.transform = CGAffineTransformMakeScale(0.5, 0.5)
                }) // アニメーション完了時の処理.
                { (Bool) -> Void in
                    // 大きさを元に戻す.
                    self.sender!.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            break
        
            /*
            移動するアニメーション.
            */
            case "move":
            self.sender!.layer.position = CGPointMake(-30, -30)
        
            // アニメーション処理
            UIView.animateWithDuration(NSTimeInterval(CGFloat(3.0)),
                animations: {() -> Void in
                
                // 移動先の座標を指定する.
                self.sender!.center = CGPoint(x: self.target!.frame.width/2,y: self.target!
                    .frame.height/2);
                
                }, completion: {(Bool) -> Void in
            })
            break
            
            default:
                break
        }
        
    }
    
    
    /**
     アニメの停止
     - parameter sender: UIButton
     */
    func stopAnimationAll(sender: UIButton) {
        
        sender.layer.removeAllAnimations()
        
    }
    
}