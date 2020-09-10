//
//  Structs.swift
//  OnTheMap
//
//  Created by Rafif Kalantan on 04/09/2020.
//  Copyright © 2020 Sabrina Svedin. All rights reserved.
//

import Foundation

//MARK: Constants
//Struct containing the API key and application ID
struct Constants {
    static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
}

//MARK: Login Response
// Struct containing account and session
struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

//MARK: Account
// Struct containing registeration status and key
struct Account: Codable {
    let registered: Bool
    let key: String
}

//MARK: Session
// Struct containing Session's ID and expirattion
struct Session: Codable {
    let id: String
    let expiration: String
}

//MARK: User Profile
// Struct containing User's first name, last name, nickname, and coding keys
struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
 
}

//MARK: Students Location
// Struct containing Students' locations
struct StudentsLocation: Codable {
    let results: [StudentInformation]
}

//MARK: Student Information
// Struct containing Students' info (creation, first name, last name, latitude, longitude, map string, media url, object ID, unique key, and update), its initialization, and name display method
struct StudentInformation: Codable {
    let createdAt: String?
    let firstName: String
    let lastName: String
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.createdAt = dictionary["createdAt"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.objectId = dictionary["objectId"] as? String
        self.updatedAt = dictionary["updatedAt"] as? String
    }
    
    var labelName: String {
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !lastName.isEmpty {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "FirstName LastName"
        }
        return name
    }
 
}

//MARK: Location
// Struct containing Location information (ID, unique key, first name, last name, map string, media url, latitude, longitude, creation, and update)and name display
struct Location: Codable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "FirstName LastName"
        }
        return name
    }
}

//MARK: Post Location Response
// Struct containing location response creation and ID
struct PostLocationResponse: Codable {
    let createdAt: String?
    let objectId: String?
}

//MARK: Update Location Response
// Struct containing location response update
struct UpdateLocationResponse: Codable {
    let updatedAt: String?
}
