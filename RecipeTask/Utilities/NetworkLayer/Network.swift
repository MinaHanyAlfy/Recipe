//
//  Network.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-22.
//

import Foundation
import Alamofire

class Network {
    
    static let shared = Network()
    
    //MARK: - To Call API USING ALAMOFIRE
    
    func getResults<M: Codable>(_ url : String? = nil, APICase: API? = nil,decodingModel: M.Type, completed: @escaping (Result<M,ErrorMessage> ) -> Void) {
        if url == nil {
            guard let APICase = APICase else {
                return
            }
        let urlRequest = APICase.request
        let request = AF.request(urlRequest)
        request.responseDecodable(of: M.self) { (response) in
          guard let results = response.value else {
              completed((.failure(.InvalidData)))
              return
          }
            completed((.success(results)))
            print(results)
        }
        } else {
            guard let url = url else {
                return
            }
            let realURL: URL = URL(string: url)!
//            let url: Alamofire.URLConvertible = realURL

            let urlRequest = URLRequest(url: realURL)

            AF.request(urlRequest).responseDecodable(of: M.self) { (response) in
                guard let results = response.value else {
                    completed((.failure(.InvalidData)))
                    return
                }
                  completed((.success(results)))
                  print(results)
              }
        }
    }
    
    //MARK: - To Call API USING URLSessionTask
    
//    func getResults<M: Codable>(APICase: API,decodingModel: M.Type, completed: @escaping (Result<M,ErrorMessage> ) -> Void) {
//
//
//        var request : URLRequest = APICase.request
//        request.httpMethod = APICase.method.rawValue
//
//       // let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error =  error {
//                print("❌ Error: ",error)
//                completed((.failure(.InvalidData)))
//            }
//            guard let data = data else {
//                print("❌ Error in data: ",data)
//                completed((.failure(.InvalidData)))
//                return
//            }
//
//            guard let response =  response  as? HTTPURLResponse ,response.statusCode == 200 else{
//                print("❌ Error in response: ",response )
//                completed((.failure(.InvalidResponse)))
//                return
//            }
//            let decoder = JSONDecoder()
//            do
//            {
//
//                let results = try decoder.decode(M.self, from: data)
//                print("✅ Results: ",results)
//                completed((.success(results)))
//
//            }catch {
//                print(error)
//                completed((.failure(.InvalidData)))
//            }
//
//        }
//        task.resume()
//    }
    
    
}

