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
                            .overlay(Color.black.opacity(0.3))
                            .clipped()
                    } placeholder: {
                        Color.gray
                            .blur(radius: 20)
                    }
                   
                    .frame(width: UIScreen.main.bounds.width, height: 390)
                    .clipped() 
                }

                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .padding()
                }
            }
            .frame(height: 350)

            // User Avatar
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .padding(.top, -100)

            Text(user.login)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)

            
            HStack(spacing: 20) {
                VStack {
                    Text("\(user.followers_url)")
                        .font(.headline)
                    Text("Followers")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    Text("\(user.following_url)")
                        .font(.headline)
                    Text("Following")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 5)


            Spacer()
                .frame(height: 30)

           
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
                .shadow(radius: 5) 
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()
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
        let repositoryName = "example-repo"
        
        if let url = URL(string: "https://github.com/\(user.login)/\(repositoryName)") {
            UIApplication.shared.open(url)
        }
    }
}

