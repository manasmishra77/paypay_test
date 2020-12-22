//
//  SearchList.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//

import UIKit

protocol SearchListDelegate: AnyObject {
    func itemSelected(id: String)
    func callForNextPageData()
}

class SearchList: UIView {
    
    enum ViewType {
        case movieList
        case recommendation
    }
    
    var viewModel: SearchListViewModel!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    let cellIdentifier = "SearchCollectionViewCell"
    let recomcellIdentifier = "SearchRecommendationCell"
    
    
    class func instanceFromNib() -> SearchList {
        return UINib(nibName: "SearchList", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SearchList
    }
    
    private var linespacing: CGFloat = 0
    private var interitemspacing: CGFloat = 0
    private var itemSize: CGSize!
    
    weak var delegate: SearchListDelegate!
    
    
    func configureView(delegate: SearchListDelegate, itemSize: CGSize, linespacing: CGFloat = 20, itemspacing: CGFloat = 20, viewType: ViewType, recommendations: [String], movieList: [MovieSearch]) {
        
        self.delegate = delegate
        self.linespacing = linespacing
        self.interitemspacing = itemspacing
        self.itemSize = itemSize
        
        self.viewModel = SearchListViewModel(viewType, recommendations: recommendations, movieList: movieList)
        
        
        let searchcellNib = UINib(nibName: cellIdentifier, bundle: nil)
        searchCollectionView.register(searchcellNib, forCellWithReuseIdentifier: cellIdentifier)
        let recomcellNib = UINib(nibName: recomcellIdentifier, bundle: nil)
        searchCollectionView.register(recomcellNib, forCellWithReuseIdentifier: recomcellIdentifier)
       
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.reloadData()
    }
    
    func reloadSearchListCollectionView(list: [MovieSearch]) {
        self.viewModel.movieList = list
        self.searchCollectionView.reloadData()
    }
    
    func reloadRecomListCollectionView(list: [String]) {
        self.viewModel.recommendations = list
        self.searchCollectionView.reloadData()
    }
    
}

extension SearchList: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfItemCell(index: indexPath.row, width: itemSize.width)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return linespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemspacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.viewType == .movieList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SearchCollectionViewCell
            let movie = viewModel.getMovie(index: indexPath.row)
            cell.configureCell(name: movie.name, releaseDate: movie.releaseDate, posterImageURL: movie.posterImage, description: movie.desc)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recomcellIdentifier, for: indexPath) as! SearchRecommendationCell
            let recom = viewModel.getRecommendation(index: indexPath.row)
            cell.configureCell(recom: recom)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.viewType == .recommendation {
            delegate.itemSelected(id: viewModel.getRecommendation(index: indexPath.row))
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.viewType == .movieList {
            if(self.searchCollectionView.contentOffset.y >= (self.searchCollectionView.contentSize.height - self.searchCollectionView.bounds.size.height)) {
                self.delegate.callForNextPageData()
            }
        }
       
    }


}
    

