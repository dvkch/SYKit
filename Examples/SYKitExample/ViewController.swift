//
//  ViewController.swift
//  SYKitExample
//
//  Created by Stanislas Chevallier on 26/06/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit
import SYKit

class ViewController: UIViewController {

    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        veryHighView.gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        veryHighView.gradientLayer.startPoint = .zero
        veryHighView.gradientLayer.endPoint = .init(x: 0, y: 1)
        veryHighView.gradientLayer.locations = [0, 1]
        
        scrollMaskView.scrollMask = .vertical
        scrollMaskView.scrollMaskSize = 40
        scrollMaskView.scrollView = scrollView
        // to see the mask on the screen instead of masking the scrollView
        //scrollMaskView.frame = .init(x: 0, y: 0, width: 200, height: 500)
        //view.addSubview(scrollMaskView)
        
        runTests()
        swiftCompilationTest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let hud = HUDAlertController.show(in: self)
        hud.progress = nil
        
        test(hud, 0)
    }
    
    private func test(_ hud: HUDAlertController, _ progress: Float) {
        if progress > 1 {
            hud.progress = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.test(hud, 0)
            }
            return
        }

        hud.progress = progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.test(hud, progress + 0.05)
        }
    }

    // MARK: Properties
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var veryHighView: SYGradientView!
    @IBOutlet private var scrollMaskView: SYScrollMaskView!
    
    // MARK: Some tests
    func runTests() {
        let image = ObjectiveCTest.testNoirFilter()
        print("Image size:", image?.size ?? .zero)
        
        print("Find subview ObjC test:", ObjectiveCTest.testFindSubviewByType() ? "passed" : "failed")
                
        // test boxing
        let attrString = NSAttributedString(string: "TEST STRING", font: UIFont.boldSystemFont(ofSize: 19), color: .red)
        let data = try! PropertyListEncoder().encode(SYArchiverBox(attrString))
        let decodedAttrString = try! PropertyListDecoder().decode(SYArchiverBox<NSAttributedString>.self, from: data).value
        print("Decoded:", decodedAttrString)
    }
    
    func swiftCompilationTest() {
        // make sure we can't call those methods/classes as they are only made for ObjC bindings
        // view.objc_subviews(ofKind: UIView.self, recursive: true)
    }
}
