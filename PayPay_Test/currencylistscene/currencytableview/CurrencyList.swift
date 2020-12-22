//
//  CurrencyList.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 22/12/20.
//

import UIKit

protocol CurrencyListDelegate: AnyObject {
    func itemSelected(id: String, countryName: String)
}

class CurrencyList: UIView {
    
    enum ViewType {
        case currencyList
        case exchangeRates
    }
    
    var viewModel: CurrencyListViewModel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    
    let currencyCellIdentifier = "CurrencyCollectionViewCell"
    let exchangeRateCellIdentifier = "ExchangeRateCollectionViewCell"
    
    
    class func instanceFromNib() -> CurrencyList {
        return UINib(nibName: "CurrencyList", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CurrencyList
    }
    
    private var linespacing: CGFloat = 0
    private var interitemspacing: CGFloat = 0
    private var itemSize: CGSize!
    
    weak var delegate: CurrencyListDelegate!
    
    
    func configureView(delegate: CurrencyListDelegate, itemSize: CGSize, linespacing: CGFloat = 20, itemspacing: CGFloat = 20, viewType: ViewType, currencyList: [Currency], exchangeRates: [(String, Double)], currency: String) {
        
        self.delegate = delegate
        self.linespacing = linespacing
        self.interitemspacing = itemspacing
        self.itemSize = itemSize
        
        self.viewModel = CurrencyListViewModel(viewType, exchangeRates: exchangeRates, currencyList: currencyList)
        self.viewModel.selectedCurrency = currency
        
        
        let currencycellNib = UINib(nibName: currencyCellIdentifier, bundle: nil)
        currencyCollectionView.register(currencycellNib, forCellWithReuseIdentifier: currencyCellIdentifier)
        let exchangeCellNib = UINib(nibName: exchangeRateCellIdentifier, bundle: nil)
        currencyCollectionView.register(exchangeCellNib, forCellWithReuseIdentifier: exchangeRateCellIdentifier)
       
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        currencyCollectionView.reloadData()
        
        self.titleLabel.text = viewModel.titleLabelText
    }
    
    func reloadCurrencyListCollectionView(list: [Currency]) {
        self.viewModel.currencyList = list
        self.currencyCollectionView.reloadData()
    }
    
    func reloadExchangeRateCollectionView(list: [(String, Double)], currency: String) {
        self.viewModel.exchangeRates = list
        self.viewModel.selectedCurrency = currency
        self.titleLabel.text = self.viewModel.titleLabelText
        self.currencyCollectionView.reloadData()
    }
    
}

extension CurrencyList: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize

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
        if viewModel.viewType == .currencyList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currencyCellIdentifier, for: indexPath) as! CurrencyCollectionViewCell
            let currency = self.viewModel.currencyList[indexPath.row]
            cell.configureCell(country: currency.countryName ?? "", currency: currency.countryCode ?? "")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: exchangeRateCellIdentifier, for: indexPath) as! ExchangeRateCollectionViewCell
            let rate = self.viewModel.exchangeRates[indexPath.row]
            cell.configureCell(val: rate.1, name: rate.0)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.viewType == .currencyList {
            delegate.itemSelected(id: self.viewModel.currencyList[indexPath.row].countryCode ?? "", countryName: self.viewModel.currencyList[indexPath.row].countryName ?? "")
        }
    }


}
    

