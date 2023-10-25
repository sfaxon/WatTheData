//
//  ContentView.swift
//  WatTheData
//
//  Created by Seth Faxon on 10/25/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var postService = PostService()
    @Query private var posts: [Post]

    var body: some View {
        List {
            ForEach(posts) { post in
                HStack {
                    Text(post.title)
                    Spacer()
                    // Text(post.author.name) // DANGER uncomment this and the app crashes
                }
            }
        }
        .task {
//            await postService.refresh(modelContext: modelContext)
            await postService.refreshSavingAuthorsFirst(modelContext: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Post.self, inMemory: true)
}
