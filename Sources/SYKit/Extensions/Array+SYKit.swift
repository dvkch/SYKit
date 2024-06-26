//
//  Array+SYKit.swift
//  SYKit
//
//  Created by Stanislas Chevallier on 26/06/2019.
//  Copyright © 2019 Syan. All rights reserved.
//

import Foundation

public extension Array where Element : Equatable {
    mutating func remove(_ element: Element) {
        while let index = self.firstIndex(of: element) {
            self.remove(at: index)
        }
    }

    func before(_ element: Element) -> Element? {
        guard let index = self.firstIndex(of: element) else { return nil }
        let newIndex = (index - 1 + count) % count
        return self[newIndex]
    }
    
    func after(_ element: Element) -> Element? {
        guard let index = self.firstIndex(of: element) else { return nil }
        let newIndex = (index + 1) % count
        return self[newIndex]
    }
}

@available(iOS 13.0, *)
public extension Collection where Element: Identifiable {
    func find(id: Element.ID) -> Element? {
        return first(where: { $0.id == id })
    }
}

public extension Collection {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    var nilIfEmpty: Self? {
        return isEmpty ? nil : self
    }

    var unique: Element? {
        guard count == 1 else { return nil }
        return first
    }
}

public extension Sequence where Element : OptionalType {
    func removingNils() -> [Element.Wrapped] {
        return compactMap { $0.value }
    }
}

public extension Array {
    func element(at index: Index, `default`: Element? = nil) -> Element? {
        return index < count ? self[index] : `default`
    }
}

public extension Collection {
    func subarray(maxCount: Int) -> Self.SubSequence {
        let max = Swift.min(maxCount, count)
        let maxIndex = index(startIndex, offsetBy: max)
        return self[startIndex..<maxIndex]
    }
}

public extension Sequence {
    func sorted<V: Comparable>(by path: KeyPath<Element, V>, ascending: Bool = true) -> [Self.Element] {
        return self.sorted { e1, e2 in
            return (e1[keyPath: path] < e2[keyPath: path]) == ascending
        }
    }
}

public extension MutableCollection where Self : RandomAccessCollection {
    mutating func sort<V: Comparable>(by path: KeyPath<Element, V>, ascending: Bool = true) {
        self.sort { e1, e2 in
            return (e1[keyPath: path] < e2[keyPath: path]) == ascending
        }
    }
}
