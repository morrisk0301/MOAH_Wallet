//
// Created by 김경인 on 2019-08-20.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import Alamofire

class HTTPRequest {

    private let serverUrl = "http://13.125.53.194:3000/"

    enum Request{
        case search
        case searchAll
        case date

        var url: String{
            switch self{
            case .search:
                return "api/token/search/"
            case .searchAll:
                return "api/token/"
            case .date:
                return "api/date/"
            }
        }
    }

    func getDate(request: Request, completion: @escaping (Date?) -> ()){
        let url = serverUrl + request.url
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
                    let tokenArr = self._parseResponse(response: value)
                    completion(tokenArr)
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
        }
    }

    private func _parseResponse(response: Any) -> [CustomToken]{
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
}
