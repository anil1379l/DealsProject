//
//  UpdateProfileViewController.swift
//  Shiftzyproject_new
//
//  Created by Narayana on 06/06/24.
//

import UIKit
import Alamofire

struct ProfileInfoItem: Codable {
    let settings: settings?
    let data: DataClass?
}

struct DataClass: Codable {
    let customerID: Int?
    let email, fullName, dateOfBirth, gender: String?
    let originPointLocation, relocationPointLocation: NPointLocation
    let cityOfOrigin, shiftOrShiftedDate: String?
    let isOnboarded: Int?
    let onboardingStep, university, cityToLocate, relocationStatus: String?
    let dialCode, phoneNumber, profileImage: String?
    let originCountry, destinationCountry: NCountry?
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case email, fullName, dateOfBirth, gender, originPointLocation, relocationPointLocation, cityOfOrigin, shiftOrShiftedDate, isOnboarded, onboardingStep, university, cityToLocate, relocationStatus, dialCode, phoneNumber, profileImage, originCountry, destinationCountry
        case profileImageURL = "profileImageUrl"
    }
}

struct NCountry: Codable {
    let countryID: Int?
    let countryName: String?
    
    enum CodingKeys: String, CodingKey {
        case countryID = "countryId"
        case countryName
    }
}
struct NPointLocation: Codable {
    let lng, lat: Double?
}
struct settings: Codable {
    let success: Int?
    let message: String?
    let status: Int?
}


class UpdateProfileViewController: UIViewController {
    
    @IBOutlet var collectionview: UICollectionView!
    var profileData: ProfileInfoItem?
    @IBOutlet var tabBarStack: UIStackView!
    @IBOutlet var mainView: UIView!

    
    class func instance() -> UpdateProfileViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UpdateProfileViewController") as! UpdateProfileViewController
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfile()
        setupUI()
        // Do any additional setup after loading the view.
        collectionview.register(UINib(nibName: CollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionview.dataSource = self
        collectionview.delegate = self

        NavigationBarSetup.setup(for: self, title: "SWIFTZY", backButtonAction: #selector(backButtonTapped), button1Action: nil, button2Action: nil, button3Action: nil)
        
        func setupUI() {
            mainView.layer.cornerRadius = 20
            tabBarStack.layer.cornerRadius = 25
            tabBarStack.clipsToBounds = true
            
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    func updateProfile() {
        var headers = [String: String]()
        headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcklkIjoxMjYsImZ1bGxOYW1lIjoibmFyYXlhbmEgMTgiLCJlbWFpbCI6Im5hcmF5YW5hLnJhbysxOEBoaWRkZW5icmFpbnMuaW4iLCJlbWFpbFZlcmlmaWVkIjoxLCJjb3VudHJ5VG9Mb2NhdGUiOjIzNSwic3RhdHVzIjoiQWN0aXZlIiwibG9nSWQiOjIyNDUsImlhdCI6MTcxODA3OTkxNSwiZXhwIjoxNzE4MTUxOTE1LCJhdWQiOiJodHRwczovL3NoaWZ0enp5LWFwaS5wcm9qZWN0c3ByZXZpZXcubmV0IiwiaXNzIjoiaHR0cHM6Ly9zaGlmdHp6eS1hcGkucHJvamVjdHNwcmV2aWV3Lm5ldCJ9.t_zEZxjwzxEPAM08Fv74R2cqJZgzk_95q5deF-Twp4A"
        AF.request("https://shiftzzy-api.projectspreview.net/api/v1/customer/profile", parameters: nil,headers: HTTPHeaders(headers)).response { response in
            if let data = response.data {
                print("data ===", data)
                do {
                    self.profileData = try JSONDecoder().decode(ProfileInfoItem.self, from: data)
                    DispatchQueue.main.async {
                        self.collectionview.reloadData()
                    }
                } catch let error as NSError {
                    print("Failed  to Load:\(error.localizedDescription)")
                }
            }
        }
    }
}
extension UpdateProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileData?.data != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        if let data = profileData?.data {
            print("Data: \(data)")
            cell.configCell(data: data)
        }
        return cell
    }
}
extension UpdateProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 800)
    }
}
