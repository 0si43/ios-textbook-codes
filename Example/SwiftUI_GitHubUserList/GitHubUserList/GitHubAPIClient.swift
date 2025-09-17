//
//  GitHubAPIClient.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/09/16.
//

import Foundation

final class GitHubAPIClient {
    let baseURL = "https://api.github.com"
    
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/users") else { fatalError("confirm usersURL") }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        // FIXME: - responseに対するエラーハンドリング
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([User].self, from: data)
    }
}
