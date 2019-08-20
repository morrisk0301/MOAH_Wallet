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

        var params: String{
            switch self{
            case .search:
                return "api/token/search/"
            case .searchAll:
                return "api/token/"
            }
        }
    }

    func tokenSearch(request: Request, params: String, completion: @escaping ([CustomToken]) -> ()){
        let url = serverUrl + request.params + params
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
            var logo: Data?

            let name = data["token_name"] as! String
            let symbol = data["token_symbol"] as! String
            let decimals = data["token_decimals"] as! Int
            let address = data["token_contract"] as! String

            if let imageArray = data["token_logo"] as? [[String: Any]]{
                print(imageArray)
            }
            else{
                print("fail")
                logo = nil
            }

            let token = CustomToken(name: name, symbol: symbol, address: address, decimals: decimals, network: "mainnet", logo: logo)
            tokenArr.append(token)
        }
        print(tokenArr)
        return []
    }
}
