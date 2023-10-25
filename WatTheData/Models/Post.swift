//
//  Post.swift
//  WatTheData
//
//  Created by Seth Faxon on 10/25/23.
//

import Foundation
import SwiftData

@Model
final class Post {
    @Attribute(.unique)
    let remoteId: Int // don't use id, because it belongs to SwiftData?

    let title: String
    let author: Author

    init(remoteId: Int, title: String, author: Author) {
        self.remoteId = remoteId
        self.title = title
        self.author = author
    }

    convenience init(from postResource: PostResource) {
        let author = Author(from: postResource.author)
        self.init(remoteId: postResource.id, title: postResource.title, author: author)
    }

    convenience init(from postResource: PostResource, author: Author) {
        self.init(remoteId: postResource.id, title: postResource.title, author: author)
    }
}
