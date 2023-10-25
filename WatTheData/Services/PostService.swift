//
//  PostService.swift
//  WatTheData
//
//  Created by Seth Faxon on 10/25/23.
//

import Foundation
import SwiftData

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
}
