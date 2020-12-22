//
//  SearchRecommendationCell.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//

import UIKit

class SearchRecommendationCell: UICollectionViewCell {

    @IBOutlet weak var titleLAbel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(recom: String) {
        self.titleLAbel.text = recom
    }

}
