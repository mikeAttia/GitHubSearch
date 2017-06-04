//
//  DetailsViewController.swift
//  GitHub Search App
//
//  Created by Michael on 5/31/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import UIKit
import Kingfisher


class DetailsViewController: UIViewController, ItemSelectedDelegate {
    
    
    
    var currentRepo: Repo?{
        didSet (newRepo) {
           reloadView()
        }
    }
    @IBOutlet var repoFullName: UILabel!
    @IBOutlet var repoDesc: UILabel!
    @IBOutlet var creationDate: UILabel!
    @IBOutlet var forksCount: UILabel!
    @IBOutlet var starsCount: UILabel!
    
    @IBOutlet var overlay: UIView!
    
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var ownerAvatar: UIImageView!
    
    
    @IBAction func goToRepo(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: currentRepo!.repoURL)!, options: ["":""], completionHandler: nil)
        
    }
    
    func reloadView() {
        
        self.title = currentRepo!.name
        
        repoFullName.text = currentRepo!.fullName
        repoDesc.text = currentRepo!.desc
        let ind = currentRepo!.creationDate.index(currentRepo!.creationDate.startIndex, offsetBy: 10)
        
        forksCount.text = String(currentRepo!.forks)
        starsCount.text = String(currentRepo!.stars)
        
        creationDate.text = currentRepo!.creationDate.substring(to: ind)
        ownerName.text = currentRepo!.ownerLogin
        ownerAvatar.kf.setImage(with: URL(string: currentRepo!.ownerAvatar), placeholder: UIImage.init(named: "person.png"), options: nil, progressBlock: nil, completionHandler: nil)
    }

    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    // MARK: - ItemSelectedDelegate methods
    func selectedItem(_ item: Repo){
        
        overlay.isHidden = true
        currentRepo = item
    }
    
    

}
