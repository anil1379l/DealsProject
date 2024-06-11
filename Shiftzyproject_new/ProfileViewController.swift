//
//  ProfileViewController.swift
//  Shiftzyproject_new
//
//  Created by Narayana on 06/06/24.
//

import UIKit
import Alamofire
import Kingfisher

class ProfileViewController: UIViewController {
    
    var profileData: ProfileInfoItem?
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var profileStack: UIStackView!
    @IBOutlet var tabBarStack: UIStackView!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var myAccountStack: UIStackView!
    @IBOutlet var changePasswordStack: UIStackView!
    @IBOutlet var mainView: UIView!

    
    class func instance() -> ProfileViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        mainView.layer.cornerRadius = 20
        NavigationBarSetup.setup(for: self, title: "SWIFTZY", backButtonAction: #selector(backButtonTapped), button1Action: nil, button2Action: nil, button3Action: nil)
        editBtn.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        let myAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(myAccountTapped))
        myAccountStack.addGestureRecognizer(myAccountTapGesture)
        
        let changePasswordGesture = UITapGestureRecognizer(target: self, action: #selector(changePasswordTapped))
        changePasswordStack.addGestureRecognizer(changePasswordGesture)
        
    }
    
    func setupUI() {
        profileStack.layer.cornerRadius = 10
        profileImg.layer.cornerRadius = profileImg.frame.width / 2
        tabBarStack.layer.cornerRadius = 25
        profileImg.clipsToBounds = true
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func editButtonTapped() {
        let thirdVC = UpdateProfileViewController.instance()
        navigationController?.pushViewController(thirdVC, animated: true)
    }
    @objc func myAccountTapped() {
        let thirdVC = UpdateProfileViewController.instance()
        navigationController?.pushViewController(thirdVC, animated: true)
    }
    @objc func changePasswordTapped() {
        let fourhVC = ChangePasswordViewController.instance()
        navigationController?.pushViewController(fourhVC, animated: true)
    }
    
    func fetchData() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcklkIjoxMjYsImZ1bGxOYW1lIjoibmFyYXlhbmEgMTgiLCJlbWFpbCI6Im5hcmF5YW5hLnJhbysxOEBoaWRkZW5icmFpbnMuaW4iLCJlbWFpbFZlcmlmaWVkIjoxLCJjb3VudHJ5VG9Mb2NhdGUiOjIzNSwic3RhdHVzIjoiQWN0aXZlIiwibG9nSWQiOjIyNDUsImlhdCI6MTcxODA3OTkxNSwiZXhwIjoxNzE4MTUxOTE1LCJhdWQiOiJodHRwczovL3NoaWZ0enp5LWFwaS5wcm9qZWN0c3ByZXZpZXcubmV0IiwiaXNzIjoiaHR0cHM6Ly9zaGlmdHp6eS1hcGkucHJvamVjdHNwcmV2aWV3Lm5ldCJ9.t_zEZxjwzxEPAM08Fv74R2cqJZgzk_95q5deF-Twp4A"
        ]
            AF.request("https://shiftzzy-api.projectspreview.net/api/v1/customer/profile", headers: headers).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        self.profileData = try JSONDecoder().decode(ProfileInfoItem.self, from: data!)
                        DispatchQueue.main.async {
                            self.updateUI()
                        }
                    } catch let error as NSError {
                        print("Failed to decode profile data: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("API request failed: \(error.localizedDescription)")
                }
            }
        }
    
    func updateUI() {
        if let profileData = self.profileData {
            if let imageUrl = URL(string: profileData.data?.profileImageURL ?? "") {
                self.profileImg.kf.setImage(with: imageUrl)
            }
            var locationText = ""
            if let relocationStatus = profileData.data?.relocationStatus {
                locationText += relocationStatus
            }
            if let destinationCountry = profileData.data?.destinationCountry?.countryName {
                if !locationText.isEmpty {
                    locationText += " "
                }
                locationText += destinationCountry
            }
            self.locationLbl.text = locationText
            self.titleLbl.text = profileData.data?.fullName
        }
    }
}
