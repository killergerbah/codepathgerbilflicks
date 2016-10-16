//
//  TheMovieDbService.swift
//  com.gerbil.GerbilFlicks
//
//  Created by R-J Lim on 10/14/16.
//  Copyright © 2016 R-J Lim. All rights reserved.
//

import Foundation

class MovieDbService {
    
    private static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    private static let baseUrl = "https://api.themoviedb.org"
    private static let nowPlayingUrl = "\(baseUrl)/3/movie/now_playing?api_key=\(apiKey)"
    private static let topRatedUrl = "\(baseUrl)/3/movie/top_rated?api_key=\(apiKey)"
    private static let detailsUrl = "\(baseUrl)/3/movie"
    
    private static var movies: [Movie] = []
    private static var movieDetails: [Int: Movie] = [:]
    
    var movies: [Movie] {
        return MovieDbService.movies
    }
    
    func getList(_ callback: ([Movie]) -> Void, failureCallback: (Void) -> Void, category: MovieCategory) {
        let url = self.url(category: category)
        request(url, callback: callback, failureCallback: failureCallback, factory: { dict in
            guard let results = dict["results"] as? NSArray else {
                return []
            }
            
            var movies: [Movie] = []
            for resultOrNil in results {
                if let result = resultOrNil as? NSDictionary {
                    if let movie = self.movie(result) {
                        movies.append(movie)
                    }
                }
            }
            
            MovieDbService.movies = movies
            
            return movies
        })
    }
    
    private func url(category: MovieCategory) -> String {
        switch (category) {
            case MovieCategory.TopRated:
                return MovieDbService.topRatedUrl
            default:
                return MovieDbService.nowPlayingUrl
        }
    }
    
    func getDetails(_ id: Int, callback: (MovieDetails) -> Void, failureCallback: (Void) -> Void) {
        request("\(MovieDbService.detailsUrl)/\(id)?api_key=\(MovieDbService.apiKey)", callback: callback, failureCallback: failureCallback, factory: { dict in
            guard let genresArray = dict["genres"] as? NSArray,
                let popularity = dict["vote_average"] as? Double,
                let runtime = dict["runtime"] as? Int,
                let tagLine = dict["tagline"] as? String else {
                    return nil
            }
            
            return MovieDetails(genres: self.genres(array: genresArray), popularity: popularity, runtime: TimeInterval(runtime) * 60, tagLine: tagLine)
        })
    }
        
    private func genres(array: NSArray) -> [String] {
        var genres: [String] = []
        for dictOrNil in array {
            if let dict = dictOrNil as? NSDictionary,
                let genre = dict["name"] as? String {
                genres.append(genre)
            }
        }
        
        return genres
    }
    
    private func request<T>(_ url: String, callback: (T) -> Void, failureCallback: (Void) -> Void, factory: (NSDictionary) -> T?) {
        guard let urlUrl = URL(string: url) else {
            return
        }
        let request = URLRequest(url: urlUrl)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if error != nil {
                failureCallback()
            } else if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    if let results = factory(responseDictionary) {
                        callback(results)
                    } else {
                        failureCallback()
                    }
                }
            }
            
            
        });
        task.resume()
    }
    
    private func movie(_ dict: NSDictionary) -> Movie? {
        if let id = dict["id"] as? Int,
            let title = dict["title"] as? String,
            let overview = dict["overview"] as? String,
            let imageUrl = dict["poster_path"] as? String,
            let backgroundUrl = dict["poster_path"] as? String,
            let releaseDate = dict["release_date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            return Movie(id: id,
                         title: title,
                         overview: overview,
                         imageUrl: "https://image.tmdb.org/t/p/w185_and_h278_bestv2/\(imageUrl)",
                         backgroundUrl: "https://image.tmdb.org/t/p/original\(backgroundUrl)",
                         releaseDate: dateFormatter.date(from: releaseDate)
            )
        }
        
        return nil
    }
}
