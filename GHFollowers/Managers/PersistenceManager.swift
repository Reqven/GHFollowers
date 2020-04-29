//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by DevAndDeploy on 29/04/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    enum Keys {
        static let favorites = "favorites"
    }
    static private let defaults = UserDefaults.standard
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
                case .success(let favorites):
                    var retrievedFavorites = favorites
                    switch actionType {
                    case .add:
                        guard !retrievedFavorites.contains(favorite) else { return }
                        retrievedFavorites.append(favorite)
                        break
                    case .remove:
                        retrievedFavorites.removeAll { $0.login == favorite.login }
                        break
                    }
                    completed(save(favorites: retrievedFavorites))
                case .failure(let error):
                    completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToRetrieveFavorites))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToSaveFavorites
        }
    }
}
