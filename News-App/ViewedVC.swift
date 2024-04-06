import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class ViewedVC: UIViewController {

    
    @IBOutlet weak var newsTableView: UITableView!
    
    
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
        
}

    


extension ViewedVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return imageURLArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellViewed", for: indexPath) as? NewsCellViewed else { return UITableViewCell() }
        
        var titles = String()
        var sources = String()
        
        if titleArray.count > 0 {
             titles = titleArray[indexPath.row ]
        } else {
             titles = ""
        }
        
        if newsSourceArray.count > 0 {
            sources = newsSourceArray[indexPath.row]
        } else {
            sources = ""
        }
    
        if imageURLArray.count > 0 {
            
            cell.newsImage.sd_setImage(with: URL(string: imageURLArray[indexPath.row])) { (image, error, cache, urls) in
                if (error != nil) {
                    cell.newsImage.image = UIImage(named: "newsPlaceholder")
                } else {
                    cell.newsImage.image = image
                }
            }
            
        } else {
            cell.newsImage.image = UIImage(named: "newsPlaceholder")!
        }
        
        
        cell.newsImage.layer.cornerRadius = 10
        
        cell.configureCell(newsTitle: titles, newsSource: sources)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let urls = newsStoryUrlArray[(indexPath?.row)!]
    
        UIApplication.shared.open( URL(string: urls)!, options: [:] ) { (success) in
            if success {
                print("open link")
            }
        }
    }
}

extension ViewedVC {
    
    func getNewsData(complete: @escaping (_ status: Bool) -> ()) {
        
        Alamofire.request("https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=0l1QWFx2rTrt0PjzcZYohV9TdqiPiQyz", method: .get).responseJSON { [self] (response) in
            
            guard let value = response.result.value else { return }
            
            let json = JSON(value)
            
            for item in json["results"].arrayValue {
                        
                guard !titleArray.contains(item["title"].stringValue) else { return } //чтобы при переключении экрана не дублировались новости

                self.newsStoryUrlArray.append(item["url"].stringValue)
                self.titleArray.append(item["title"].stringValue)
                self.newsSourceArray.append(item["source"].stringValue)
                self.imageURLArray.append(item["media"][0]["media-metadata"][0]["url"].stringValue)


//                    if item["media"].arrayValue.isEmpty {
//
//                        self.imageURLArray.append("")
//
//                    } else {
//
//                        var flag = false
//
//                        for mediaItem in item["media"].arrayValue {
//
//                            for mediaItemMeta in mediaItem["media-metadata"].arrayValue {
//
//                                if mediaItemMeta["format"] == "Standard Thumbnail" {
//
//                                    self.imageURLArray.append(mediaItemMeta["url"].stringValue)
//
//                                    flag = true
//                                }
//                                //   "format": "Standard Thumbnail"
//                            }
//                            if !flag {
//                                self.imageURLArray.append("") //чтоб не нарушить индексацию по картинкам
//                            }
//
//                        }
//
//                    }
                    
//                    self.newsStoryUrlArray.append(item["url"].stringValue)
                }
            complete(true)
        }
    }
}












