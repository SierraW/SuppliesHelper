//
//  NotificationView.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-19.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        self.showBlurEffect()
//
//        //self.perform(#selector(delayExecution), with: nil, afterDelay: 0.2)
//
//    }
    
    @IBAction func tapScreen(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        })
    }
    
    @objc func delayExecution() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1
        })
    }

    func showBlurEffect(of bounds: CGRect){
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        //self.addSubview(blurView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = bounds
        let text = UILabel(frame: CGRect(x: 10, y: bounds.width / 2 - 50, width: bounds.width - 20, height: bounds.height / 2))
        text.text = "原理：\n\t屏幕中线切割杯沿的白边\n\n使用方法：\n\t选择一张或者拍一张照片，然后点击相应按钮。\n\n小提示：\n\t请尽量把杯子们放到屏幕中间位置，并让杯沿成为图片里最亮的崽！"
        text.font = UIFont.boldSystemFont(ofSize: 20)
        text.numberOfLines = 0
        text.textAlignment = .left
        text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        vibrancyView.contentView.addSubview(text)
        blurView.contentView.addSubview(vibrancyView)
        self.addSubview(blurView)
    }
}
