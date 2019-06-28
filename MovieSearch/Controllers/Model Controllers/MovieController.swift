//
//  MovieController.swift
//  MovieSearch
//
//  Created by Darin Marcus Armstrong on 6/28/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class MovieController {
    
    static let baseURL = URL(string: "https://api.themoviedb.org/3")
    
    static func fetchMovieFor(term: String, completion: @escaping ([Movie]?) -> Void) {
        guard var url = baseURL else {completion(nil); return}
        
        url.appendPathComponent("search")
        url.appendPathComponent("movie")
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {completion(nil); return}
        let apiQuery = URLQueryItem(name: "api_key", value: "1cc9f8060ce325d7b8e3eb1bc2e2ba4b")
        let searchTermQuery = URLQueryItem(name: "query", value: term)
        components.queryItems = [apiQuery, searchTermQuery]
        
        guard let finalURL = components.url else {completion(nil); return}
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("An error occured getting data: \(error.localizedDescription)")
                completion(nil); return
            }
            
            guard let data = data else {completion(nil); return}
            
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(TopLevelJSON.self, from: data)
                completion(topLevelJSON.results)
            } catch {
                print("There was an error decoding the data: \(error.localizedDescription)")
                completion(nil); return
            }
            
        }.resume()
    }
    
    static func fetchImageFor(movie: Movie, completion: @escaping (UIImage?) -> Void) {
        guard var baseURL = URL(string: "https://image.tmdb.org/t/p") else {completion(nil); return}
        
        baseURL.appendPathComponent("original")
        baseURL.appendPathComponent(movie.poster)
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("There was an error with the image URL: \(error.localizedDescription)")
                completion(nil); return
            }
            
            guard let data = data else {
                print("There was an error retrieving an image")
                completion(nil); return
            }
            
            let image = UIImage(data: data)
            completion(image)
            
        }.resume()
    }
}//end of class
