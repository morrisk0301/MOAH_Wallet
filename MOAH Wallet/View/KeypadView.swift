//
// Created by 김경인 on 2019-07-14.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class KeyCell: UICollectionViewCell {

    let digitsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(digitsLabel)
        digitsLabel.centerInSuperview()
        //layer.borderWidth = 1.0
        //layer.borderColor = UIColor.lightGray.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}

class KeypadView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate let cellId = "cellId"

    let screenSize = UIScreen.main.bounds

    var numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var delegate: KeypadViewDelegate?

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: self.cellId)
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(collectionView)

        numbers.shuffle()
        numbers.insert("", at: 9)
        numbers.append("")

        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KeyCell

        if(indexPath.item == 11){
            let imageview = UIImageView(frame: CGRect(x: cell.contentView.center.x-(screenSize.width/18)*1.4*0.5, y: cell.contentView.center.y-(screenSize.width/18)*0.5, width: (screenSize.width/18)*1.4, height: screenSize.width/18));
            imageview.image = UIImage(named: "delete")

            cell.contentView.addSubview(imageview)
        }

        cell.digitsLabel.text = numbers[indexPath.item]
        cell.digitsLabel.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        cell.digitsLabel.textColor = .white

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {cell?.alpha = 0.5}) { (completed) in
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {cell?.alpha = 1})
        }

        if(indexPath.item < numbers.count-1 && indexPath.item != 9 ){
            delegate?.cellPressed(numbers[indexPath.item])
        }
        else if(indexPath.item == 11){
            delegate?.delPressed()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (screenSize.height/3)*0.25
        let width = screenSize.width/3

        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
