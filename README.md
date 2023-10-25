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
