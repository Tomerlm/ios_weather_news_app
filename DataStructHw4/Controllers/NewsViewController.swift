

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class NewsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    typealias jsonCompletionHandler = (_ json: JSON? , _ err: Error?) -> Void
    
    private var headlines: [News] = []
    private var expanded: [ExpandedNews] = []
    
    
    var currentCountry: String = "us"

    
    var didInit: Bool = false
    
    var selectedRowIndex = -1
    var thereIsExpandedCell: Bool = false
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
        didInit = true

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
    
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(NewsViewController.update), userInfo: nil, repeats: true)
    }
    
    @objc func update(){
        progressBar.progress+=0.02
    }
    
    func getNews(){

        headlines = []
        expanded = []

        tableView.isHidden = true
        progressBar.isHidden = false
        startTimer()
        HttpService.sharedInstance.getHeadlines(country: currentCountry){(json , error) in
            if let jsonObj = json{
                
                if(jsonObj["status"] == "error"){
                    self.progressBar.isHidden = true
                    let alert = UIAlertController(title: "Error", message: "Error getting local news, bad request", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        
                    }))
                    self.present(alert , animated: true , completion: nil)
                    print("error getting news")
                }
                else{
                    if let numOfItems = Int(jsonObj["totalResults"].description){

                        var news: News
                        var expanded: ExpandedNews
                        print("number of news items: \(numOfItems)")
                        if(numOfItems > 0){
                            for i in 0...numOfItems-1{
                                news = HttpService.sharedInstance.newsFromJson(jsonObj: jsonObj, i: i)
                                expanded = HttpService.sharedInstance.expandedNewsFromJson(jsonObj: jsonObj, i: i)
                                if (news.description != "null" && news.source != "null"){
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
                print("An error has occured while fetching new: \(String(describing: error))")
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        

    }
    
    func setNewCountryCode(cc: String){
        currentCountry = cc
        if !didInit {
            return
        }
        getNews()
    }
    
    
}
