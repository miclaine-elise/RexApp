//
//  Note.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/10/24.
//

import UniformTypeIdentifiers
import SwiftUI

import Foundation

struct Suggestion: Codable, Identifiable, Equatable, Transferable {
//struct Item: Codable, Transferable {

    let id: String
    let userId: String
    var name: String
    var type: String
    var note: String
    var suggestedBy: String
    var link: String
    let createdDate: TimeInterval
    var modifiedDate: TimeInterval
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .item)
    }
    mutating func setName(_ state: String){
        name = state
    }
    mutating func setType(_ state: String){
        type = state
    }
    mutating func setNote(_ state: String){
        note = state
    }
    mutating func setSuggestedBy(_ state: String){
        suggestedBy = state
    }
    mutating func setLink(_ state: String){
        link = state
    }
    mutating func setModifiedDate(_ state: TimeInterval){
        modifiedDate = state
    }
}


