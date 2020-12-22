//
//  SearchListViewModel.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//

import UIKit

class SearchListViewModel {
    
    var viewType: SearchList.ViewType
    
    var recommendations: [String] = []
    var movieList: [MovieSearch] = []
    
    var listCount: Int {
        if viewType == .movieList {
            return movieList.count
        }
        return recommendations.count
    }
    
    func getRecommendation(index: Int) -> String {
        return recommendations[index]
    }
    
    func getMovie(index: Int) -> (name: String, releaseDate: String?, posterImage: URL?, desc: String) {
        let movie = movieList[index]
        
        return (name: movie.title ?? "", releaseDate: movie.releaseDateString, posterImage: movie.imagePosterURL, desc: movie.overview ?? "")
    }
    
    
    init(_ type: SearchList.ViewType, recommendations: [String], movieList: [MovieSearch]) {
        self.viewType = type
        self.recommendations = recommendations
        self.movieList = movieList
    }
    
    func heightOfMovieCell(width: CGFloat, index: Int) -> CGFloat {
        let movie = movieList[index]
        return (movie.overview?.heightOfLabel(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 12)) ?? 0) + 130
    }
    
    func sizeOfItemCell(index: Int, width: CGFloat) -> CGSize {
        if viewType == .movieList {
            return CGSize(width: width, height: heightOfMovieCell(width: width, index: index))
        } else {
            return CGSize(width: width, height: 50)
        }
    }
}
