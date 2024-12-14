//
//  BondCell.swift
//  Bond_Helper
//


import UIKit

class BondCell: UITableViewCell {
    
    @IBOutlet weak var bondName: UILabel!
    @IBOutlet weak var interestRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
