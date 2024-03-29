//
//  UIAlertController+SYKit.swift
//  SYKit
//
//  Created by Stanislas Chevallier on 04/03/2019.
//  Copyright © 2019 Syan. All rights reserved.
//

import UIKit

extension UIAlertController {
    @discardableResult
    @objc(sy_addActionWithTitle:image:style:handler:)
    public func addAction(title: String?, image: UIImage? = nil, style: UIAlertAction.Style, handler: ((UIAlertAction) -> ())?) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        if let image = image {
            action.updateImaeg(image)
        }
        self.addAction(action)
        return action
    }
    
    @objc(sy_setContentViewController:height:)
    public func setContentViewController(_ contentVC: UIViewController?, height: CGFloat = -1) {
        setValue(contentVC, forKey: "contentViewController")
        
        if contentVC != nil, height > 0 {
            contentVC?.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
    
    @discardableResult
    @objc(sy_setupImageViewWithImage:height:margins:)
    public func setupImageView(image: UIImage?, height: CGFloat, margins: UIEdgeInsets = .zero) -> UIImageView {
        let vc = SYImageViewController()
        vc.imageView.image = image
        vc.imageViewMargins = margins
        setContentViewController(vc, height: height)
        return vc.imageView
    }
}

extension UIAlertAction {
    @objc(sy_updateTitle:)
    public func updateTitle(_ title: String) {
        setValue(title, forKey: "title")
    }
    public func updateImaeg(_ image: UIImage?) {
        setValue(image, forKey: "image")
    }
}

fileprivate class SYImageViewController : UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        leftConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        rightConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([topConstraint!, leftConstraint!, rightConstraint!, bottomConstraint!])
        updateImageViewMargins()
    }
    
    let imageView = UIImageView()
    var imageViewMargins: UIEdgeInsets = .zero {
        didSet {
            updateImageViewMargins()
        }
    }
    
    private var topConstraint: NSLayoutConstraint?
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    private func updateImageViewMargins() {
        topConstraint?.constant = imageViewMargins.top
        leftConstraint?.constant = imageViewMargins.left
        rightConstraint?.constant = -imageViewMargins.right
        bottomConstraint?.constant = -imageViewMargins.bottom
    }
}

extension UIAlertController {
    @objc(sy_showForError:title:closeButtonText:inViewController:)
    public static func show(for error: Error, title: String? = nil, close: String, in viewController: UIViewController) {
        let alert = self.init(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(title: close, style: .cancel, handler: nil)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    @objc(sy_showWithTitle:message:closeButtonText:inViewController:)
    public static func show(title: String? = nil, message: String? = nil, close: String, in viewController: UIViewController) {
        let alert = self.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(title: close, style: .cancel, handler: nil)
        viewController.present(alert, animated: true, completion: nil)
    }
}

public class HUDAlertController: UIAlertController {

    // MARK: Convenience
    public static func show(in viewController: UIViewController, animated: Bool = true) -> Self {
        let alert = self.init(title: nil, message: "", preferredStyle: .alert)
        viewController.present(alert, animated: false, completion: nil)
        return alert
    }
    
    public static func dismiss(_ hud: HUDAlertController?, animated: Bool = true, completion: (() -> ())? = nil) {
        if let hud {
            hud.dismiss(animated: animated, completion: completion)
        }
        else {
            completion?()
        }
    }
    
    // MARK: Init
    public override func viewDidLoad() {
        super.viewDidLoad()

        stackView.alignment = .center
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true

        updateContent()
    }

    // MARK: Properties
    private var preferredSize: CGSize {
        if progress == nil {
            return CGSize(width: 100, height: 100)
        }
        return CGSize(width: 200, height: 50)
    }
    public var progress: Float? {
        didSet {
            updateContent()
            view.setNeedsUpdateConstraints()
        }
    }
    
    // MARK: Views
    private var contentView: UIView {
        return view.subviews.first!
    }
    private let stackView = UIStackView()

    private lazy var loader: UIActivityIndicatorView = {
        let loader: UIActivityIndicatorView
        if #available(iOS 13.0, tvOS 13.0, *) {
            loader = UIActivityIndicatorView(style: .large)
            loader.color = .label
        } else {
            loader = UIActivityIndicatorView(style: .whiteLarge)
            loader.color = .black
        }
        return loader
    }()
    private lazy var progressView = UIProgressView()
    
    // MARK: Content
    private func updateContent() {
        if let progress {
            if progressView.superview == nil {
                stackView.subviews.forEach { $0.removeFromSuperview() }
                stackView.addArrangedSubview(progressView)
            }
            progressView.progress = progress
        }
        else {
            if loader.superview == nil {
                stackView.subviews.forEach { $0.removeFromSuperview() }
                stackView.addArrangedSubview(loader)
            }
            loader.startAnimating()
        }
    }

    // MARK: Layout
    public override func updateViewConstraints() {
        let contentViewWidth = contentView.constraints.constantAttribute(.width).first ?? contentView.widthAnchor.constraint(equalToConstant: 0)
        contentViewWidth.priority = .defaultLow
        contentViewWidth.constant = preferredSize.width
        contentViewWidth.isActive = true
        
        let viewWidth = view.constraints.constantAttribute(.width).first ?? view.widthAnchor.constraint(equalToConstant: 0)
        viewWidth.constant = preferredSize.width
        viewWidth.isActive = true
        
        let viewHeight = view.constraints.constantAttribute(.height).first ?? view.heightAnchor.constraint(equalToConstant: 0)
        viewHeight.constant = preferredSize.height
        viewHeight.isActive = true

        super.updateViewConstraints()
    }
}

fileprivate extension Array where Element == NSLayoutConstraint {
    func constantAttribute(_ attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation = .equal) -> [Element] {
        return filter { $0.firstAttribute == attribute && $0.relation == relation && $0.secondItem == nil && $0.secondAnchor == nil }
    }
}
