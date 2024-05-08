//
//  ViewController.swift
//  dealsProject
//
//  Created by Anil kumar on 01/05/24.
//

//
//struct DealsProject: Codable {
//    var settings: SettingsInfo?
//    var data: [DataInfo?]
//}
//struct SettingsInfo: Codable {
//    var success: Int?
//    var message: String?
//    var status: Int?
//}
//struct DataInfo: Codable {
//    var eventId: Int?
//    var name: String?
//    var description:String?
//    var website:String?
//    var location:String?
//    var countryId:Int?
//    var country:String?
//    var startDate:String?
//    var endDate:String?
//    var eventType:String?
//    var status:String?
//    var sectorSelection:String?
//    var sectors:[String?]
//}


import UIKit
import Alamofire


struct DealsProject: Codable {
    var settings: SettingsInfo?
    var data: [DataInfo]?
}

struct SettingsInfo: Codable {
    var success: Int?
    var message: String?
    var status: Int?
}
struct DataInfo: Codable {
    var dealId: Int?
    var title: String?
    var companyName: String?
    var description: String?
    var subscriptionPlanEnum: String?
    var image: String?
    var buttonText: String?
    var buttonUrl: String?
    var isDownloadable: String?
    var status: String?
    var orderSequence: Int?
    var addedDate: String?
    var modifiedDate: String?
    var imageUrl: String?
}
class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var deals: DealsProject?
    override func viewDidLoad() {
        super.viewDidLoad()
        dealsPost()
        setupNavigationBar()
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Deals"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    func dealsPost() {
        var headers = [String: String]()
        headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbklkIjoxODUsIm5hbWUiOiJKZXNzaWNhIFR1cm5lciBOZXciLCJmaXJzdE5hbWUiOiJKZXNzaWNhIiwibGFzdE5hbWUiOiJUdXJuZXIgTmV3IiwiZW1haWwiOiJqZXNzaWNhQHlvcG1haWwuY29tIiwidXNlck5hbWUiOm51bGwsInBob25lTnVtYmVyIjoiKzkxOTk3OTY0Nzg3OCIsInN0YXR1cyI6IkFjdGl2ZSIsImdyb3VwQ29kZXMiOlsiZm91bmRlciJdLCJsb2dJZCI6NTg4MywiaWF0IjoxNzE1MDU3MzQzLCJleHAiOjE3MTUxMjkzNDMsImF1ZCI6Imh0dHBzOi8vZm91bmRlcmNlbnRlcmVkLWFwaS5wcm9qZWN0c3ByZXZpZXcubmV0IiwiaXNzIjoiaHR0cHM6Ly9mb3VuZGVyY2VudGVyZWQtYXBpLnByb2plY3RzcHJldmlldy5uZXQifQ.fdOmWacYJHYGrYhlW4Bfcbjt9geltrYs_IkZ5XPlIuU"
        AF.request("https://foundercentered-api.projectspreview.net/api/deal/available-deal", parameters: nil,headers: HTTPHeaders(headers)).response { response in
            if let data = response.data {
                print("data ===", data)
                do {
                    self.deals = try JSONDecoder().decode(DealsProject.self, from: data)
                    DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    }
                } catch let error as NSError {
                    print("Failed  to Load:\(error.localizedDescription)")
                }
            }
            
        }
    }
}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.configCell(data: deals?.data?[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SecondViewController.instance()
        vc.currentDeal = deals?.data?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultWidth = collectionView.frame.width
        return CGSize(width: defaultWidth, height: 170)
    }
}
    






