//
//  ViewController.swift
//  MOAH Wallet
//
//  Created by 김경인 on 2019-06-29.
//  Copyright © 2019 Sejong University Alom. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    let screenSize = UIScreen.main.bounds

    let moahWalletText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        textView.text = "MOAH Wallet"
        textView.font = UIFont(name: "NanumSquareRoundEB", size: 40)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false

        return textView
    }()

    let explainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        textView.text = "MOAH Wallet은 이더리움 및 ERC20 토큰과\ndApp을 위한 암호화폐 지갑입니다."
        textView.font = UIFont(name: "NanumSquareRoundB", size: 14)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false

        return textView
    }()

    let newWalletButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("새로운 지갑 만들기", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    let getWalletButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("기존 지갑 복원하기", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()

        view.addSubview(moahWalletText)
        view.addSubview(explainText)
        view.addSubview(newWalletButton)
        view.addSubview(getWalletButton)

        setupLayout()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        moahWalletText.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/4).isActive = true
        moahWalletText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moahWalletText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moahWalletText.heightAnchor.constraint(equalToConstant: 60).isActive = true

        explainText.topAnchor.constraint(equalTo: moahWalletText.bottomAnchor, constant: 20).isActive = true
        explainText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        explainText.widthAnchor.constraint(equalToConstant: screenWidth*(0.85)).isActive = true
        explainText.heightAnchor.constraint(equalToConstant: 60).isActive = true

        newWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        newWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        newWalletButton.bottomAnchor.constraint(equalTo: getWalletButton.topAnchor, constant: -30).isActive = true
        newWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        getWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        getWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        getWalletButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        getWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func buttonPressed(_ sender: UIButton){
        let agreementVC = AgreementVC()
        if(sender.tag == 2){
            agreementVC.getWallet = true
        }
        let navigationController = UINavigationController(rootViewController: agreementVC)

        self.present(navigationController, animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func setupBackground(){
        let backgroundImage = UIImageView(image: UIImage(named: "background"))

        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func replaceBackButton(color: String){
        self.navigationItem.hidesBackButton = true
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        if(color == "dark"){
            button.setImage(UIImage(named: "backArrow"), for: .normal)    
        }
        else if (color == "light"){
            button.setImage(UIImage(named: "whiteArrow"), for: .normal)
        }
        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: button)
        leftButton.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        leftButton.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true

        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc private func backPressed(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
                red: (rgb >> 16) & 0xFF,
                green: (rgb >> 8) & 0xFF,
                blue: rgb & 0xFF
        )
    }

    convenience init(key: String){
        if(key == "dark"){
            self.init(
                    red: 0x00 & 0xFF,
                    green: 0x67 & 0xFF,
                    blue: 0xE2 & 0xFF
            )
        }
        else if(key=="light"){
            self.init(
                    red: 0x9F & 0xFF,
                    green: 0xC8 & 0xFF,
                    blue: 0xFF & 0xFF
            )
        }
        else if(key=="darker"){
            self.init(
                    red: 0x00 & 0xFF,
                    green: 0x16 & 0xFF,
                    blue: 0x34 & 0xFF
            )
        }
        else{
            self.init(
                    red: 0 & 0xFF,
                    green: 0x78 & 0xFF,
                    blue: 0xE2 & 0xFF
            )
        }
    }

    func keyColorDark(){
        //return 0x078E2
    }
}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

extension UIView {

    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {

        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()

        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }

        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }

        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }

        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }

        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }

        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }

        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }

        return anchoredConstraints
    }

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }

        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }

        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }

        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }

    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }

        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }

    func centerYInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }

    func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}

extension MutableCollection {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}

extension String {
    func replace(target: String, withString: String, offset: Int) -> String {
        let indexRange = self.startIndex..<self.index(self.startIndex, offsetBy: 3*offset-2)
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: indexRange)
    }

    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}
