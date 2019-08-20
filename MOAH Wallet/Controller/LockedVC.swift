//
// Created by 김경인 on 2019-08-19.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class LockedVC: UIViewController {

    let screenSize = UIScreen.main.bounds
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    var lockTime: Date?
    var seconds: Int?
    var timer = Timer()
    var isInit = true

    let timeLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont(name:"NanumSquareRoundEB", size: 40)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()

        view.addSubview(warningLabel)
        view.addSubview(timeLabel)

        self.lockTime = appDelegate?.lockTime
    }

    override func viewWillAppear(_ animated: Bool) {
        setupTimer()
        let hours = Int(self.seconds!) / 3600
        let minutes = Int(self.seconds!) / 60
        let seconds = Int(self.seconds!) % 60
        let hourString = String(format: "%02d", hours)
        let minString = String(format: "%02d", minutes)
        let secString = String(format: "%02d", seconds)

        self.timeLabel.text = "\(hourString):\(minString):\(secString)"
    }

    override func viewDidAppear(_ animated: Bool) {
        setupLabel()
        setupLayout()
        runTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){

        timeLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenSize.height/20).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/20).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/20).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: screenSize.height/10).isActive = true

        warningLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenSize.height/20).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/20).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/20).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/5).isActive = true
    }

    private func setupLabel(){
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let attrText = NSMutableAttributedString(string: "비밀번호 오류로 이용이 제한됩니다.", 
                attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,
                            NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 18)!,
                            NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n\n\n잠시 후에 다시 이용해주세요.", 
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xCCCCCC),
                             NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 16)!,
                             NSAttributedString.Key.paragraphStyle: style]))

        warningLabel.attributedText = attrText
    }

    private func setupTimer(){
        let date = Date()
        let difference = self.lockTime!.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate + 10

        guard Int(difference) >= 0 else {
            self.seconds = 0
            return
        }

        self.seconds = Int(difference)
    }

    private func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
    }

    private func invalidateTimer(){
        timer.invalidate()
        UserDefaults.standard.removeObject(forKey: "lockTime")
        let lockVC = LockVC()

        self.appDelegate?.lockTime = nil
        self.appDelegate?.window?.rootViewController = lockVC
    }

    @objc private func updateTimer(_ sender: Timer){
        seconds = seconds! - 1
        if(seconds! <= 0){
            invalidateTimer()
            return
        }

        let hours = Int(self.seconds!) / 3600
        let minutes = Int(self.seconds!) / 60
        let seconds = Int(self.seconds!) % 60
        let hourString = String(format: "%02d", hours)
        let minString = String(format: "%02d", minutes)
        let secString = String(format: "%02d", seconds)

        self.timeLabel.text = "\(hourString):\(minString):\(secString)"
    }
}