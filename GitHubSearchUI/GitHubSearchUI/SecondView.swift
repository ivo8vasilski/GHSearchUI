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
            ZStack(alignment: .topLeading) {
                // Background with blur and color
                if let url = URL(string: user.avatarUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 20)
                            .overlay(Color.black.opacity(0.3)) // Optional overlay for better contrast
                            .clipped() // Clip the image to avoid overflow
                    } placeholder: {
                        Color.gray
                            .blur(radius: 20)
                    }
                    // Increase the height to extend the blur background
                    .frame(width: UIScreen.main.bounds.width, height: 390)
                    .clipped() // Clip the image to avoid overflow
                }

                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white) // Change the color to white
                    .padding()
                }
            }
            .frame(height: 350) // Adjusted to match the background height

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
            .padding(.top, -100) // Move the avatar upwards, over the blurred background

            // User Login
            Text(user.login)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)

            // Add spacing before the buttons
            Spacer()
                .frame(height: 30) // Adjust the height as needed

            // Profile Button
            Button(action: openUserProfile) {
                VStack {
                    Text("View")
                    Text("Profile")
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5) // 3D effect
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // Repository Button
            Button(action: openUserRepository) {
                VStack {
                    Text("View")
                    Text("Repository")
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5) // 3D effect
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer() // This spacer pushes everything upwards
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func openUserProfile() {
        if let url = URL(string: "https://github.com/\(user.login)") {
            UIApplication.shared.open(url)
        }
    }

    private func openUserRepository() {
        let repositoryName = "example-repo" // Replace this with the actual repository name or variable
        
        if let url = URL(string: "https://github.com/\(user.login)/\(repositoryName)") {
            UIApplication.shared.open(url)
        }
    }
}
