//
//  Event.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/15/24.
//

import Foundation
struct NewBoardEvent: Codable, Identifiable {
    let id: String
    let userId: String
    var boardId: String
    var nickname: String
    var isPrivate: Bool
    let eventDate: TimeInterval
    var likes: Array<String>
}
