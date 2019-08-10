//
// Created by 김경인 on 2019-07-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

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

        let buttonImage = UIImageView(frame: CGRect(x: button.frame.width/2, y: button.frame.height/2, width: view.frame.width/35, height: (view.frame.width/35)*1.5))

        if(color == "dark"){
            buttonImage.image = UIImage(named: "back")    
        }else{
            buttonImage.image = UIImage(named: "whiteArrow")
        }

        button.addSubview(buttonImage)
        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: button)
        leftButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
        leftButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true

        self.navigationItem.leftBarButtonItem = leftButton
    }

    func replaceToQuitButton(color: String){
        self.navigationItem.hidesBackButton = true
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let buttonImage = UIImageView(frame: CGRect(x: button.frame.width/2, y: button.frame.height/2, width: view.frame.width/25, height: view.frame.width/25))

        if(color == "dark"){
            buttonImage.image = UIImage(named: "quit")
        }else{
            buttonImage.image = UIImage(named: "quitWhite")
        }

        button.addSubview(buttonImage)
        button.addTarget(self, action: #selector(quitPressed(_:)), for: .touchUpInside)

        let rightButton = UIBarButtonItem(customView: button)
        rightButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
        rightButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true

        self.navigationItem.rightBarButtonItem = rightButton
    }

    func transparentNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setNavigationTitle(title: String){
        navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)!,
                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]
    }

    func showSpinner(){
        let spinner = Spinner()
        spinner.frame = view.frame
        view.addSubview(spinner)
    }

    func hideSpinner(){
        for subview in view.subviews{
            if(subview is  Spinner){
                subview.removeFromSuperview()
            }
        }
    }

    @objc private func backPressed(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func quitPressed(_ sender: UIButton){
        self.dismiss(animated: true)
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
        else if(key=="darker"){
            self.init(
                    red: 0x20 & 0xFF,
                    green: 0x20 & 0xFF,
                    blue: 0x20 & 0xFF
            )
        }
        else if(key=="light"){
            self.init(
                    red: 0x8A & 0xFF,
                    green: 0xD1 & 0xFF,
                    blue: 0xFF & 0xFF
            )
        }
        else if(key=="light2"){
            self.init(
                    red: 0xD0 & 0xFF,
                    green: 0xDC & 0xFF,
                    blue: 0xFF & 0xFF
            )
        }
        else if(key=="light3"){
            self.init(
                    red: 0xF7 & 0xFF,
                    green: 0xF7 & 0xFF,
                    blue: 0xF7 & 0xFF
            )
        }
        else if(key=="grey"){
            self.init(
                    red: 0xBB & 0xFF,
                    green: 0xBB & 0xFF,
                    blue: 0xBB & 0xFF
            )
        }
        else if(key=="grey2"){
            self.init(
                    red: 0x99 & 0xFF,
                    green: 0x99 & 0xFF,
                    blue: 0x99 & 0xFF
            )
        }
        else{
            self.init(
                    red: 0 & 0xFF,
                    green: 0xA2 & 0xFF,
                    blue: 0xDD & 0xFF
            )
        }
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

extension UIFont{
    convenience init?(name: String, size: CGFloat, dynamic: Bool){
        if(dynamic){
            let device = UIDevice.current.screenType
            switch device {
            case .iPhones_5_5s_5c_SE: //Iphone 3,4,SE => 3.5 inch
                self.init(name: name, size: size * 0.85)
                break
            case .iPhones_6_6s_7_8: //iphone 5, 5s => 4 inch
                self.init(name: name, size: size * 0.9)
                break
            case .iPhone_XR: //iphone 6, 6s => 4.7 inch
                self.init(name: name, size: size * 0.9)
                break
            case .iPhones_6Plus_6sPlus_7Plus_8Plus: //iphone 6s+ 6+ => 5.5 inch
                self.init(name: name, size: size)
                break
            case .iPhones_X_XS:
                self.init(name: name, size: size)
                break
            case .iPhone_XSMax:
                self.init(name: name, size: size)
                break
            default:
                print("not an iPhone")
                self.init(name: name, size: size)
                break
            }
        }else{
            self.init(name: name, size: size)
        }
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

    func applyShadow(){
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
        layer.cornerRadius = 4.0
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

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}

extension UINavigationController:UINavigationControllerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: self.interactivePopGestureRecognizer)) {
            if viewControllers.count > 1 {
                interactivePopGestureRecognizer?.isEnabled = true
            } else {
                interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }
}