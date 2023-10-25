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
    func refresh() async {
        // imagine this goes to a server to pull post data, rather than just loading it.
        do {
            let jsonDecoder = JSONDecoder()

            let postResources = try jsonDecoder.decode([PostResource].self, from: PostResource.data)

//            modelContext.autosaveEnabled = true
            for postResource in postResources {
                let postModel = Post(from: postResource)
                modelContext.insert(postModel)
            }
            try modelContext.save()
        } catch {
            print("PostService.refresh error: \(error.localizedDescription)")
        }
    }

    // an alternate approach that also fails
    func refreshSavingAuthorsFirst() async {
        // imagine this goes to a server to pull post data, rather than just loading it.
        do {
            let jsonDecoder = JSONDecoder()

            let postResources = try jsonDecoder.decode([PostResource].self, from: PostResource.data)

            let createdAuthors = uniqueAuthors(for: postResources)

//            modelContext.autosaveEnabled = false

            for (_, author) in createdAuthors {
                // DANGER: this is surprising to me: you can call author.name here and it's ok
//                print("author.name before insert: \(author.name)")
//                modelContext.insert(author)
                modelContext.insert(author)
                // but calling author.name after insert crashes
                print("author.name after insert: \(author.name)")
            }

            for postResource in postResources {
//                let descriptor = FetchDescriptor<Author>(predicate: #Predicate { author in
//                    author.remoteId == postResource.author.id
//                })
//                let existingAuthor = try modelContext.fetch(descriptor).first!
//                let existingAuthor = self[createdAuthors[postResource.author.id]!.persistentModelID, as: Author.self]
//                let postModel = Post(from: postResource, author: existingAuthor)
                let postModel = Post(remoteId: postResource.id, title: postResource.title)
                postModel.author = createdAuthors[postResource.author.id]!

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
