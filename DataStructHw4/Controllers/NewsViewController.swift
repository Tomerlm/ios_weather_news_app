

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class NewsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    typealias jsonCompletionHandler = (_ json: JSON? , _ err: Error?) -> Void
    
    private var headlines: [News] = []
    private var expanded: [ExpandedNews] = []
    
    
    var currentCountry: String = ""
    
    var selectedRowIndex = -1
    var thereIsExpandedCell: Bool = false
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        progressBar.isHidden = false
        startTimer()
        getHeadlines(country: currentCountry){(json , error) in
            if let jsonObj = json{
                
                if(jsonObj["status"] == "error"){
                    self.progressBar.isHidden = true
                    let alert = UIAlertController(title: "Error", message: "Error getting local news, bad request", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        self.performSegue(withIdentifier: "newsToMainSegue", sender: self)
                        
                    }))
                    self.present(alert , animated: true , completion: nil)
                    print("error getting news")
                }
                else{
                    if let numOfItems = Int(jsonObj["totalResults"].description){
                        var description = ""
                        var source = ""
                        var urlToImageString = ""
                        var content = ""
                        var webUrl = ""
                        var news: News
                        var expanded: ExpandedNews
                        print("number of news items: \(numOfItems)")
                        if(numOfItems > 0){
                            for i in 0...numOfItems-1{
                                description = jsonObj["articles"][i]["title"].description
                                source = jsonObj["articles"][i]["source"]["name"].description
                                urlToImageString = jsonObj["articles"][i]["urlToImage"].rawString()!
                                content = jsonObj["articles"][i]["description"].rawString()!
                                webUrl = jsonObj["articles"][i]["url"].rawString()!
                                news = News(headline: source , description: description , imageUrl: urlToImageString , webUrl: webUrl)
                                expanded = ExpandedNews(headline: source, description: content, imageUrl:urlToImageString, webUrl: webUrl)
                                if (description != "null" && source != "null"){
                                    self.headlines.append(news)
                                    self.expanded.append(expanded)
                                }
                        
                            }
                        }
                        
                    }
                    self.tableView.layoutIfNeeded()
                    self.progressBar.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
            }
                
            }
            else{
                print("An error has occured while fetching new: \(error)")
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension


    }
    @IBAction func backToMainBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "newsToMainSegue", sender: self)
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NewsTableViewCell
        
         let news = headlines[indexPath.row]
        
        cell.news = news
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
            let news = self.headlines[indexPath.row]
            
            cell.news = news
        }

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        let expanded = self.expanded[indexPath.row].description
        
        cell.newsDescriptionLabel?.text = expanded
        self.tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.gray
        
        // avoid paint the cell if the index is outside the bounds
        if self.selectedRowIndex != -1 {
            self.tableView.cellForRow(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath)?.backgroundColor = UIColor.white
        }
        
        if selectedRowIndex != indexPath.row {
            self.thereIsExpandedCell = true
            self.selectedRowIndex = indexPath.row
        }
        else if(self.thereIsExpandedCell && self.selectedRowIndex == indexPath.row){
            cell.news = headlines[indexPath.row]
            self.thereIsExpandedCell = false
            self.tableView.cellForRow(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath)?.backgroundColor = UIColor.white
            self.selectedRowIndex = -1
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func getHeadlines(country: String , completionHandler: @escaping jsonCompletionHandler){
        let url = "https://newsapi.org/v2/top-headlines?country=" + country + "&apiKey=c74d38e1bf1742b8b568cf30acbbb0b8"
        Alamofire.request(url).responseJSON{ (response) in
            switch response.result{
            case .success(let data):
                let jsonData = JSON(data)
                completionHandler(jsonData, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(NewsViewController.update), userInfo: nil, repeats: true)
    }
    
    @objc func update(){
        progressBar.progress+=0.02
    }
}
