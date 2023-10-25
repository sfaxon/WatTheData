//
//  Author.swift
//  WatTheData
//
//  Created by Seth Faxon on 10/25/23.
//

import Foundation
import SwiftData

@Model
final class Author {
    @Attribute(.unique)
    let remoteId: Int // don't use id, because it belongs to SwiftData?

    let name: String

    @Relationship(deleteRule: .cascade, inverse: \Post.author)
    var posts: [Post]

    init(remoteId: Int, name: String) {
        self.remoteId = remoteId
        self.name = name
        posts = [] // DANGER
    }

    convenience init(from authorResource: AuthorResource) {
        self.init(remoteId: authorResource.id, name: authorResource.name)
    }
}
