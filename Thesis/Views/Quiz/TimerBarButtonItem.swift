//
//  TimerBarButtonItem.swift
//  Thesis
//
//  Created by István Juhász on 2023. 02. 25..
//

import Foundation
import UIKit

protocol TimerBarButtonItemDelegate: AnyObject {
    func timerDidEnd()
}

class TimerBarButtonItem: UIBarButtonItem {
    
    let timerLabel = UILabel()
    var timer: Timer?
    var secondsLeft: Int
    
    weak var delegate: TimerBarButtonItemDelegate?
    
    init(secondsLeft: Int) {
        self.secondsLeft = secondsLeft
        super.init()
        
        self.customView = timerLabel
        
        timerLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        timerLabel.textColor = UIColor.black
        timerLabel.text = timeString(secondsLeft)
        timerLabel.adjustsFontSizeToFitWidth = true
        
        customView?.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerLabel.leftAnchor.constraint(equalTo: self.customView!.leftAnchor, constant: 16),
        ])

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateTimer() {
        secondsLeft -= 1
        timerLabel.text = timeString(secondsLeft)
        
        if secondsLeft < 60 {
            timerLabel.textColor = .exitRed
        }
        
        if secondsLeft <= 0 {
            timer?.invalidate()
            timer = nil
            delegate?.timerDidEnd()
        }
    }
    
    func timeString(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
