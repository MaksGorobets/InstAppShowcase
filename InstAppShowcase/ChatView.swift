//
//  ChatView.swift
//  InstAppShowcase
//
//  Created by Maks Winters on 11.12.2023.
//

import SwiftUI

struct IconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .frame(width: 30, height: 30)
            .tint(.primary)
    }
}

extension View {
    func iconify() -> some View {
        modifier(IconModifier())
    }
}

struct ChatView: View {
    
    @State var user: User
    @State private var message = ""
    
    var body: some View {
        ChatViewHeader(user: user)
        ScrollView {
            ForEach(user.messages) { message in
                if message.messageOwner == 1 {
                    HStack {
                        Spacer()
                        MessageBubble(text: message.text, color: .blue)
                    }
                } else {
                    HStack {
                        MessageBubble(text: message.text, color: .gray)
                        Spacer()
                    }
                }
            }
        }
        Spacer()
        HStack {
            TextField("Message...", text: $message, axis: .vertical)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .textFieldStyle(.roundedBorder)
                .frame(height: 50)
            if !message.isEmpty {
                Button("Send") {
                    withAnimation {
                        user.messages.append(Message(messageOwner: 1, text: message))
                        message.removeAll()
                    }
                }
            }
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
    }
}

struct ChatViewHeader: View {
    
    let user: User
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.backward")
            }
            .iconify()
            NavigationLink(destination: ProfilePageView(currentUser: user)) {
                user.profilePicture
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.horizontal, 5)
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.system(size: 20, weight: .bold))
                    Text("Online \(user.lastOnline) min. ago")
                        .foregroundStyle(.secondary)
                }
                .tint(.primary)
            }
            Spacer()
            Image(systemName: "video")
                .iconify()
                .padding(.horizontal)
            Image(systemName: "info.circle")
                .iconify()
        }
        .padding(.horizontal)
        Divider()
    }
}

struct MessageBubble: View {
    
    let text: String
    let color: Color
    
    var body: some View {
            Text(text)
            .padding()
            .foregroundStyle(.white)
            .frame(minWidth: 0, minHeight: 50)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    ChatView(user: User(name: "Mike", accountLogin: "@mike", bio: "I'm Mike", posts: [], messages: [Message(messageOwner: 1, text: "Hello")]))
}
