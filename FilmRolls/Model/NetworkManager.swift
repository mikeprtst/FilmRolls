//
//  NetworkManager.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import UIKit


class NetworkManager{
    
    static var shared = NetworkManager()
    
    
    func fetchData <T:Codable> (stringURL: String, completion: @escaping (Result<T,Error>)->Void){
        
        if let filmURL = URL(string: stringURL){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: filmURL) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let safeData = data {
                    completion(self.parseJSON(safeData))
                }
                if let error = error{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    private func parseJSON <T:Codable> (_ data: Data) -> Result<T,Error> {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
    
    
    func loadThumb(string: String, ofSize size: CGSize = CGSize(width: 100, height: 100)) async throws -> UIImage? {
        return try await loadImage(string: string)?.byPreparingThumbnail(ofSize: size)
    }
    
    
    func loadImage(string: String) async throws -> UIImage? {
        guard let imageURL = URL(string: string) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        return UIImage(data: data)
    }
    
}

