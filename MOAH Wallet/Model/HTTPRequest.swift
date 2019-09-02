//
// Created by 김경인 on 2019-08-20.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import Alamofire

class HTTPRequest {

    private let serverUrl = "http://54.180.108.59/"
    private let engText = "?lang=en"

    enum Request{
        case search
        case searchAll
        case date
        case notice
        case policy
        case privacy

        var url: String{
            switch self{
            case .search:
                return "api/token/search/"
            case .searchAll:
                return "api/token/"
            case .date:
                return "api/date/"
            case .notice:
                return "api/notice/"
            case .policy:
                return "api/policy/"
            case .privacy:
                return "api/privacy/"
            }
        }
    }

    func getPolicy(request: Request, completion: @escaping (String) -> ()){
        var url = serverUrl + request.url
        if(Locale.current.languageCode == "en"){
            url += engText
        }
        DispatchQueue.global(qos: .userInitiated).async{
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    if let policy = value as? [String: Any] {
                        if(Locale.current.languageCode == "en"){
                            let policyString: String = policy["policy_body_eng"] as! String
                            completion(policyString)
                        }
                        else{
                            let policyString: String = policy["policy_body"] as! String
                            completion(policyString)
                        }
                    }else{
                        completion("")
                    }
                case .failure(let error):
                    print(error)
                    completion("")
                }
            }
        }
    }

    func getNotice(completion: @escaping ([CustomNotice]) -> ()){
        var url = serverUrl + Request.notice.url
        if(Locale.current.languageCode == "en"){
            url += engText
        }
        DispatchQueue.global(qos: .userInitiated).async{
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let noticeArr = self._parseNotice(response: value)
                    completion(noticeArr)
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
        }
    }

    func getDate(completion: @escaping (Date?) -> ()){
        let url = serverUrl + Request.date.url
        DispatchQueue.global(qos: .userInitiated).async{
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    if let date = value as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = TimeZone.autoupdatingCurrent

                        let newDate:Date = dateFormatter.date(from: date)!
                        completion(newDate)
                    }
                    else{
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
        }
    }

    func tokenSearch(request: Request, params: String, completion: @escaping ([CustomToken]) -> ()){
        let url = serverUrl + request.url + params
        DispatchQueue.global(qos: .userInitiated).async{
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let tokenArr = self._parseToken(response: value)
                    completion(tokenArr)
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
        }
    }

    private func _parseToken(response: Any) -> [CustomToken]{
        guard let dataArray = response as? [[String: Any]] else { return [] }

        var tokenArr = [CustomToken]()
        for data in dataArray{
            let name = data["token_name"] as! String
            let symbol = data["token_symbol"] as! String
            let decimals = data["token_decimals"] as! Int
            let address = data["token_contract"] as! String
            let logoEncoded = data["token_logo"] as! String
            let logo : Data = Data(base64Encoded: logoEncoded, options: .ignoreUnknownCharacters)!
            let token = CustomToken(name: name, symbol: symbol, address: address, decimals: decimals, network: "mainnet", logo: logo)
            tokenArr.append(token)
        }
        return tokenArr
    }

    private func _parseNotice(response: Any) -> [CustomNotice]{
        guard let dataArray = response as? [[String: Any]] else { return [] }

        var noticeArr = [CustomNotice]()
        for data in dataArray{
            var head: String
            var body: String
            if(Locale.current.languageCode == "en"){
                head = data["notice_head_eng"] as! String
                body = data["notice_body_eng"] as! String    
            }
            else{
                head = data["notice_head"] as! String
                body = data["notice_body"] as! String
            }

            let rawDate = data["created_at"] as! String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent

            let date:Date = dateFormatter.date(from: rawDate)!
            let notice = CustomNotice(head: head, body: body, createdAt: date, opened: false, height: 0.0)
            noticeArr.append(notice)
        }
        return noticeArr
    }
}
