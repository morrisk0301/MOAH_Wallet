//
// Created by 김경인 on 2019-08-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class PolicyDetailVC: UIViewController {

    let screenSize = UIScreen.main.bounds

    var type: String!
    var bodyView: UITextView!

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceBackButton(color: "dark")
        if(type == "policy"){
            self.setNavigationTitle(title: "이용 약관")    
        }
        else{
            self.setNavigationTitle(title: "개인정보 보호정책")
        }


        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(scrollView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner()
    }

    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }

    private func setupLayout(){
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func loadData(){
        let httpRequest = HTTPRequest()
        if(type == "policy"){
            httpRequest.getPolicy(request: HTTPRequest.Request.policy, completion: {(policy) in
                self.initBody(text: policy)
            })
        } else if(type == "privacy"){
            httpRequest.getPolicy(request: HTTPRequest.Request.privacy, completion: {(policy) in
                self.initBody(text: policy)
            })
        }
    }

    private func initBody(text: String){
        bodyView = UITextView(frame: CGRect(x: scrollView.frame.width * 0.05, y: 0, width: scrollView.frame.width * 0.9, height: scrollView.frame.height))
        bodyView.text = "\n"+text+"\n\n"
        bodyView.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        bodyView.textColor = UIColor(key: "darker")
        bodyView.isEditable = false
        bodyView.backgroundColor = .clear
        self.scrollView.addSubview(bodyView)
        self.hideSpinner()
    }
}
