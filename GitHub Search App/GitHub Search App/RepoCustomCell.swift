//
//  RepoCustomCell.swift
//  GitHub Search App
//
//  Created by Michael on 6/1/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import UIKit

class RepoCustomCell: UITableViewCell {

    @IBOutlet var repoName: UILabel!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var details: UILabel!
    
    var repo : Repo! {
        didSet(newValue){
            loadView()
        }
    }
    
    private func loadView(){
        repoName.text = repo.name
        ownerName.text = repo.ownerLogin
        details.text = repo.desc
        if repo!.fork {
            self.backgroundColor = UIColor.gray
        }
    }

}
