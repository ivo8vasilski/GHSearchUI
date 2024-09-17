//
//  Manager.swift
//  GitHubSearchUI
//
//  Created by Ivo Vasilski on 20.08.24.
//

import SwiftUI
import Combine

class UsersState: ObservableObject {
    // MARK: - Published Properties
    @Published var users: [User] = []
    @Published var searchQuery: String = "" {
        didSet {
            if !searchQuery.isEmpty && !recentSearches.contains(searchQuery) {
                saveSearchQuery(searchQuery)
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var recentSearches: [String] = []

    // MARK: - Private Properties
    private var currentPage: Int = 1
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch()
            }
            .store(in: &cancellables)
        
        loadRecentSearches()
    }

    // MARK: - Public Methods
    func performSearch() {
        guard !searchQuery.isEmpty else {
            users = []
            return
        }

        isLoading = true
        errorMessage = nil
        currentPage = 1
        users.removeAll()

        fetchUsers(query: searchQuery, page: currentPage) { [weak self] (result: Result<GHResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.users = response.items
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreUsersIfNeeded(currentUser: User) {
        guard let lastUser = users.last, lastUser.id == currentUser.id else { return }
        currentPage += 1
        isLoading = true

        fetchUsers(query: searchQuery, page: currentPage) { [weak self] (result: Result<GHResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.users.append(contentsOf: response.items)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Private Methods
    private func fetchUsers(query: String, page: Int, completion: @escaping (Result<GHResponse, Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/search/users?q=\(query)&page=\(page)&per_page=10") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
            
        }
        

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let token = "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"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let jsonData = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodeData = try decoder.decode(GHResponse.self, from: jsonData)
                completion(.success(decodeData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func saveSearchQuery(_ query: String) {
        recentSearches.append(query)
        if recentSearches.count > 5 {  // Keep only the last 5 searches
            recentSearches.removeFirst()
        }
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }

    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] ?? []
    }
    
    
    
}
