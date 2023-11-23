//
//  ContentView.swift
//  Moonshot
//
//  Created by Maks Winters on 23.11.2023.
//

import SwiftUI

struct User: Identifiable {
    static var existingLogins: Set<String> = []
    
    var id = UUID()
    var profilePicture: Image = Image(.nopp)
    var name: String
    var accountLogin: String
    var bio: String
    var followers = 0
    var following = 0
    var posts: [Post]
    
    init(name: String, accountLogin: String, bio: String, posts: [Post]) {
        if User.existingLogins.contains(accountLogin) {
            fatalError("This name is already taken")
        }
        
        User.existingLogins.insert(accountLogin)
        
        self.name = name
        self.accountLogin = accountLogin
        self.bio = bio
        self.posts = posts
    }
}

struct Post: Identifiable {
    var id = UUID()
    var image: String
    var liked: Bool = false
}

struct ContentView: View {
    
    @State var users: [User] = [
        User(name: "Alice", accountLogin: "@alice", bio: "I love photography!", posts: [Post(image: "defaultPhoto")]),
        User(name: "Bob", accountLogin: "@bob", bio: "Exploring the world one post at a time.", posts: [Post(image: "defaultPhoto")]),
        User(name: "Charlie", accountLogin: "@charlie", bio: "Foodie and travel enthusiast.", posts: [Post(image: "defaultPhoto")]),
        User(name: "David", accountLogin: "@david", bio: "Coding and coffee addict.", posts: [Post(image: "defaultPhoto")]),
        User(name: "Eva", accountLogin: "@eva", bio: "Nature lover and adventurer.", posts: [Post(image: "defaultPhoto")]),
        User(name: "Frank", accountLogin: "@frank", bio: "Art and music are my passions.", posts: [Post(image: "defaultPhoto")]),
        User(name: "Grace", accountLogin: "@grace", bio: "Spreading positivity through my posts.", posts: [Post(image: "defaultPhoto")]),
        User(name: "Henry", accountLogin: "@henry", bio: "Tech geek with a sense of humor.", posts: [Post(image: "defaultPhoto")]),
        User(name: "Ivy", accountLogin: "@ivy", bio: "Bookworm and cat person.", posts: [Post(image: "defaultPhoto")]),
        User(name: "Jack", accountLogin: "@jack", bio: "Fitness freak and health advocate.", posts: [Post(image: "defaultPhoto")])
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                ForEach(0..<users.count, id: \.self) { number in
                    LazyVStack {
                        HStack {
                            NavigationLink {
                                ProfilePageView(currentUser: users[number])
                            } label: {
                                users[number].profilePicture
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .scaledToFit()
                                    .clipShape(Circle())
                            }
                            Text(users[number].name)
                            Spacer()
                        }
                        .padding()
                        Image(users[number].posts[0].image)
                            .resizable()
                            .scaledToFit()
                            HStack {
                                Image(systemName: users[number].posts[0].liked ? "heart.fill" : "heart")
                                    .animation(.easeIn, value: users[number].posts[0].liked)
                                    .onTapGesture {
                                            users[number].posts[0].liked.toggle()
                                    }
                                    .foregroundStyle(users[number].posts[0].liked ? .red : .primary)
                                Image(systemName: "message")
                                Image(systemName: "paperplane")
                                Spacer()
                            }
                            .font(.system(size: 25))
                            .padding(10)
                    }
                }
            }
                .navigationTitle("Landscape.app")
        }
    }
}

#Preview {
    ContentView()
}
