//
//  MovieTableViewController.swift
//  MovieSearch
//
//  Created by Darin Marcus Armstrong on 6/28/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieItems: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = 150
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        let movieItem = movieItems[indexPath.row]
        cell.movieTitleLabel.text = movieItem.title
        cell.movieRatingLabel.text = String("\(movieItem.rating)")
        cell.movieOverviewTextView.text = movieItem.overview
        MovieController.fetchImageFor(movie: movieItem) { (image) in
            DispatchQueue.main.async {
                cell.movieImageView.image = image
            }
        }
        return cell
    }
}

extension MovieTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchTerm != "" else {return}
        
        MovieController.fetchMovieFor(term: searchTerm) { (movieFromCompletion) in
            if let unwrappedMovie = movieFromCompletion {
                self.movieItems = unwrappedMovie
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
