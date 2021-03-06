//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Nicole  Steele on 2/4/18.
//  Copyright © 2018 Nicole  Steele. All rights reserved.
//

import UIKit
import AlamofireImage
import KRProgressHUD
import KRActivityIndicatorView


class NowPlayingViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
         refreshControl  = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        fetchMovies()
    
    }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
   fetchMovies() }
    func fetchMovies() { let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
    let session = URLSession(configuration:.default, delegate: nil,delegateQueue: OperationQueue.main  )
    let task = session.dataTask(with: request) { (data, response, error) in
        // this will run when the network request returns
        if let error = error {
            
            print(error.localizedDescription)  }
        else if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let movies = dataDictionary["results"] as! [[String: Any]]
            self.movies = movies
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
    }
        task.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        let movie = movies[indexPath.row]
        let title = movie["title"]
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title as! String 
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString =  "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString )!
        cell.posterimageView.af_setImage(withURL: posterURL)
        
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func tableViewDidStartLoad(_ : UIView)
    {
       
        activityIndicator.startAnimating()
        
    }
    func tableViewDidFinishLoad(_ : UIView)
    {

        activityIndicator.stopAnimating()
    }

}
