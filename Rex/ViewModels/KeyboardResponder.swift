//
//  KeyboardResponder.swift
//  Rex
//
//  Created by Miclaine Emtman on 9/24/24.
//

import Foundation
import Combine
import SwiftUI
class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification))
            .sink { notification in
                if notification.name == UIResponder.keyboardDidShowNotification {
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        self.currentHeight = keyboardFrame.height
                    }
                } else {
                    self.currentHeight = 0
                }
            }
    }
}

