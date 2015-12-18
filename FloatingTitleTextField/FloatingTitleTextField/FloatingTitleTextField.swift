//
//  FloatingTitleTextField.swift
//  FloatingTitleTextField
//
//  Created by Gustavo Saume on 11/15/15.
//  Copyright © 2015 BigPanza. All rights reserved.
//

import UIKit

@IBDesignable
public class FloatingTitleTextField: UITextField {

  // Publics vars

  @IBInspectable
  public var title: String? {
    didSet {
      self.titleLabel.text = title
      self.titleLabel.sizeToFit()

      let centerY = self.frame.height / 2.0
      let deltaY = centerY - self.titleLabel.frame.midY
      self.titleLabel.frame = self.titleLabel.frame.offsetBy(dx: 0.0, dy: deltaY)
    }
  }

  @IBInspectable
  public var leftInset: CGFloat = 0.0 {
    didSet {
      self.titleLabel.frame = self.titleLabel.frame.offsetBy(dx: leftInset, dy: 0.0)
    }
  }


  override public var placeholder: String? {
    get {
      return internalPlaceholder
    }
    set(newPlaceholder) {
      internalPlaceholder = newPlaceholder
    }
  }



  // Private vars

  private lazy var titleLabel: UILabel! = {
    return UILabel()
  }()

  private var internalPlaceholder: String?



  // Initialization

  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    self.addSubview(self.titleLabel)

    self.internalPlaceholder = super.placeholder
    super.placeholder = nil
  }



  // Overrides

  override public func becomeFirstResponder() -> Bool {
    self.repositionTitleLabel(true, animated: true) { _ in
      super.placeholder = self.internalPlaceholder
    }

    return super.becomeFirstResponder()
  }

  override public func resignFirstResponder() -> Bool {
    self.repositionTitleLabel(self.text?.characters.count == 0, animated: true, completion: nil)
    super.placeholder = nil
    return super.resignFirstResponder()
  }

  override public func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, leftInset, 0.0)
  }

  override public func editingRectForBounds(bounds: CGRect) -> CGRect {
    return textRectForBounds(bounds)
  }



  // Utils

  private func repositionTitleLabel(minimized: Bool, animated: Bool = false, completion: (Bool -> Void)?) {
    let alpha:CGFloat = minimized ? 0.6 : 1.0
    let scale:CGFloat = minimized ? CGFloat(0.75) : CGFloat(1.0)
    let scaleTransform = CGAffineTransformMakeScale(scale, scale)
    let topFrame: CGRect

    if minimized {
      let distanceToTopCorner = CGPoint(x: -self.titleLabel.frame.minX, y: -self.titleLabel.frame.minY)
      topFrame = self.titleLabel.frame.offsetBy(dx: distanceToTopCorner.x, dy: distanceToTopCorner.y)
    } else {
      let distanceToCenterX = -self.titleLabel.frame.minX
      let distanceToCenterY = ((self.bounds.height - self.titleLabel.bounds.height) / 2.0) - self.titleLabel.frame.minY
      let centerFrame = self.titleLabel.frame.offsetBy(dx: distanceToCenterX, dy: distanceToCenterY)
      topFrame = centerFrame.offsetBy(dx: self.leftInset, dy: 0.0)
    }

    let changes = {
      self.titleLabel.transform = scaleTransform
      self.titleLabel.alpha = alpha
      self.titleLabel.frame = topFrame
    }

    if animated {
      UIView.animateWithDuration(0.35, animations:changes) { completed in
        if let completion = completion {
          completion(completed)
        }
      }
    } else {
      changes()
      if let completion = completion {
        completion(true)
      }
    }
  }
}
