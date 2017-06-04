//
//  Persistence.swift
//  GitHub Search App
//
//  Created by Michael on 5/31/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Persistence {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity: NSEntityDescription?{
        return NSEntityDescription.entity(forEntityName: "RepoEntity", in: context)
    }
    
    ///Call to persist a list of Repos
    func persistReposList(_ repos: [Repo]) {
        
        var repoObj: NSManagedObject
        for repo in repos {
            repoObj = NSManagedObject(entity: self.entity!, insertInto: self.context)
            repoObj.setValue(repo.name, forKey: "name")
            repoObj.setValue(repo.fullName, forKey: "fullName")
            repoObj.setValue(repo.ownerLogin, forKey: "ownerLogin")
            repoObj.setValue(repo.ownerAvatar, forKey: "ownerAvatar")
            repoObj.setValue(repo.repoURL, forKey: "repoURL")
            repoObj.setValue(repo.creationDate, forKey: "creationDate")
            repoObj.setValue(repo.desc, forKey: "desc")
            repoObj.setValue(repo.fork, forKey: "fork")
        }
        
        do{
            try context.save()
        }catch{
            print("Couldn't persist Repos Data")
        }
    }
    
    ///Call to delete all persisted Data
    func purgeData() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RepoEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let err as NSError{
            print ("Couldn't Purge Core Data records")
            print("Error: \(err)")
        }
    }
    
    ///Call to get a list of Cached Repos
    func getCachedData() -> [Repo] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepoEntity")
        var repos = [Repo]()
        do{
            let reposEnt = try context.fetch(fetchRequest)
            
            for repo in reposEnt {
                
                repos.append(Repo(name: repo.value(forKey: "name") as! String,
                                  fullName: repo.value(forKey: "fullName") as! String,
                                  desc: repo.value(forKey: "desc") as! String,
                                  ownerLogin: repo.value(forKey: "ownerLogin") as! String,
                                  ownerAvatar: repo.value(forKey: "ownerAvatar") as! String,
                                  creationDate: repo.value(forKey: "creationDate") as! String,
                                  repoURL: repo.value(forKey: "repoURL") as! String,
                                  fork: repo.value(forKey: "fork") as! Bool,
                                  forks: repo.value(forKey: "forks") as! Int,
                                  stars: repo.value(forKey: "stars") as! Int
                                )
                )
                
            }
            
            
        }catch let err as NSError{
            print ("Couldn't Get cached Data")
            print("Error: \(err)")
        }
        return repos
    }
    

}
