import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

@available(iOS 14.0, *)
class FavoritesVC: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    

    
    var newsData2 = [NewsData]()
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    lazy var newsData = NewsData(context: context)
    

    
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
        newsData2 = fetch()
        newsTableView.reloadData()
    }
    
    func fetch() -> [NewsData] {
        var newsData = [NewsData]()
        do {
            newsData =
                try context.fetch(NewsData.fetchRequest())
        } catch {
            print("couldnt fetch")
        }
        return newsData
    }
}

    


@available(iOS 14.0, *)
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return imageURLArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellFavorites", for: indexPath) as? NewsCellFavorites else { return UITableViewCell() }
        
        let news = newsData2[indexPath.row]
        
        var content1 = cell.defaultContentConfiguration()
        var content2 = cell.defaultContentConfiguration()
        var content3 = cell.defaultContentConfiguration()
        var content4 = cell.defaultContentConfiguration()

        content1.text = news.title
        content2.text = news.source
        content3.text = news.image
        content4.text = news.link
        
        cell.contentConfiguration = content1
        cell.contentConfiguration = content2
        cell.contentConfiguration = content3
        cell.contentConfiguration = content4
        
        cell.newsTitle.text = news.title
        cell.newsTitle.text = "sacfsafe"


        
        var titles = String()
        var sources = String()
//        
        if titleArray.count > 0 {
            titles = content1.text ?? ""
        } else {
             titles = ""
        }
        
        if newsSourceArray.count > 0 {
            sources = content2.text ?? ""
        } else {
            sources = ""
        }
//    
//        if imageURLArray.count > 0 {
//            
//            cell.newsImage.sd_setImage(with: URL(string: imageURLArray[indexPath.row])) { (image, error, cache, urls) in
//                if (error != nil) {
//                    cell.newsImage.image = UIImage(named: "newsPlaceholder")
//                } else {
//                    cell.newsImage.image = image
//                }
//            }
//            
//        } else {
//            cell.newsImage.image = UIImage(named: "newsPlaceholder")!
//        }
        
        
        cell.newsImage.layer.cornerRadius = 10
        
       // cell.configureCell(newsTitle: titles, newsSource: sources)
        
        return cell
    }
//    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell1 = newsTableView.dequeueReusableCell(withIdentifier: "newsCellFavorites", for: indexPath) as? NewsCellFavorites else { return UITableViewCell() }
//        let news = newsData2[indexPath.row]
//
//        let indexPath = tableView.indexPathForSelectedRow
//        
//        var content4 = cell1.defaultContentConfiguration()
//        content4.text = news.link
//
//        let urls = content4
//        cell1.contentConfiguration = content4
//        return cell1


//        UIApplication.shared.open( URL(string: urls)!, options: [:] ) { (success) in
//            if success {
//                print("open link")
//            }
//        }
 //   }
}

