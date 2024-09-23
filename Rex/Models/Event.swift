//
//  EventProtocol.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/2/24.
//

import Foundation
//protocol Event: Identifiable {
//    var id: String { get }
//    var eventDate: TimeInterval { get }
//}
enum EventWrapper: Identifiable {
    case board(NewBoardEvent)
    case item(NewItemEvent)
    
    var id: String {
        switch self {
        case .board(let event):
            return event.id
        case .item(let event):
            return event.id
        }
    }
    
    var eventDate: TimeInterval {
        switch self {
        case .board(let event):
            return event.eventDate
        case .item(let event):
            return event.eventDate
        }
    }
}
