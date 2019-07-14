//
// Created by 김경인 on 2019-07-14.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

protocol PostDelegate{
    func cellPressed(cellItem: String)
}

class KeyCell: UICollectionViewCell {

    let digitsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellPressed(_:))))

        addSubview(digitsLabel)
        digitsLabel.centerInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }

    @objc private func cellPressed(_ sender: UITapGestureRecognizer){

    }
}

class KeypadViewController : UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate let cellId = "cellId"

    let screenSize = UIScreen.main.bounds

    var numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var postDelegate: PostDelegate?

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
        collectionView.backgroundColor = .yellow

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .red

        addSubview(collectionView)

        numbers.shuffle()
        numbers.insert("", at: 9)
        numbers.append("del")

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
        cell.digitsLabel.text = numbers[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KeyCell
        postDelegate?.cellPressed(cellItem: cell.digitsLabel.text!)
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
