import UIKit
import SafariServices
import WebKit

class SecondViewController: UIViewController {
    var deals: DealsProject?
    var currentDeal: DataInfo?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLbl: WKWebView!
    @IBOutlet var btn: UIButton!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btnlbl: UIButton!
    @IBOutlet var cornerView: UIView!
    @IBOutlet var companyLbl: UILabel!
    
    class func instance() -> SecondViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SecondViewController") as! SecondViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Deals"
        self.navigationController?.navigationBar.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn1.layer.cornerRadius = 15
        cornerView.layer.cornerRadius = 10
        self.cornerView.clipsToBounds = true
        btn.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)
        dealsPost()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Clean up WKWebView to avoid memory leaks
        descriptionLbl.navigationDelegate = nil
    }
    
    func dealsPost() {
        guard let deal = currentDeal else {
            return
        }
        self.imageView.kf.setImage(with: URL(string: deal.imageUrl ?? ""))
        // Convert HTML string to attributed string
//       if let htmlD
        self.btnlbl.setTitle(deal.buttonText, for: .normal)
        self.companyLbl.text = deal.companyName
    }

    @IBAction func goToThirdViewController(_ sender: UIButton) {
        guard let thirdVC = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController else {
            return
        }
        navigationController?.pushViewController(thirdVC, animated: true)
    }
    
    @objc func openInSafari() {
        guard let urlString = currentDeal?.buttonUrl, let url = URL(string: urlString) else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf16) else {
            print("Error: Unable to convert string to data.")
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print("Error converting HTML string: \(error)")
            return nil
        }
    }
}
