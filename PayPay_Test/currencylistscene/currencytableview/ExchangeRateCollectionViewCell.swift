//
//  ExchangeRateCollectionViewCell.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 22/12/20.
//

import UIKit

class ExchangeRateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var exchangeValues: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setCornerRadius(5)
    }
    
    func configureCell(val: Double, name: String) {
        self.currencyName.text = name
        self.exchangeValues.text = "\(val.rounded(toPlaces: 2))"
    }

}
