//
//  GitHubAPIClient.swift
//  GitHubUserList
//
//  Created by Nakajima on 2025/09/16.
//

import Foundation

protocol GitHubAPIClient: Sendable {
    func fetchUsers() async throws -> [User]
}

final class GitHubAPIClientImpl: GitHubAPIClient {
    let baseURL = "https://api.github.com"

    @concurrent
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/users") else { return [] }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([User].self, from: data)
    }
}

public enum APIError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "無効なレスポンスです"
        case .httpError(let statusCode):
            return "HTTPエラー: \(statusCode)"
        }
    }
}

#if DEBUG
final class GitHubAPIClientMock: GitHubAPIClient {
    @concurrent func fetchUsers() async throws -> [User] {
        await [User.mock]
    }
}
#endif
