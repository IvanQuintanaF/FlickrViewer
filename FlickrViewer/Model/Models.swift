//
//  Models.swift
//  FlickrViewer
//
//  Created by Ivan Quintana on 10/03/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation

struct FlickrResult: Codable {
    var photos: Photos
}

struct Photos: Codable {
    var pages: Int
    var photo: [Photo]
}

struct Photo: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}
