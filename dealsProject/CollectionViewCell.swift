import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var companyLbl:UILabel!
    @IBOutlet var tittleLbl:UILabel!
    @IBOutlet var descriptionLbl:UILabel!
    @IBOutlet var stack:UIStackView!
    @IBOutlet var viewlbl:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tittleLbl.layer.borderWidth = 1
        tittleLbl.layer.cornerRadius = 5
        
        stack.layer.cornerRadius = 10
        stack.clipsToBounds = true
        
    }
    func configCell(data: DataInfo?) {
        self.imageView.kf.setImage(with: URL(string: data?.imageUrl ?? ""))
        self.companyLbl.text = data?.companyName
        
        if let htmlString = data?.description {
            if let attributedString = htmlString.attributedStringFromHTML {
                let fontSize: CGFloat = 14.0
                let boldFont = UIFont.boldSystemFont(ofSize: fontSize)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: boldFont,
                    .foregroundColor: UIColor.gray
                ]
                let modifiedAttributedString = NSMutableAttributedString(attributedString: attributedString)
                modifiedAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
                self.descriptionLbl.attributedText = modifiedAttributedString
            } else {
                self.descriptionLbl.text = data?.description
                self.descriptionLbl.textColor = .gray
            }
        } else {
            // Handle the case where HTML string is nil
            self.descriptionLbl.text = data?.description
            self.descriptionLbl.textColor = .gray // Set text color to gray
        }
        
        if let title = data?.title, !title.isEmpty {
            self.tittleLbl.isHidden = false
            self.tittleLbl.text = title
            self.viewlbl.isHidden = false
        } else {
            self.tittleLbl.isHidden = true
            self.viewlbl.isHidden = true
        }
    }




}

extension String {
    var attributedStringFromHTML: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print("Error converting HTML string: \(error)")
            return nil
        }
    }
}
