//
//  Repo.swift
//  GitHub Search App
//
//  Created by Michael on 5/31/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import Foundation

struct Repo {
    var name : String
    var fullName : String
    var desc : String
    var ownerLogin : String
    var ownerAvatar : String
    var creationDate : String
    var repoURL : String
    var fork : Bool
    var forks : Int
    var stars : Int
}
