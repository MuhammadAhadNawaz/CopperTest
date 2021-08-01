//
//  OrderCell.swift
//  CopperTest
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblETH: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func config(_ order:Orders) {
        
        setupCurrencyInfo(order)
        self.lblOrderStatus.text = order.orderStatus
        self.lblETH.text = "ETH"
       
        if let createdAt = order.createdAt,
           let timeStamp = Double(createdAt) {
            let dateStr = Date.fromatedDateString(timeStamp / 1000,
                                            toFormat: "MMM dd, yyyy HH:mm:ss a")
            self.lblSubTitle.text = dateStr
        }else {
            self.lblSubTitle.text = ""
        }
        
    }
    
    func setupCurrencyInfo(_ order: Orders) {
        let orderType = OrderType(rawValue: order.orderType ?? "")
        let currency = order.currency ?? Constants.StringDef.unknown
        let orderAmount =  Double(order.amount ?? "0") ?? 0
        let amount = String(format: "%.4f", orderAmount)
        
        self.lblETH.isHidden = true
        self.arrow.isHidden = true
        
        switch orderType {
        case .deposit:
            self.lblTitle.text =  "In \(currency)"
            self.lblAmount.text =  "+ \(amount) \(currency)"
        case .withdraw:
            self.lblTitle.text =  "Out \(currency)"
            self.lblAmount.text = "- \(amount) \(currency)"
        case .buy:
            self.lblTitle.text =  "\(currency)"
            self.lblAmount.text = "+ \(amount) \(currency)"
            self.lblETH.isHidden = false
            self.arrow.isHidden = false
        case .sell:
            self.lblTitle.text =  "\(currency)"
            self.lblAmount.text = "- \(amount) \(currency)"
            self.lblETH.isHidden = false
            self.arrow.isHidden = false
        case .none:
            self.lblTitle.text =  Constants.StringDef.unknown
            self.lblAmount.text = ""
        }
        
    }

}

