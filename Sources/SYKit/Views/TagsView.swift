//
//  TagsView.swift
//  SYKit
//
//  Created by syan on 14/02/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import UIKit

public protocol TagsViewDelegate: NSObjectProtocol {
    func tagsView(_ tagsView: TagsView, didTapItem item: Tag, sender: UIView)
}

public class Tag: Hashable {
    public let id: String
    public let name: String
    public let image: UIImage?
    public let object: Any
    
    public init(id: String, name: String, image: UIImage? = nil, object: Any) {
        self.id = id
        self.name = name
        self.image = image
        self.object = object
    }
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

open class TagView: UIButton {
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open func setup() {
        contentEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)

        layer.cornerRadius = 5
        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor.secondaryLabel.cgColor
        } else {
            layer.borderColor = UIColor.darkGray.cgColor
        }
        layer.borderWidth = 1
        layer.masksToBounds = true

        backgroundColor = .clear
        if #available(iOS 13.0, *) {
            setBackgroundColor(.secondaryLabel, for: .highlighted)
        } else {
            setBackgroundColor(.darkGray, for: .highlighted)
        }

        if #available(iOS 13.0, *) {
            setTitleColor(UIColor.secondaryLabel, for: .normal)
            setTitleColor(UIColor.secondarySystemGroupedBackground, for: .highlighted)
        } else {
            setTitleColor(UIColor.darkGray, for: .normal)
            setTitleColor(UIColor.lightGray, for: .highlighted)
        }

        titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        titleLabel?.adjustsFontForContentSizeCategory = true

        if #available(iOS 15.0, *) {
            subtitleLabel?.adjustsFontForContentSizeCategory = true
        }
    }

    // MARK: Properties
    open var tagObject: Tag? {
        didSet {
            guard tagObject != oldValue else { return }
            setTitle(tagObject?.name, for: .normal)
            setImage(tagObject?.image, for: .normal)
        }
    }
}

public class TagsView: UIView {
    
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    // MARK: Properties
    public weak var delegate: TagsViewDelegate?
    public var spacing: CGSize = .init(width: 8, height: 8) {
        didSet {
            setNeedsLayout()
        }
    }
    public var tagViewClass: TagView.Type = TagView.self {
        didSet {
            tagViews.forEach { $0.removeFromSuperview() }
            tagViews.removeAll(keepingCapacity: true)
            updateContent()
        }
    }
    public var tags: [Tag] = [] {
        didSet {
            guard tags != oldValue else { return }
            updateContent()
        }
    }
    private var tagViews = [TagView]()
    
    // MARK: Actions
    @objc private func tagViewPressed(sender: TagView) {
        delegate?.tagsView(self, didTapItem: sender.tagObject!, sender: sender)
    }
    
    // MARK: Content
    private func updateContent() {
        // add/remove tagViews as needed
        while tagViews.count > tags.count {
            let view = tagViews.popLast()!
            view.removeFromSuperview()
        }
        while tagViews.count < tags.count {
            let view = tagViewClass.init()
            view.addTarget(self, action: #selector(self.tagViewPressed(sender:)), for: .primaryActionTriggered)
            view.setContentHuggingPriority(.required, for: .horizontal)
            view.setContentHuggingPriority(.required, for: .vertical)
            view.setContentCompressionResistancePriority(.required, for: .horizontal)
            view.setContentCompressionResistancePriority(.required, for: .vertical)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
            addSubview(view)
            tagViews.append(view)
        }
        assert(tagViews.count == tags.count)
        
        // update tagViews content
        for (i, tag) in tags.enumerated() {
            let view = tagViews[i]
            view.tagObject = tag
        }
        
        // layout
        setNeedsLayout()
    }
    
    // MARK: Layout
    private var cachedSizes: [String: CGSize] = [:]
    private func size(for tagView: TagView, height: Double) -> CGSize {
        guard let tag = tagView.tagObject else { return .zero }
        let id = tag.id + String(height) + traitCollection.preferredContentSizeCategory.rawValue
        
        if let cached = cachedSizes[id] {
            return cached
        }
        let size = tagView.sizeThatFits(CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: height
        ))
        cachedSizes[id] = size
        return size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let first = tagViews.first else { return }

        let spacing: CGFloat = 8
        let height = size(for: first, height: .greatestFiniteMagnitude).height

        var previousX: CGFloat = 0
        var previousY: CGFloat = 0

        for tagView in tagViews {
            let width = size(for: tagView, height: height).width
            if previousX + width > bounds.width {
                previousX = 0
                previousY += height + spacing
            }
            tagView.frame = .init(x: previousX, y: previousY, width: width, height: height)
            previousX += spacing + width
        }

        invalidateIntrinsicContentSize()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: tagViews.last?.frame.maxY ?? 0)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setNeedsLayout()
        }
    }
}
