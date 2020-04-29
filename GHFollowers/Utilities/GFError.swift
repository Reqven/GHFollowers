//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by DevAndDeploy on 19/03/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToSaveFavorites = "There was an error while trying to save favorites. Please try again."
    case unableToRetrieveFavorites = "There was an error while trying to retrieve favorites. Please try again."
}
