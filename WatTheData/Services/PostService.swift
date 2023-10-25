//
//  PostService.swift
//  WatTheData
//
//  Created by Seth Faxon on 10/25/23.
//

import Foundation
import SwiftData

// Get data from a server and put it in SwiftData for presentation.
class PostService: ObservableObject {
    func refresh(modelContext: ModelContext) async {
        // imagine this goes to a server to pull post data, rather than just loading it.
        do {
            let jsonDecoder = JSONDecoder()

            let postResources = try jsonDecoder.decode([PostResource].self, from: PostResource.data)

            for postResource in postResources {
                let postModel = Post(from: postResource)
                modelContext.insert(postModel)
            }
        } catch {
            print("PostService.refresh error: \(error.localizedDescription)")
        }
    }
    
    // an alternate approach that also fails
    func refreshSavingAuthorsFirst(modelContext: ModelContext) async {
        // imagine this goes to a server to pull post data, rather than just loading it.
        do {
            let jsonDecoder = JSONDecoder()

            let postResources = try jsonDecoder.decode([PostResource].self, from: PostResource.data)
            
            for (_, author) in uniqueAuthors(for: postResources) {
                // DANGER: this is surprising to me: you can call author.name here and it's ok
//                print("author.name before insert: \(author.name)")
                modelContext.insert(author)
                // but calling author.name after insert crashes
//                print("author.name after insert: \(author.name)")
            }

            for postResource in postResources {
                let postModel = Post(from: postResource)
                modelContext.insert(postModel)
            }
        } catch {
            print("PostService.refresh error: \(error.localizedDescription)")
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
