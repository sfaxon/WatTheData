# WatTheData

A sample app using SwiftData that replicates a parsing server data for local caching.
The twist is that I want to cache the local data with a one to many relationship. The
Post model has one Author, but as far as I can tell, SwiftData forces me to setup the
inverse relationship so that each Author has many Posts.

There are some comments in the code with DANGER that should be looked at. The Author
model currently assumes `posts = []`.

The bulk of the work is in the PostService class.

It's worth noting that modelContext.autosaveEnabled defaults to true. I've had some
success setting it to false in PostService and then explicitly bulk saving in a few
places.

This is relying on some SwiftData magic, specifically: 

    SwiftData checks if the specified earthquake’s code parameter matches the code of
    an earthquake that’s already in the store. If so, the framework updates the stored
    earthquake’s other parameters using the values in the specified one. Otherwise,
    the framework adds a new earthquake to the store.

From https://developer.apple.com/documentation/swiftdata/maintaining-a-local-copy-of-server-data#Insert-or-update-new-earthquake-data

I think the conflict is that when parsing the server data, there may or may not be
an instance of the Author record. If it's creating the Author, it sets the author.posts
to be an empty array. But, then the post creation doesn't know how to associate the
Author.
