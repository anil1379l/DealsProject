//
//  ThirdCollectionViewCell.swift
//  dealsProject
//
//  Created by Anil kumar on 02/05/24.
//

import UIKit

class ThirdCollectionViewCell: UICollectionViewCell {
    static let identifier = "ThirdCollectionViewCell"
    @IBOutlet var nameLbl:UILabel!
    @IBOutlet var startLbl:UILabel!
    @IBOutlet var endLbl:UILabel!
    @IBOutlet var locationLbl:UILabel!
    @IBOutlet var websiteLbl:UILabel!
//    @IBOutlet var sectorLbl:UILabel!
//    @IBOutlet var descriptionLbl:UILabel!
    @IBOutlet var cornerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cornerView.layer.cornerRadius = 5
        // Initialization code
    }
    func configCell(data: DataList?) {
        self.nameLbl.text = data?.name
        
        let startDateAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 13, weight: .medium)
        ]
        let startDateString = NSMutableAttributedString(string: "Start Date: ", attributes: startDateAttributes)
        
        if let startDate = data?.startDate {
            let startDateValueAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ]
            startDateString.append(NSAttributedString(string: "\(startDate)", attributes: startDateValueAttributes))
        }
        
        let endDateAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: UIColor.lightGray,
               .font: UIFont.systemFont(ofSize: 13, weight: .medium)
           ]
           let endDateString = NSMutableAttributedString(string: "End Date: ", attributes: endDateAttributes)
           
           if let endDate = data?.endDate {
               let endDateValueAttributes: [NSAttributedString.Key: Any] = [
                   .foregroundColor: UIColor.black,
                   .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
               ]
               endDateString.append(NSAttributedString(string: "\(endDate)", attributes: endDateValueAttributes))
           }
           
           self.startLbl.attributedText = startDateString
           self.endLbl.attributedText = endDateString
        self.locationLbl.text = data?.location
        self.websiteLbl.text = data?.website
//        self.sectorLbl.text = data?.sectors
//        self.descriptionLbl.text = data?.description
        
        
    }

}
