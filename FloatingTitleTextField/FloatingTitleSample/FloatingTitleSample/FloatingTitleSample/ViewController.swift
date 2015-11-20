//
//  ViewController.swift
//  FloatingTitleSample
//
//  Created by Gustavo Saume on 11/15/15.
//  Copyright © 2015 BigPanza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
    self.view.addGestureRecognizer(tapGesture)
  }

  func dismissKeyboard() {
    self.view.endEditing(true)
  }
}

