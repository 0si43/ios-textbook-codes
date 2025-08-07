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
            AsyncImage(url: URL(string: user.imageUrl)) { image in
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
                Text(user.name)
                    .font(.headline)
                Text(user.id)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    UserView(
        user: User(id: "id", name: "Name", imageUrl: "https://picsum.photos/100")
    )
}

