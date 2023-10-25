//
//  PostService.swift
//  WatTheData
//
//  Created by Seth Faxon on 10/25/23.
//

import Foundation
import SwiftData

// Get data from a server and put it in SwiftData for presentation.
@ModelActor
actor PostService {

    func refreshSavingAuthorsFirst() async {
        // imagine this goes to a server to pull post data, rather than just loading it.
        do {
            let jsonDecoder = JSONDecoder()

            let postResources = try jsonDecoder.decode([PostResource].self, from: PostResource.data)

            let createdAuthors = uniqueAuthors(for: postResources)

            for (_, author) in createdAuthors {
                modelContext.insert(author)
                print("author.name after insert: \(author.name)")
            }

            for postResource in postResources {
                let postModel = Post(from: postResource, author: createdAuthors[postResource.author.id]!)

                modelContext.insert(postModel)
            }
            try modelContext.save()
        } catch {
            print("PostService.refreshSavingAuthorsFirst error: \(error.localizedDescription)")
        }
    }

    func uniqueAuthorResources(for postResources: [PostResource]) -> [Int: AuthorResource] {
        var result = [Int: AuthorResource]()
        for postResource in postResources {
            result[postResource.author.id] = postResource.author
        }
        return result
    }

    func uniqueAuthors(for postResources: [PostResource]) -> [Int: Author] {
        return Dictionary(uniqueKeysWithValues: uniqueAuthorResources(for: postResources).map { key, value in
            (key, Author(from: value))
        })
    }
}
