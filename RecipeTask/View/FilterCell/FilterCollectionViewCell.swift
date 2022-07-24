//
//  FilterCollectionViewCell.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-23.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    static let identifier = "FilterCollectionViewCell"
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.clipsToBounds = false
        mainView.layer.cornerRadius = mainView.frame.height/2
        mainView.backgroundColor = .systemGreen

    }
    
    func config(with index: Int){
        switch index {
        case 0:
            filterLabel.text = Filter.all.rawValue
        case 1:
            filterLabel.text = Filter.low.rawValue
        case 2:
            filterLabel.text = Filter.keto.rawValue
        default:
            filterLabel.text = Filter.vegan.rawValue
        }
    }
    
}
