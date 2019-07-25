//
// Created by 김경인 on 2019-07-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TokenSelectVC: UIViewController {
    let screenSize = UIScreen.main.bounds

    var alertTitle: String?
    var alertBody: String?
    var alertButtonTitle: String?
    var buttonAction: ((Bool) -> Void)?
    var buttonbool: Bool?

    let alertView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.isOpaque = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        label.text = "암호화폐 선택"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.setTitleColor(UIColor(key: "dark"), for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(red: 130, green: 130, blue: 130), for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(key: "light3")
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true

        view.addSubview(titleLabel)
        view.addSubview(addButton)


        setupLayout()
    }

    private func setupLayout(){
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height/200).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height/200).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        /*
        backButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: alertView.centerXAnchor, constant: -0.5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: alertHeight/5).isActive = true*/
    }

    func showAlertView(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
            self.alertView.transform = .identity
        }, completion: nil)
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
