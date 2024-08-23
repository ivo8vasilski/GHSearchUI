//
//  ContentView.swift
//  GitHubSearchUI
//
//  Created by Ivo Vasilski on 20.08.24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var manager = UsersManager()
    @State private var selectedUser: User?

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search Users", text: $manager.searchQuery)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top)

                // Recent Searches
                if !manager.recentSearches.isEmpty {
                    HStack {
                        Text("Recent Searches:")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(manager.recentSearches, id: \.self) { search in
                                Text(search)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        manager.searchQuery = search
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 5)
                }

                // List of Users
                List(manager.users) { user in
                    HStack {
                        // User Avatar Thumbnail with Increased Size
                        AsyncImage(url: URL(string: user.avatarUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 70, height: 70) // Increased from 50x50 to 70x70
                        .clipShape(Circle())

                        // User Login
                        Text(user.login)
                            .font(.headline)
                    }
                    .onTapGesture {
                        selectedUser = user
                    }
                    .onAppear {
                        manager.loadMoreUsersIfNeeded(currentUser: user)
                    }
                }
                .navigationTitle("GitHub Search")
                .overlay(
                    Group {
                        if manager.isLoading {
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    },
                    alignment: .bottom
                )
                .alert(isPresented: Binding<Bool>(
                    get: { manager.errorMessage != nil },
                    set: { _ in manager.errorMessage = nil }
                )) {
                    Alert(
                        title: Text("Error"),
                        message: Text(manager.errorMessage ?? "Unknown error"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .sheet(item: $selectedUser) { user in
                UserDetailView(user: user)
            }
        }
    }
}



