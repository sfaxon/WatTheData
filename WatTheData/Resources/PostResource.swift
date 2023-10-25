//
//  PostResource.swift
//  WatTheData
//
//  Created by Seth Faxon on 10/25/23.
//

import Foundation

// Mock server data
struct PostResource: Codable {
    static let dataString: String = """
    [
       {
          "id":1,
          "title":"Post 1",
          "author":{
             "id":1,
             "name":"Author A"
          }
       },
       {
          "id":2,
          "title":"Post 2",
          "author":{
             "id":2,
             "name":"Author B"
          }
       },
       {
          "id":3,
          "title":"Post 3",
          "author":{
             "id":2,
             "name":"Author B"
          }
       }
    ]
    """

    static var data: Data {
        return Data(dataString.utf8)
    }

    let id: Int
    let title: String
    let author: AuthorResource
}
