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
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            throw HTTPResponseError()
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([User].self, from: data)
    }
}

struct HTTPResponseError: LocalizedError {
    var errorDescription: String? {
        "HTTPレスポンスが正常ではありません"
    }
}
