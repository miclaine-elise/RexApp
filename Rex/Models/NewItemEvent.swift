//
//  NewRexEvent.swift
//  Rex
//
//  Created by Miclaine Emtman on 8/15/24.
//

import Foundation
struct NewItemEvent: Codable, Identifiable {
    let id: String
    let userId: String
    var itemId: String
    var boardId: String
    var nickname: String
    var boardName: String
    var isPrivate: Bool
    let eventDate: TimeInterval
    var likes: Array<String>
}
