//
//  ProfilePageView.swift
//  Moonshot
//
//  Created by Maks Winters on 23.11.2023.
//

import SwiftUI

struct ProfilePageView: View {
    
    var currentUser: User
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack(spacing: 15) {
                            currentUser.profilePicture
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                            VStack {
                                Text("Posts")
                                Text(String(currentUser.posts.count))
                            }
                            VStack {
                                Text("Followers")
                                Text(String(currentUser.followers))
                            }
                            VStack {
                                Text("Following")
                                Text(String(currentUser.following))
                            }
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text(currentUser.name)
                                .font(.system(size: 15, weight: .heavy))
                            Text(currentUser.bio)
                        }
                        .padding(.horizontal)
                        LazyVGrid(columns: columns) {
                            ForEach(0..<currentUser.posts.count, id: \.self) { post in
                                Image(currentUser.posts[post].image)
                                    .resizable()
                                    .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                            }
                        }
                    }
                    Spacer()
                }
            }
                .navigationTitle(currentUser.accountLogin)
            }
        }
    }

#Preview {
    ProfilePageView(currentUser: User(name: "Alice", accountLogin: "alice@instagram", bio: "I love photography!", posts: [Post(image: "defaultPhoto")]))
}
