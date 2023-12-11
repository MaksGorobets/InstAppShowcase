//
//  MessagesView.swift
//  InstAppShowcase
//
//  Created by Maks Winters on 11.12.2023.
//

import SwiftUI

struct MessagesView: View {
    
    let users: [User]
    @State private var search = ""
    
    var body: some View {
            ScrollView {
                TextField("Search", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                ForEach(users) { user in
                    if user.name.lowercased().starts(with: search.lowercased()) {
                        NavigationLink(destination: ChatView(user: user)) {
                            UserMessagesView(user: user)
                                .tint(.primary)
                        }
                    }
                }
                .navigationTitle("Messages")
                .navigationBarTitleDisplayMode(.inline)
            }
    }
}

struct UserMessagesView: View {
    
    let user: User
    
    var body: some View {
            HStack {
                user.profilePicture
                    .resizable()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.system(size: 20, weight: .bold))
                    if !user.messages.isEmpty {
                        Text(user.messages.last!.text)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "camera")
                    .font(.system(size: 25))
            }
            .padding(.horizontal)
            Spacer()
        }
}

#Preview {
    @State var path = NavigationPath()
    return MessagesView(users: [User(name: "Mike", accountLogin: "@mike", bio: "I'm Mike", posts: [], messages: [])])
}
