//
//  CouponsTableViewCell.swift
//  couponzy7.7
//
//  Created by מאיס on 10/07/2021.
//

import UIKit

class CouponsTableViewCell: UITableViewCell {
    @IBOutlet var myLabel:UILabel!
    @IBOutlet var couponDescription:UILabel!
    @IBOutlet var codeCoupon:UILabel!
    @IBOutlet var validTill:UILabel!
    @IBOutlet var orginalPrice:UILabel!
    @IBOutlet var finalPrice:UILabel!
    @IBOutlet var companyImageView:UIImageView!
    @IBOutlet var myImageView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
    }
}
