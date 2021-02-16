

import Foundation


enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(APPError)
}


class ApiService{
    
    private init() {}
    static let instance = ApiService()
    

    
    
   func dataRequest<T: Decodable>(url:String ,objectType: T.Type, headers:[String:String]? ,params:[String:Any]?,method:String, completion: @escaping (Result<T>) -> Void) {
    
    
    var components = URLComponents(string: url)!
    if let params = params{
            components.queryItems = [URLQueryItem]()
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
    guard let url = URL(string: url) else {return}
    var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = [ "Accept":"application/json",
                                        "Content-Type":"application/json"]
    
    
        
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error in
  
     
        guard error == nil else {
          
            completion(Result.failure(APPError.networkError(error!)))
            return
        }

        guard let data = data else {
            completion(Result.failure(APPError.dataNotFound))
            return
        }
		
        do {
            
            //create decodable object from data
            let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
                    
        } catch let error {
           
            completion(Result.failure(APPError.jsonParsingError(error as! DecodingError)))
            
        }
    })

    task.resume()
}
}
