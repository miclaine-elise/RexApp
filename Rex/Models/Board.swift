//
//  Board.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//

import Foundation

struct Board: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let userId: String
    var nickname: String
    var name: String
    var isPrivate: Bool
    let createdDate: TimeInterval
    var modifiedDate: TimeInterval
    //let topFive: Array<String>
    
    mutating func setName(_ state: String){
        name = state
    }
    mutating func setIsPrivate(_ state: Bool){
        isPrivate = state
    }
    mutating func setModifiedDate(_ state: TimeInterval){
        modifiedDate = state
    }
    
}


