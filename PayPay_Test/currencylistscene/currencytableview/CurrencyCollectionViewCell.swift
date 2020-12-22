//
//  CurrencyCollectionViewCell.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 22/12/20.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(country: String, currency: String) {
        self.currencyName.text = currency
        self.countryName.text = country
    }

}
