//
//  CurrencyListViewController.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 22/12/20.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    var viewModel: CurrencyListVCViewModel!

    
    @IBOutlet weak var bodyContainer: UIView!
    
    @IBOutlet weak var cuurencySelectionButton: UIButton!
    
    @IBOutlet weak var currencyTF: UITextField!
    
    
    weak var currencyListView: SearchList!
    weak var exchangeRateView: SearchList!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = CurrencyListVCViewModel(networkManager: AppManager.shared.networkManager, delegate: self)
        
        configureView()
    }
    

    @IBAction func cuurencySelectionBtnTapped(_ sender: Any) {
    }
    
    
    func configureView() {
        currencyTF.delegate = self
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
    
}




extension CurrencyListViewController: UITextFieldDelegate {
    
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


extension CurrencyListViewController: SearchListDelegate {
    
    func itemSelected(id: String) {
        self.searchTextField.text = id
        viewModel.fetchMovie(searchKey: id)
    }
    
    func callForNextPageData() {
        viewModel.fetchMovie(searchKey: searchTextField.text ?? "")
    }
}

extension CurrencyListViewController: CurrencyListVCViewModelDelegate {
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



