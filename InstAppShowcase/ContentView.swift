//
//  ContentView.swift
//  Moonshot
//
//  Created by Maks Winters on 23.11.2023.
//

import SwiftUI

@Observable
class User: Identifiable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.name == lhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static var existingLogins: Set<String> = []
    static let replies = ["Can't reply right now.", "Okay", "Maybe", "Yes", "No"]
    
    var id = UUID()
    var profilePicture: Image = Image(.nopp)
    var name: String
    let lastOnline = Int.random(in: 0...60)
    var accountLogin: String
    var bio: String
    var followers = 0
    var following = 0
    var posts: [Post]
    var messages: [Message] { didSet {
        if messages.last?.messageOwner == 1 {
            messages.append(Message(messageOwner: 2, text: User.replies.randomElement() ?? ""))
        }
    }}
    
    init(name: String, accountLogin: String, bio: String, posts: [Post], messages: [Message]) {
        if User.existingLogins.contains(accountLogin) {
            fatalError("This name is already taken")
        }
        
        User.existingLogins.insert(accountLogin)
        
        self.name = name
        self.accountLogin = accountLogin
        self.bio = bio
        self.posts = posts
        self.messages = messages
    }
}

struct Message: Identifiable, Hashable {
    let id = UUID()
    let messageOwner: Int
    let text: String
    var reaction = ""
}

struct Post: Identifiable, Hashable {
    var id = UUID()
    var image: String
    var liked: Bool = false
}

struct ContentView: View {
    
    @State private var users: [User] = [
        User(name: "Alice", accountLogin: "@alice", bio: "I love photography!", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Bob", accountLogin: "@bob", bio: "Exploring the world one post at a time.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Charlie", accountLogin: "@charlie", bio: "Foodie and travel enthusiast.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "David", accountLogin: "@david", bio: "Coding and coffee addict.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Eva", accountLogin: "@eva", bio: "Nature lover and adventurer.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Frank", accountLogin: "@frank", bio: "Art and music are my passions.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Grace", accountLogin: "@grace", bio: "Spreading positivity through my posts.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Henry", accountLogin: "@henry", bio: "Tech geek with a sense of humor.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Ivy", accountLogin: "@ivy", bio: "Bookworm and cat person.", posts: [Post(image: "defaultPhoto")], messages: []),
        User(name: "Jack", accountLogin: "@jack", bio: "Fitness freak and health advocate.", posts: [Post(image: "defaultPhoto")], messages: [])
    ]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                StoriesScrollView(users: users)
                ForEach(users) { user in
                    LazyVStack {
                        HStack {
                            NavigationLink(value: user) {
                                user.profilePicture
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .scaledToFit()
                                    .clipShape(Circle())
                            }
                            Text(user.name)
                            Spacer()
                        }
                        .padding()
                        Image(user.posts[0].image)
                            .resizable()
                            .scaledToFit()
                        HStack {
                            Image(systemName: user.posts[0].liked ? "heart.fill" : "heart")
                                .animation(.easeIn, value: user.posts[0].liked)
                                .onTapGesture {
                                    user.posts[0].liked.toggle()
                                }
                                .foregroundStyle(user.posts[0].liked ? .red : .primary)
                            Image(systemName: "message")
                            Image(systemName: "paperplane")
                            Spacer()
                        }
                        .font(.system(size: 25))
                        .padding(10)
                    }
                }
                .navigationDestination(for: User.self, destination: { user in
                    ProfilePageView(currentUser: user)
                })
            }
            .toolbar {
                NavigationLink {
                    MessagesView(users: users)
                } label: {
                    Image(systemName: "message")
                        .tint(.primary)
                }
            }
            .navigationTitle("Landscape.app")
        }
    }
}

struct StoriesScrollView: View {
    
    let users: [User]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 15) {
                ForEach(users) { user in
                    user.profilePicture
                        .resizable()
                        .frame(width: 80, height: 80)
                        .scaledToFit()
                        .clipShape(Circle())
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}
