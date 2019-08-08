//
// Created by 김경인 on 2019-07-12.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AlertVC: UIViewController{
    var alertHeight = UIScreen.main.bounds.height/4
    var alertWidth = UIScreen.main.bounds.width/1.2
    var alertTitle: String?
    var alertBody: String?
    var alertButtonTitle: String?
    var buttonAction: ((Bool) -> Void)?
    var buttonbool: Bool?
    var buttonNum = 1

    let alertView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.isOpaque = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0

        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)

        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.textColor = UIColor(red: 130, green: 130, blue: 130)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        label.numberOfLines = 0

        return label
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(red: 130, green: 130, blue: 130), for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(key: "regular"), for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isOpaque = false

        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(bodyLabel)
        alertView.addSubview(nextButton)
        alertView.addSubview(backButton)

        titleLabel.text = self.alertTitle!
        bodyLabel.text = self.alertBody!
        nextButton.setTitle(self.alertButtonTitle!, for: .normal)

        setupLayout()
        if(buttonNum > 1){
            setupTwoButton()
        }
        else{
            backButton.isHidden = true
            setupOneButton()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.alertView.alpha = 1
        }, completion: nil)
    }

    private func setupLayout(){
        alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: alertHeight).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: alertWidth).isActive = true

        titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: alertHeight/10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: alertHeight/9).isActive = true

        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: alertWidth/10).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -alertWidth/10).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
    }

    private func setupOneButton(){
        nextButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: alertHeight/4.5).isActive = true
    }

    private func setupTwoButton(){
        backButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: alertView.centerXAnchor, constant: -0.5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: alertHeight/4.5).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: alertHeight/4.5).isActive = true
    }

    @objc private func buttonPressed(_ sender: UIButton){
        if(sender.tag == 1){
            buttonAction?(true)
            buttonbool = true
        }
        else{
            buttonAction?(false)
            buttonbool = false
        }
        self.dismiss(animated: false)
    }
}