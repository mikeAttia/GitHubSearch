//
//  SearchResultsDelegate.swift
//  GitHub Search App
//
//  Created by Michael on 5/31/17.
//  Copyright © 2017 Michael Atta. All rights reserved.
//

import Foundation

protocol SearchResultsDelegate {
    
    func updateReposlistWith(_ list: [Repo])
    
}
