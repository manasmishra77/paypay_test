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
    
    
    weak var currencyListView: CurrencyList!
    weak var exchangeRateView: CurrencyList!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = CurrencyListVCViewModel(delegate: self)
        
        configureView()
    }
    

    @IBAction func cuurencySelectionBtnTapped(_ sender: Any) {
        self.currencyListView.isHidden = false
        self.exchangeRateView.isHidden = true
        self.currencyListView.reloadCurrencyListCollectionView(list: [])
    }
    
    
    func configureView() {
        currencyTF.delegate = self
        configureBody()
        self.setupHideKeyboardOnTap()
    }
    
    func configureBody() {
        self.configureCurrencyList()
        self.configureExchangeRatesList()
    }
    
    func configureCurrencyList() {
        let body = CurrencyList.instanceFromNib()
        body.addAsSubViewWithConstraints(self.bodyContainer)
                
        let size = CGSize(width: self.bodyContainer.frame.width - 20, height: 50)
        
        body.configureView(delegate: self, itemSize: size, viewType: CurrencyList.ViewType.currencyList, currencyList: [], exchangeRates: [], currency: "")
        self.currencyListView = body
        body.isHidden = true
    }
    
    func configureExchangeRatesList() {
        let body = CurrencyList.instanceFromNib()
        body.addAsSubViewWithConstraints(self.bodyContainer)
        let size = CGSize(width: self.bodyContainer.frame.width/2 - 5, height: self.bodyContainer.frame.width/2 - 5)
        body.configureView(delegate: self, itemSize: size, viewType: CurrencyList.ViewType.currencyList, currencyList: [], exchangeRates: [], currency: "")
        self.exchangeRateView = body
        body.isHidden = true
    }
    
}

extension CurrencyListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.enteredCurrency = textField.text
        self.viewModel.getExchangeRates()
    }
}


extension CurrencyListViewController: CurrencyListDelegate {
    
    func itemSelected(id: String) {
        self.cuurencySelectionButton.setTitle(id, for: .normal)
        self.viewModel.selectedCurrencyID = id
    }
}

extension CurrencyListViewController: CurrencyListVCViewModelDelegate {
    func currencyListFetched(list: [Currency], with err: AppErrors?) {
        if let err = err {
            self.showAlert(withTitle: "Failed", withMessage: err.msg)
        } else {
            self.currencyListView.reloadCurrencyListCollectionView(list: list)
        }
    }
    
    func exchangeRatesFetched(rates: [(String, Double)], currency: String, with err: AppErrors?) {
        if let err = err {
            self.showAlert(withTitle: "Failed", withMessage: err.msg)
        } else {
            self.exchangeRateView.reloadExchangeRateCollectionView(list: rates, currency: currency)
        }

    }
    
}



