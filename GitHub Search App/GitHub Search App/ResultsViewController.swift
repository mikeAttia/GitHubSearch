//
//  ResultsViewController.swift
//  GitHub Search App
//
//  Created by Michael on 5/31/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchResultsDelegate {
    
    // MARK: - Properties
    var reposList = [Repo]()
    let dataSource : ReposData = ReposData()
    var fetchingData = false
    
    //Detail View delegate
    var detailDelegate : ItemSelectedDelegate?

    //UIViews Outlets
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet var searchField: UITextField!
    
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTable.delegate = self
        resultsTable.dataSource = self
        
        //Observing finishedFetchingData notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateFetchingStatus), name: NSNotification.Name("finishedFetchingData"), object: nil)
        
        //adding KVO observer on repos list
        self.addObserver(self, forKeyPath: "reposList", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        //Getting and showing cached data if any
        if let q = (UserDefaults.standard.value(forKey: "query")) as? String{
            print(q)
            let pageCount = UserDefaults.standard.value(forKey: "nextPage") as! Int
            searchField.text = q
            dataSource.showCachedDataForQuery(q, nextPage:pageCount ,delegate: self)
        }
    }
    
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(reposList.count)
        return reposList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoCustomCell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! RepoCustomCell
        cell.repo = reposList[indexPath.row]
        // Configure the cell...
        print(indexPath.row)
        if indexPath.row == reposList.count-1 && !fetchingData {
            print("calling getnextpage")
            fetchingData = true
            dataSource.getNextPage(count: 10, delegate: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailDelegate?.selectedItem(reposList[indexPath.row])
        
        if let splitView = self.parent?.parent as? UISplitViewController{
            splitView.showDetailViewController(
                (detailDelegate as? DetailsViewController)!.navigationController!,
                sender: Any?.self
            )
        }
        
    }
    
    
    
    // MARK: - View Actions
    @IBAction func search(_ sender: UIButton) {
        self.view.endEditing(true)
        reposList = []
        resultsTable.reloadData()
        print("Searching for data ...")
        dataSource.searchFor(searchField.text!, count: 10, delegate: self)
    }
    
    
    func updateFetchingStatus(notification: NSNotification) {
        fetchingData = false
        print("Finished fetching data \(!fetchingData)")
    }
    
    
    // MARK: - SearchResultsDelegate
    func updateReposlistWith(_ list: [Repo]) {
        reposList.append(contentsOf: list)
        print("will reload table")
        resultsTable.reloadData()
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
