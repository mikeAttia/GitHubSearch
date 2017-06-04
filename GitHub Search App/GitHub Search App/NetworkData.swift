//
//  NetworkData.swift
//  GitHub Search App
//
//  Created by Michael on 5/31/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import Foundation
import Alamofire


class NetWorkData {
    
    private let urlBase = "https://api.github.com/search/repositories?"
    
    // a URL builder to customize the request URL
    private func buildUrl(query: String!, count: Int!, page: Int!) -> String{
        return "\(urlBase)q=\(query!)&sort=stars&order=desc&page=\(page!)&per_page=\(count!)"
    }
    
    
    func getPage(_ pageNum: Int ,forQuery q: String, resultsCount: Int,delegate: SearchResultsDelegate, cacher: Persistence) {
        
        //building URL based on arguments
        let requestUrl = buildUrl(query: q, count: resultsCount, page: pageNum)
        print(requestUrl)
        
        //Network request to get data from web service
        Alamofire.request(requestUrl).responseJSON { response in
            print("Network Callback")
            print(response.error ?? "NO error")
            
            //parsing JSON and updating delegate
            if let JSON = response.result.value {
                let parser = JsonParser.getParser()
                let repos = parser.parseJson(json: JSON as! Dictionary<String, Any>)
                if repos.count > 0 {
                    delegate.updateReposlistWith(repos)
                }
                
                //Posting notification finishedFetchingData
                NotificationCenter.default.post(name: NSNotification.Name("finishedFetchingData"), object: nil)
                
                //Persisting Data
                if pageNum == 1{
                    cacher.purgeData()
                }
                cacher.persistReposList(repos)
                
            }
        }
    }

    
}
