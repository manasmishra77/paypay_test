//
//  MovieListViewController.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//


import UIKit

class MovieListViewController: UIViewController {
    
    var viewModel: MovieListVCViewModel!

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var bodyContainer: UIView!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    weak var searchListView: SearchList!
    weak var recommendationView: SearchList!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = MovieListVCViewModel(networkManager: AppManager.shared.networkManager, delegate: self)
        
        configureView()
    }
    
    func configureView() {
        searchTextField.delegate = self
        configureBody()
        self.setupHideKeyboardOnTap()
    }
    
    func configureBody() {
        self.configureSearchList()
        self.configureRecommendations()
    }
    
    func configureSearchList() {
        let body = SearchList.instanceFromNib()
        body.addAsSubViewWithConstraints(self.bodyContainer)
                
        let size = CGSize(width: self.bodyContainer.frame.width - 20, height: 50)
        
        body.configureView(delegate: self, itemSize: size, viewType: .movieList, recommendations: [], movieList: [])
        self.searchListView = body
        body.isHidden = true
    }
    
    func configureRecommendations() {
        let body = SearchList.instanceFromNib()
        body.addAsSubViewWithConstraints(self.bodyContainer)
        let size = CGSize(width: self.bodyContainer.frame.width - 20, height: 50)
        body.configureView(delegate: self, itemSize: size, viewType: .recommendation, recommendations: [], movieList: [])
        self.recommendationView = body
        body.isHidden = true
    }

    @IBAction func searchBtnTapped(_ sender: Any) {
        viewModel.fetchMovie(searchKey: searchTextField.text ?? "")
    }
    
}

extension MovieListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchListView.isHidden = true
        self.recommendationView.isHidden = false
        self.recommendationView.reloadRecomListCollectionView(list: viewModel.getRecomList())
    }
}


extension MovieListViewController: SearchListDelegate {
    
    func itemSelected(id: String) {
        self.searchTextField.text = id
        viewModel.fetchMovie(searchKey: id)
    }
    
    func callForNextPageData() {
        viewModel.fetchMovie(searchKey: searchTextField.text ?? "")
    }
}

extension MovieListViewController: MovieListVCViewModelDelegate {
    func newMovieFetchingStarted() {
        self.createSpinnerView()
    }
    func movieDataFetched(with err: AppError?) {
        self.removeSpinnerView()
        if let err = err {
            self.showAlert(withTitle: "Failed", withMessage: err.msg)
        } else {
            self.searchListView.isHidden = false
            self.recommendationView.isHidden = true
            self.searchListView.reloadSearchListCollectionView(list: viewModel.getMovieList())
        }
    }
}


