//
//  OptionSet+SYKit.swift
//  SYKit
//
//  Created by Stanislas Chevallier on 11/05/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import Foundation

public extension OptionSet where Self == Self.Element {
    @inlinable mutating func set(_ member: Self.Element, enabled: Bool) {
        if enabled {
            self.insert(member)
        }
        else {
            self.remove(member)
        }
    }
}

