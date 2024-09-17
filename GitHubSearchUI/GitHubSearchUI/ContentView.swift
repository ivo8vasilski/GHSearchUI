import SwiftUI

struct ContentView: View {
    @StateObject private var manager = UsersState()
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

                // Handle the error outside the ViewBuilder
                if let errorMessage = manager.errorMessage {
                    ErrorView(errorMessage: errorMessage)
                } else {
                    List(manager.users) { user in
                        HStack {
                            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())

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
                }
            }
            .navigationTitle("GitHub Search") // Apply navigationTitle to a view inside NavigationView
            .overlay(
                Group {
                    if manager.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                },
                alignment: .bottom
            )
            .sheet(item: $selectedUser) { user in
                UserDetailView(user: user)
            }
        }
    }
}


enum UserError: Error {
    case fetchFailed(String)
}


struct ErrorView: View {
    let errorMessage: String

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
                .padding()

            Text("Oops, something went wrong!")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 5)

            Text(errorMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                // You can add retry logic here
            }) {
                Text("Retry")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }
}
