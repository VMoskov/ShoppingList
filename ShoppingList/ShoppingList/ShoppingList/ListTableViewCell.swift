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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - Utility methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
