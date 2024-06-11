//
//  CollectionViewCell.swift
//  Shiftzyproject_new
//
//  Created by Narayana on 06/06/24.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var numberLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var dateOfBirthLbl: UILabel!
    @IBOutlet var genderLbl: UILabel!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var shiftingLbl: UILabel!
    @IBOutlet var submitBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImg.layer.cornerRadius = profileImg.frame.width / 2
        submitBtn.layer.cornerRadius = 10
        profileImg.clipsToBounds = true
    }
    func configCell(data: DataClass?) {
        self.profileImg.kf.setImage(with: URL(string: data?.profileImageURL ?? ""))
        self.emailLbl.text = data?.email
        self.numberLbl.text = data?.phoneNumber
        self.nameLbl.text = data?.fullName
        self.dateOfBirthLbl.text = data?.dateOfBirth
        self.genderLbl.text = data?.gender
        self.statusLbl.text = data?.relocationStatus
        self.shiftingLbl.text = data?.shiftOrShiftedDate
        
    }
}
