//
//  MoviesViewModel.swift
//  Project-4
//
//  Created by BigAdmin on 08/01/23.
//

import Foundation

struct MoviesViewModel {
    var movies = [Movies]()
    
    mutating func loadMovies() {
        movies.append(Movies(name: "Hello"))
    }
}
