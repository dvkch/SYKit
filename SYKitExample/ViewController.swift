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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        runTests()
        swiftCompilationTest()
    }

    func runTests() {
        let image = ObjectiveCTest.testNoirFilter()
        print("Image size:", image?.size ?? .zero)
        
        print("Find subview ObjC test:", ObjectiveCTest.testFindSubviewByType() ? "passed" : "failed")
        
        print(UIDevice.current.model, UIDevice.current.localizedModel)
        print("Swift:", UIDevice.current.modelEnum?.rawValue ?? "", UIDevice.current.hardwareString)
        
        _ = UIScrollView().sy_refreshControl
        
        ObjectiveCTest.testObjCExclusivesBridgings()
    }
    
    func swiftCompilationTest() {
        // make sure we can't call those methods/classes as they are only made for ObjC bindings
        // view.objc_subviews(ofKind: UIView.self, recursive: true)
    }
}
