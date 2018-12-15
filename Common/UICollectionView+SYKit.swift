//
//  UICollectionView+SYKit.swift
//  SYKit
//
//  Created by Stanislas Chevallier on 12/12/2018.
//  Copyright © 2018 Syan. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCell(name: String) {
        register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
    
    func registerCell(class cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: NSStringFromClass(T.self), for: indexPath) as! T
    }
}
