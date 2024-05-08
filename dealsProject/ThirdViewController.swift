import UIKit
import Alamofire

struct EventsProject: Codable {
    var settings: SettingsList?
    var data: [DataList]?
}
struct SettingsList: Codable {
    var success: Int?
    var message: String?
    var status: Int?
}
struct DataList: Codable {
    var eventId: Int?
    var name: String?
    var description:String?
    var website:String?
    var location:String?
    var countryId:Int?
    var country:String?
    var startDate:String?
    var endDate:String?
    var eventType:String?
    var status:String?
    var sectorSelection:String?
    var sectors:[String?]?
}


class ThirdViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var events:EventsProject?
    @IBOutlet weak var monthLabel: UILabel!
    
    var currentMonth = 5
    var currentYear = 2024
    
    class func instance() -> ThirdViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ThirdViewController") as! ThirdViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMonthLabel()
        eventsPost()
        collectionView.register(UINib(nibName: ThirdCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ThirdCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.navigationItem.title = "Events"
    }
    func eventsPost() {
        var headers = [String:String]()
        headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbklkIjoxODUsIm5hbWUiOiJKZXNzaWNhIFR1cm5lciBOZXciLCJmaXJzdE5hbWUiOiJKZXNzaWNhIiwibGFzdE5hbWUiOiJUdXJuZXIgTmV3IiwiZW1haWwiOiJqZXNzaWNhQHlvcG1haWwuY29tIiwidXNlck5hbWUiOm51bGwsInBob25lTnVtYmVyIjoiKzkxOTk3OTY0Nzg3OCIsInN0YXR1cyI6IkFjdGl2ZSIsImdyb3VwQ29kZXMiOlsiZm91bmRlciJdLCJsb2dJZCI6NTg4MywiaWF0IjoxNzE1MDU3MzQzLCJleHAiOjE3MTUxMjkzNDMsImF1ZCI6Imh0dHBzOi8vZm91bmRlcmNlbnRlcmVkLWFwaS5wcm9qZWN0c3ByZXZpZXcubmV0IiwiaXNzIjoiaHR0cHM6Ly9mb3VuZGVyY2VudGVyZWQtYXBpLnByb2plY3RzcHJldmlldy5uZXQifQ.fdOmWacYJHYGrYhlW4Bfcbjt9geltrYs_IkZ5XPlIuU"
        AF.request("https://foundercentered-api.projectspreview.net/api/events/calendar?startDate=1711996200000&endDate=1714501800000",parameters: nil,headers: HTTPHeaders(headers)).response { response in
            if let data = response.data {
                print("data====",data)
                do {
                    self.events = try JSONDecoder().decode(EventsProject.self, from: data)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch let error as NSError {
                    print("Failed to load:\(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateMonthLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM - yyyy"
        
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        if let date = Calendar.current.date(from: dateComponents) {
            let monthYearString = dateFormatter.string(from: date)
            monthLabel.text = monthYearString
        } else {
            print("Error: Unable to create date from currentYear and currentMonth.")
        }
    }

    @IBAction func previousMonthTapped(_ sender: Any) {
        currentMonth -= 1
        if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
        updateMonthLabel()
    }

    @IBAction func nextMonthTapped(_ sender: Any) {
        currentMonth += 1
        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        }
        updateMonthLabel()
    }
}
extension ThirdViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThirdCollectionViewCell.identifier, for: indexPath) as! ThirdCollectionViewCell
        cell.configCell(data: events?.data?[indexPath.row])
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc =
//    }
    
}
extension ThirdViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultWidth = collectionView.frame.width
        return CGSize(width: defaultWidth, height: 260)
    }
}
