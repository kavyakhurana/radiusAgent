//
//  Interactor.swift
//  radiusagent
//
//  Created by Kavya Khurana on 30/06/23.
//

import Foundation
import RxSwift

class Interactor: InteractorProtocol {
    
    var dataSubj = PublishSubject<Entity.APIResponse>()
    
    var router: RouterProtocol?
    var dataResponse: Entity.APIResponse?
    let urlString = "https://my-json-server.typicode.com/iranjith4/ad-assignment/db"
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func viewLoaded() {
        getDataFromApi()
    }
    
    func getDataFromApi() {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("error in getting data from request \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else {
                print("no data received")
                return
            }

            
            do {
                let apiResponse = try JSONDecoder().decode(Entity.APIResponse.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    self?.dataSubj.onNext(apiResponse)
                }
            } catch {
                print("Error decoding API response: \(error)")
            }
        }
        
        task.resume()
    }
    
}
