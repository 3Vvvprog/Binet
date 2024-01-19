//
//  DBService.swift
//  BinetProject
//
//  Created by Вячеслав Вовк on 17.01.2024.
//

import Foundation
import Alamofire
import UIKit




class DBService {
    var url = "http://shans.d2.i-partner.ru"
    
    func fetchData(id: Int, complition: @escaping (Result<Preparat, Error>) -> ()) {
        
        let preparationUrl = self.url + "/api/ppp/item/?id=\(id)"
            
        
        let concurent = DispatchQueue.global(qos: .background)
     
        
        
        concurent.async {
            AF.request(preparationUrl)
                .validate()
                .response { response in
                    
                    guard let data = response.data else {
                        
                        if let error = response.error {
                            complition(.failure(error))
                        }
                        return
                    }
                    let error = response.error
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    guard let plantPreparation = try? decoder.decode(Preparat.self, from: data) else {
                        complition(.failure(error!))
                        return
                    }
                    complition(.success(plantPreparation))
                }
        }
    }
    
    
    func fetchDataBySearch(search: String, complition: @escaping (Result<[Preparat], Error>) -> ()) {
        
        let preparationUrl = self.url + "/api/ppp/index/?search=\(search)"
            
        
        let concurent = DispatchQueue.global(qos: .background)
        
        concurent.async {
            AF.request(preparationUrl)
                .validate()
                .response { response in
                    
                    guard let data = response.data else {
                        
                        if let error = response.error {
                            complition(.failure(error))
                        }
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    guard let plantPreparation = try? decoder.decode([Preparat].self, from: data) else {
                        
                        return
                    }
                    complition(.success(plantPreparation))
                }
                
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: String, imageView: UIImageView) {
        
        let imageUrl = URL(string: self.url + url.description)!
        getData(from: imageUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
            
            
        }
    }
}
