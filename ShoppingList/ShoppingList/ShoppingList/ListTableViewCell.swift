//
//  ListTableViewCell.swift
//  invariant
//
//  Created by Vedran Moškov on 08.02.2024..
//

import Foundation
import UIKit

final class ListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var animatingView: UIStackView!
    
    // MARK: - Utility methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func toggleSelected(_ selected: Bool) {
        if selected {
            animatingView.backgroundColor = UIColor(
                red: 67/255.0,
                green: 108/255.0,
                blue: 90/255.0,
                alpha: 1.0
            )
            titleLabel.textColor = UIColor.white
            amountLabel.textColor = UIColor.lightGray
        }
        else {
            animatingView.backgroundColor = UIColor.white
            titleLabel.textColor = UIColor.black
            amountLabel.textColor = UIColor.darkGray
        }
    }
    
    func flashSelected() {
        animatingView.backgroundColor = UIColor(
            red: 224/255,
            green: 224/255,
            blue: 224/255,
            alpha: 1
        )
        animatingView.backgroundColor = UIColor.white
    }
    
    func configure(with item:ShoppingListItem) {
        titleLabel.text = item.name
        
        let amount = item.amount
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        formatter.decimalSeparator = "."
        
        amountLabel.text = "Amount: \(formatter.string(from: NSNumber(value: amount)) ?? "0")"
    }
}
