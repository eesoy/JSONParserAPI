//
//  ViewController.swift
//  JSONParserAPI
//
//  Created by SO YOUNG on 2018. 1. 13..
//  Copyright © 2018년 SO YOUNG. All rights reserved.
//

import UIKit

struct MovieInfo {
    
    var title: String
    var thumbnailUrl: String
}

class ViewController: UIViewController {

    var movieInfoArray = [MovieInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let reqUrl = URL(string: "http://115.68.183.178:2029/hoppin/movies?order=releasedateasc&count=10&page=1&version=1&genreId="){
            let task = URLSession.shared.dataTask(with: reqUrl, completionHandler: { (data, response, error) in
                // 성공일 경우 data, response 값 존재하고 error 값은 nil
                // 실패일 경우 error 값은 nil 아닌 값
                
                guard let data = data,
                    let res = response as? HTTPURLResponse,
                    res.statusCode == 200 else {
                        return
                }
                
                if let err = error {
                    print(err.localizedDescription)
                }
                
                do {
                    if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                        let hoppin = jsonDic["hoppin"] as? [String: Any],
                        let movies = hoppin["movies"] as? [String: Any],
                        let movieArray = movies["movie"] as? [[String: Any]]
                        {
                            for movie in movieArray {
                                if let title = movie["title"] as? String,
                                    let thumbnail = movie["thumbnailImage"] as? String
                                {
                                    let movieInfo = MovieInfo(title: title, thumbnailUrl: thumbnail)
                                    self.movieInfoArray.append(movieInfo)
                                }
                            }
                            
                            print(self.movieInfoArray)
                        }
                    
                        
                    }
                catch let error {
                    print("parsing error: \(error.localizedDescription)")
                }
            })
            task.resume()
        }
        
    }
    
    
    

}

