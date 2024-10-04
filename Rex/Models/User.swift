//
//  User.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var nickname: String
    let email: String
    let joined: TimeInterval
    var followers: Array<String>
    var following: Array<String>
    var imageProfileUrl: String
    var keywordsForLookup : [String] {
        [self.firstName.generateStringSequence(), self.lastName.generateStringSequence(), self.nickname.generateStringSequence(), "\(self.firstName) \(self.lastName)".generateStringSequence()].flatMap { $0 }
    }
    mutating func setFirstName(_ state: String){
        firstName = state
    }
    mutating func setLastName(_ state: String){
        firstName = state
    }

    mutating func setNickname(_ state: String){
        nickname = state
    }
    mutating func setFollowers(_ state: Array<String>){
        followers = state
    }
    mutating func setFollowing(_ state: Array<String>){
        following = state
    }
    mutating func setImageProfileUrl(_ state: String){
        imageProfileUrl = state
    }
}
extension String {
    func generateStringSequence() -> [String] {
        guard self.count > 0 else {return [] }
        var sequences: [String] = []
        for i in 1...self.count {
            sequences.append(String(self.prefix(i)).lowercased())
        }
        return sequences
    }
}
