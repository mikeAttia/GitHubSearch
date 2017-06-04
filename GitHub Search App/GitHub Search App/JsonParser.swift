//
//  JsonParser.swift
//  GitHub Search App
//
//  Created by Michael on 6/1/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import Foundation

class JsonParser {
    private static let parser = GitHubJsonParser()
    
    ///Call to get a JSON parser instance
    static func getParser()->JsonParser{
        return parser
    }
    
    ///Call to get the parsed list of Repos
    func parseJson(json: Dictionary<String, Any>) -> [Repo]{
        return [Repo]()
    }
    
    //the GitHub JSON parse to parse the APIs JSON
    private class GitHubJsonParser: JsonParser {
        
        override func parseJson(json: Dictionary<String, Any>) -> [Repo] {
            var repos = [Repo]()
            let totalCount = json["total_count"]
            //Send notification with the total Repos Count
            NotificationCenter.default.post(name: NSNotification.Name("Resluts_Total_Count"), object: nil, userInfo: ["totalCount" : totalCount ?? 0])
            
            
            if let items = json["items"] as? Array<Dictionary<String, Any>>{
                
                for item in items {
                    
                    let owner = item["owner"] as! Dictionary<String, Any>
                    var desc : String?
                    
                    
                    //If description is null, set it to "No Description"
                    if (item["description"] as? NSNull) != nil {
                        desc = "No Description"
                    }
                    
                    if let jsonVal = item["description"] as? String {
                        desc = jsonVal
                    }
                    
                    let repo = Repo(name: item["name"] as! String,
                                   fullName: item["full_name"] as! String,
                                   desc: desc!,
                                   ownerLogin: owner["login"] as! String,
                                   ownerAvatar: owner["avatar_url"] as! String,
                                   creationDate: item["created_at"] as! String,
                                   repoURL: item["html_url"] as! String,
                                   fork: item["fork"] as! Bool,
                                   forks: item["forks_count"] as! Int,
                                   stars: item["stargazers_count"] as! Int)
                    
                    repos.append(repo)
                }
            }
            
            return repos
        }
        
    }
}
