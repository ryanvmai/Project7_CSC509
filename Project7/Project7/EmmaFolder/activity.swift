//
//  activity.swift
//  Project7
//
//  Created by student on 2/29/20.
//  Copyright © 2020 CSC509. All rights reserved.
//

import Foundation

struct Activity: Codable {
    var activityid: Int
    var name: String
    var time_start: String
    var time_end: String
    var description: String
    var location: String
}
