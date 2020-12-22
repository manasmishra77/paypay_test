//
//  MovieListVCViewModel.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//

import UIKit

protocol MovieListVCViewModelDelegate: AnyObject {
    func newMovieFetchingStarted()
    func movieDataFetched(with err: AppError?)
}



class MovieListVCViewModel {
    
    var recommendations: [String] = []
    var movieResponse: MovieListResponse?
    var currentSearchKey: String = ""
    var currentPageNo = 1
    var totalPages = 1
    var isInApiCall = false
    
    
    var networkManager: NetworkManagerProtocol!
    var delegate: MovieListVCViewModelDelegate!
    
    init(networkManager: NetworkManagerProtocol, delegate: MovieListVCViewModelDelegate) {
        self.networkManager = networkManager
        self.delegate = delegate
    }
    
    func updateRecommendation(searchKey: String) {
        if !recommendations.contains(searchKey) {
            if recommendations.count >= 10 {
                recommendations = Array(recommendations.dropFirst())
            }
            recommendations.append(searchKey)
        }
    }
    
    func heightOfMovieCell(width: CGFloat, index: Int) -> CGFloat {
        if let movie = movieResponse?.results?[index] {
            return (movie.overview?.heightOfLabel(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 12)) ?? 0) + 100
        }
        return 0
    }
    
    func fetchMovie(searchKey: String) {
        if isInApiCall {
            return
        }
        let modifiedSearchKey = searchKey.removingLeadingSpaces().trimTrailingWhitespace()
        
        let isPrevSearch = modifiedSearchKey == currentSearchKey
        var pageno = currentPageNo
        if isPrevSearch {
            if pageno + 1 > totalPages {
                return
            }
            pageno += 1
        } else {
            self.movieResponse = nil
            currentSearchKey = modifiedSearchKey
            currentPageNo = 1
            totalPages = 1
            pageno = 1
            self.delegate.newMovieFetchingStarted()
        }
        self.isInApiCall = true
        
        networkManager.doNetworkCallForMovieList(searchKey: modifiedSearchKey, pageNo: pageno, totalPage: totalPages) {[weak self] (code, model, err) in
            guard let self = self else {return}
            self.isInApiCall = false
            DispatchQueue.main.async {
                if let err = err as? NetworkManager.NetworkError {
                    self.delegate.movieDataFetched(with: AppError(code: err.code, msg: err.msg))
                    return
                } else {
                    if let model = model as? MovieListResponse {
                        if isPrevSearch {
                            self.currentPageNo += 1
                            self.totalPages = model.total_pages ?? 1
                            self.movieResponse?.results?.append(contentsOf: model.results ?? [])
                            self.updateRecommendation(searchKey: modifiedSearchKey)
                            self.delegate.movieDataFetched(with: nil)
                        } else {
                            if model.results?.isEmpty ?? true {
                                self.delegate.movieDataFetched(with: AppError(code: 456, msg: "Model not present"))
                            } else {
                                self.updateRecommendation(searchKey: modifiedSearchKey)
                                self.movieResponse = model
                                self.currentPageNo = 1
                                self.totalPages = model.total_pages ?? 1
                                self.delegate.movieDataFetched(with: nil)
                            }
                        }
                    } else {
                        self.delegate.movieDataFetched(with: AppError(code: 455, msg: "Model not present"))
                    }
                }
            }
        }
    }
    
    func getMovieList() -> [MovieSearch] {
        return self.movieResponse?.results ?? []
    }
    
    func getRecomList() -> [String] {
        return recommendations.reversed()
    }
    
}

