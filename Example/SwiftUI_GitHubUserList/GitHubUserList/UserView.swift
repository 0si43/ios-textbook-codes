//
//  UserView.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/08/06.
//

import SwiftUI

struct UserView: View {
    let user: User

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .clipShape(.circle)
            } placeholder: {
                ZStack {
                    Circle()
                        .fill(.gray)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.headline)
                Text(String(user.id))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    UserView(
        user: User(login: "login id", id: 1, avatarUrl: "https://picsum.photos/100")
    )
}

