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
        
        self.newsTableView.reloadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        newsData = fetch()
//        newsTableView.reloadData()
//    }
//    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    func delete(item: NewsData) {
        context.delete(item)
        
        do {
            try context.save()
            print("successfully deleted")
            newsTableView.reloadData()
        } catch {
            print("Could not deleted")
        }
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
        cell.newsImage.sd_setImage(with: URL(string: newsData[indexPath.row].image ?? "" ))
        cell.newsImage.layer.cornerRadius = 10

        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: newsData[indexPath.row].link ?? "")!) { success in
            if success {
                print("link open favorites")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title:  "Remove", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
             print("OK, marked as Removed")
            self.delete(item: self.newsData[indexPath.row])
         })
         closeAction.backgroundColor = .red
         return UISwipeActionsConfiguration(actions: [closeAction])
    }
}
       
