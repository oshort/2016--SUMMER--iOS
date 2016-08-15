//
//  Agent.swift
//  NOCList
//
//  Created by Ben Gohlke on 10/12/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class Agent
{
    var realName: String
    var coverName: String
    var accessLevel: Int
    
    init(dictionary: NSDictionary)
    {
        realName = dictionary["realName"] as! String
        coverName = dictionary["coverName"] as! String
        accessLevel = dictionary["accessLevel"] as! Int
    }
}