//
//  RecItem.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/29/24.
//
import UniformTypeIdentifiers
import SwiftUI

import Foundation

struct Item: Codable, Identifiable, Equatable, Transferable {
//struct Item: Codable, Transferable {

    let id: String
    let userId: String
    var nickname: String
    let boardId: String
    var name: String
    var note: String
    var link: String
    var isTopFive: Bool
    let createdDate: TimeInterval
    var modifiedDate: TimeInterval
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .item)
    }
    mutating func setName(_ state: String){
        name = state
    }
    mutating func setNote(_ state: String){
        note = state
    }
    mutating func setLink(_ state: String){
        link = state
    }
    mutating func setTopFive(_ state: Bool){
        isTopFive = state
    }
    mutating func setModifiedDate(_ state: TimeInterval){
        modifiedDate = state
    }
}

extension UTType {
    static let item = UTType(exportedAs: "Personal.Rex.Item")
}
