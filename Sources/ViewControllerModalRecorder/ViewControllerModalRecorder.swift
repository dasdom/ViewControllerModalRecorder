//  Created by Dominik Hauser on 07.08.21.
//  
//

import UIKit

public class ViewControllerModalRecorder {
  static var lastPresented: UIViewController?
  static var lastDismissed: UIViewController?

  public init() {
    swizzle()
  }

  deinit {
    swizzle()
  }

  func swizzle() {
    swizzleControllerPresentation()
    swizzleControllerDismiss()
    
    print("swizzzzzzzzz (ViewControllerModalRecorder)")
  }

  func swizzleControllerPresentation() {
    let originalSelector = #selector(UIViewController.present(_:animated:completion:))

    let swizzledSelector = #selector(UIViewController.mock_present(_:animated:completion:))

    guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector) else {
      fatalError("original missing")
    }

    guard let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
      fatalError("swizzled missing")
    }

    method_exchangeImplementations(originalMethod, swizzledMethod)
  }

  func swizzleControllerDismiss() {
    let originalSelector = #selector(UIViewController.dismiss(animated:completion:))

    let swizzledSelector = #selector(UIViewController.mock_dismiss(animated:completion:))

    guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector) else {
      fatalError("original missing")
    }

    guard let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
      fatalError("swizzled missing")
    }

    method_exchangeImplementations(originalMethod, swizzledMethod)
  }

  public func getLastPresented() -> UIViewController? {
    return ViewControllerModalRecorder.lastPresented
  }

  public func getLastDismissed() -> UIViewController? {
    return ViewControllerModalRecorder.lastDismissed
  }
}

extension UIViewController {
  @objc func mock_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    ViewControllerModalRecorder.lastPresented = viewControllerToPresent
  }

  @objc func mock_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    ViewControllerModalRecorder.lastDismissed = self
  }
}
