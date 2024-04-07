import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

class FavoritesVC: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    var newsData = [NewsData]()
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        //newsData = fetch()
        
        self.newsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newsData = fetch()
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

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCellFavorites", for: indexPath) as? NewsCellFavorites else { return UITableViewCell() }
        
        cell.newsTitle.text = newsData[indexPath.row].title
        cell.newsSource.text = newsData[indexPath.row].source
        cell.newsImage.sd_setImage(with: URL(string: newsData[indexPath.row].image!))
        cell.newsImage.layer.cornerRadius = 10
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: newsData[indexPath.row].link!)!) { success in
            if success {
                print("link open favorites")
            }
        }
    }
}
       
