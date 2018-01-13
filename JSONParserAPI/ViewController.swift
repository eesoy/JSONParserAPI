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

//UIImageView 클래스에 함수를 만듦
extension UIImageView {
    func downloadFromUrlString(url: String) {
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView_movie: UITableView!
    var movieInfoArray = [MovieInfo]()
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView_movie.dataSource = self
        tableView_movie.delegate = self
        requestMovieInfo(page: currentPage)
        currentPage += 1
    }
    
    func requestMovieInfo(page: Int){
        
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
                        DispatchQueue.main.async { // correct UI 관련 작업은 반드시 메인 스레드에서
                            self.tableView_movie.reloadData()
                        }
                        
                    }
                    
                    
                }
                catch let error {
                    print("parsing error: \(error.localizedDescription)")
                }
            })
            task.resume()
        }
    }
    
    //MARK: -UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
//        if let url = URL(string: movieInfoArray[indexPath.row].thumbnailUrl){
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                     cell.img_thumbnail.image = UIImage(data: data)
//                }
//            }).resume()
//        }
        cell.img_thumbnail.downloadFromUrlString(url: movieInfoArray[indexPath.row].thumbnailUrl)
        cell.lbl_title.text = movieInfoArray[indexPath.row].title
        
        
        //스크롤이 바닥에 닿았을 때
        if indexPath.row == movieInfoArray.count - 1 {
            requestMovieInfo(page: currentPage)
        }
        
        return cell
    }
    
    
    //MARK: -UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    

    
    

}

