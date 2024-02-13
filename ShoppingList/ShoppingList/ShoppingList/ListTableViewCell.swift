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
        animatingView.backgroundColor = selected ? UIColor.lightGray.withAlphaComponent(0.6) : UIColor.white
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
