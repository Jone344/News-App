import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class EmailedVC: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    lazy var newsData = NewsData(context: context)
    var arrayOfNewsData = [NewsData]()
    
    var titleArray = [String]()
    var newsSourceArray = [String]()
    var imageURLArray = [String]()
    var newsStoryUrlArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        self.newsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNewsData { (success) in
            if success {
                print("success")
                
           //     self.imageURLArray = self.imageURLArray.filter { $0 != ""} //filter array to remove nil values
                self.newsTableView.reloadData()
                print(self.imageURLArray.count)
            } else {
                print("doesnt work ")
            }
        }
    }
    

    func save(link: String, image: String, title: String, source: String) {
        
//     let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
//     let newsData = NSEntityDescription.insertNewObject(forEntityName: "NewsData", into: context) as!NewsData
        
        newsData.link = link
        newsData.image = image
        newsData.title = title
        newsData.source = source
        
        do {
            try context.save()
            print("successfully saved")
        } catch {
            print("Could not save")
        }
    }
}
   

extension EmailedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return imageURLArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellEmailed", for: indexPath) as? NewsCellEmailed else { return UITableViewCell() }
        
        
        cell.newsImage.sd_setImage(with: URL(string: imageURLArray[indexPath.row]))
        cell.newsImage.layer.cornerRadius = 10
        cell.newsSource.text = newsSourceArray[indexPath.row]
        cell.newsTitle.text = titleArray[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let urls = newsStoryUrlArray[(indexPath.row)]
        UIApplication.shared.open(URL(string: urls)!) 
        
        if arrayOfNewsData.count != 0 {
            guard ((arrayOfNewsData[indexPath.row].link?.contains(urls)) == nil) else { return }
        }

        self.save(link: urls, image: self.imageURLArray[indexPath.row], title: self.titleArray[indexPath.row], source: self.newsSourceArray[indexPath.row])
    }
}


extension EmailedVC {
    
    func getNewsData(complete: @escaping (_ status: Bool) -> ()) {
        
        Alamofire.request("https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=0l1QWFx2rTrt0PjzcZYohV9TdqiPiQyz").responseJSON { response in
            
            guard let value = response.result.value else { return }
            
            let json = JSON(value)
            
            for item in json["results"].arrayValue {
                        
                guard !self.titleArray.contains(item["title"].stringValue) else { return } //чтобы при переключении экрана не дублировались новости

                self.newsStoryUrlArray.append(item["url"].stringValue)
                self.titleArray.append(item["title"].stringValue)
                self.newsSourceArray.append(item["source"].stringValue)
                self.imageURLArray.append(item["media"][0]["media-metadata"][0]["url"].stringValue)
                }
            complete(true)
        }
    }
}


