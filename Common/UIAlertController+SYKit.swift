//
//  UIAlertController+SYKit.swift
//  SYKit
//
//  Created by Stanislas Chevallier on 04/03/2019.
//  Copyright © 2019 Syan. All rights reserved.
//

import UIKit

@available(iOS 8.0, tvOS 9.0, *)
extension UIAlertController {
    
    @objc(sy_setContentViewController:height:)
    public func setContentViewController(_ contentVC: UIViewController?, height: CGFloat = -1) {
        guard let contentVC = contentVC else { return }
        setValue(contentVC, forKey: "contentViewController")
        
        if height > 0 {
            contentVC.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
    
    @discardableResult
    @objc(sy_setupImageViewWithImage:height:margins:)
    public func setupImageView(image: UIImage?, height: CGFloat, margins: UIEdgeInsets = .zero) -> UIImageView {
        let vc = SYImageViewController()
        vc.imageView.image = image
        setContentViewController(vc, height: height)
        return vc.imageView
    }
}

fileprivate class SYImageViewController : UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        topConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        leftConstraint = imageView.leftAnchor.constraint(equalTo: view.leftAnchor)
        rightConstraint = imageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        bottomConstraint = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
    
    let imageView = UIImageView()
    var topConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
}
