//
//  SecondView.swift
//  GitHubSearchUI
//
//  Created by Ivo Vasilski on 20.08.24.
//
import SwiftUI

struct UserDetailView: View {
    let user: User
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Custom Title Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }

                Spacer()

                Text("Details")
                    .font(.headline)

                Spacer()

                // Placeholder to balance the Back button
                Spacer()
                    .frame(width: 60)
            }
            .padding(.top, 10)
            .padding(.horizontal)

            // User Avatar
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(radius: 10) // 3D effect
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .padding(.top, 20)

            // User Login
            Text(user.login)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)

            // Profile Button
            Button(action: openUserProfile) {
                Text("View Profile")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5) // 3D effect
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
    }

    private func openUserProfile() {
        if let url = URL(string: "https://github.com/\(user.login)") {
            UIApplication.shared.open(url)
        }
    }
}


