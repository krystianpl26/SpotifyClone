//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager() //instance
    
    private var refreshingToken = false //indicate if the token is being refreshed
    // Constants used in the AuthManager
    struct Constants{
        static let clientID = "ADD_YOUR_CLIENT_ID_HERE"
        static let clientSecret = "ADD_YOUR_CLIENT_SECRET_HERE"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "ADD_YOUR_REDIRECTURI_HERE"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }

    private init() {} // Private initializer

        // Computed property to generate the sign-in URL
        public var signInURL: URL? {
            let base = "https://accounts.spotify.com/authorize"
            let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
            return URL(string: string)
        }

        // Check if the user is signed in
        var isSignedIn: Bool {
            return accessToken != nil
        }

        // Access token stored in UserDefaults
        private var accessToken: String? {
            return UserDefaults.standard.string(forKey: "access_token")
        }

        // Refresh token stored in UserDefaults
        private var refreshToken: String? {
            return UserDefaults.standard.string(forKey: "refresh_token")
        }

        // Token expiration date stored in UserDefaults
        private var tokenExpirationDate: Date? {
            return UserDefaults.standard.object(forKey: "expirationDate") as? Date
        }

        // Check if the token should be refreshed
        private var shouldRefreshToken: Bool {
            guard let expirationDate = tokenExpirationDate else {
                return false
            }
            let currentDate = Date()
            let fiveMinutes: TimeInterval = 300
            return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
        }

        // Exchange the authorization code for an access token
        public func exchangeCodeForToken(
            code: String,
            completion: @escaping ((Bool) -> Void)
        ) {
            guard let url = URL(string: Constants.tokenAPIURL) else {
                return
            }

            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = components.query?.data(using: .utf8)

            let basicToken = Constants.clientID + ":" + Constants.clientSecret
            let data = basicToken.data(using: .utf8)
            guard let base64String = data?.base64EncodedString() else {
                print("Failure to get base64")
                completion(false)
                return
            }

            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }

                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self?.cacheToken(result: result)
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            task.resume()
        }

        private var onRefreshBlocks = [((String) -> Void)]() // Blocks to be called upon token refresh

        // Provide a valid token for API calls
        public func withValidToken(completion: @escaping (String) -> Void) {
            guard !refreshingToken else {
                onRefreshBlocks.append(completion)
                return
            }

            if shouldRefreshToken {
                refreshIfNeeded { [weak self] success in
                    if let token = self?.accessToken, success {
                        completion(token)
                    }
                }
            } else if let token = accessToken {
                completion(token)
            }
        }

        // Refresh the token if needed
        public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
            guard !refreshingToken else {
                return
            }

            guard shouldRefreshToken else {
                completion?(true)
                return
            }

            guard let refreshToken = self.refreshToken else {
                return
            }

            guard let url = URL(string: Constants.tokenAPIURL) else {
                return
            }

            refreshingToken = true

            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: refreshToken),
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = components.query?.data(using: .utf8)

            let basicToken = Constants.clientID + ":" + Constants.clientSecret
            let data = basicToken.data(using: .utf8)
            guard let base64String = data?.base64EncodedString() else {
                print("Failure to get base64")
                completion?(false)
                return
            }

            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                self?.refreshingToken = false
                guard let data = data, error == nil else {
                    completion?(false)
                    return
                }

                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self?.onRefreshBlocks.forEach { $0(result.access_token) }
                    self?.onRefreshBlocks.removeAll()
                    self?.cacheToken(result: result)
                    completion?(true)
                } catch {
                    print(error.localizedDescription)
                    completion?(false)
                }
            }
            task.resume()
        }

        // Cache the tokens and expiration date
        private func cacheToken(result: AuthResponse) {
            UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
            if let refresh_token = result.refresh_token {
                UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
            }
            UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        }

        // Sign out and clear all stored tokens and expiration date
        public func signOut(completion: (Bool) -> Void) {
            UserDefaults.standard.setValue(nil, forKey: "access_token")
            UserDefaults.standard.setValue(nil, forKey: "refresh_token")
            UserDefaults.standard.setValue(nil, forKey: "expirationDate")
            completion(true)
        }
    }
    

