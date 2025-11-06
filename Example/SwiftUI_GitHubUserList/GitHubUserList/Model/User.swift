//
//  User.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/08/06.
//

struct User: Codable, Hashable, Identifiable {
    let login: String
    let id: Int
    let avatarUrl: String
    let htmlUrl: String
}

#if DEBUG
extension User {
    static var mock: User {
        User(login: "login id", id: 1, avatarUrl: "https://picsum.photos/100", htmlUrl: "https://github.com/mojombo")
    }
}
#endif
