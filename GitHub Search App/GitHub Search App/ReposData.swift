//
//  ReposData.swift
//  GitHub Search App
//
//  Created by Michael on 5/31/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import Foundation

class ReposData {
    
    private lazy var cachedData = Persistence()
    private lazy var data  = NetWorkData()
    private var showingCachedData = true
    private var nextPage = 1
    private var query = ""
    private var resultsCount = 0
    
    // overriding initializer to observer Resluts_Total_Count notification
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalCount), name: NSNotification.Name("Resluts_Total_Count"), object: nil)
    }
    
    ///Call to search for a query
    func searchFor(_ q: String,count: Int ,delegate: SearchResultsDelegate){
        showingCachedData = false
        query = q
        UserDefaults.standard.setValue(q, forKey: "query")
        nextPage = 1
        
        getNextPage(count: count, delegate: delegate)
    }
    
    ///Call to get the next page of results
    func getNextPage(count: Int ,delegate: SearchResultsDelegate) {
        print("getting data for q=\(query)")
        data.getPage(nextPage, forQuery: query, resultsCount: count, delegate: delegate, cacher: cachedData)
    }
    
    // callback to Resluts_Total_Count notification to update page no. and results count
    @objc func updateTotalCount(notification: NSNotification) {
        resultsCount = (notification.userInfo?["totalCount"] as? Int)!
        nextPage += 1
        UserDefaults.standard.set(nextPage, forKey: "nextPage")
    }
    
    ///Call to get the cached data
    func showCachedDataForQuery(_ q: String, nextPage page:Int , delegate: SearchResultsDelegate){
        query = q
        delegate.updateReposlistWith(cachedData.getCachedData())
    }
    
    //Overriding deinit to unregister observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
