//
//  WMarshTextField.swift
//  WMarshTextField
//
//  Created by Guillermo Anaya Magallón on 30/03/15.
//  Copyright (c) 2015 wanaya. All rights reserved.
//

import UIKit

class WMarshTextField: UITextField {
    
    
    private enum TextFieldStatus: String {
        case Inactive = "Inactive"
        case Edditing = "Edditing"
    }
    
    private let bottomLine = CALayer()
    private var status = TextFieldStatus.Inactive
    private var initFrame = CGRectZero
    
    var floatingLabel = UILabel(frame: CGRectZero)
    var leftPadding: CGFloat = 5
    
    var wmInactiveColor: UIColor = UIColor.grayColor() {
        didSet {
            self.bottomLine.backgroundColor = wmInactiveColor.CGColor
            floatingLabel.textColor = wmInactiveColor
        }
    }
    
    var wmActiveColor: UIColor = UIColor.blueColor() {
        didSet {
            self.bottomLine.backgroundColor = wmInactiveColor.CGColor
            self.textColor = wmActiveColor
            floatingLabel.textColor = wmInactiveColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        initStyle()
        self.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
        self.status = .Inactive
    }

}

//MARK: UI
extension WMarshTextField {
    func initStyle() {
        self.bottomLine.backgroundColor = self.wmInactiveColor.CGColor
        self.bottomLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1)
        self.layer.addSublayer(self.bottomLine)
        
        self.floatingLabel.textColor = self.wmInactiveColor
        self.floatingLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        self.addSubview(self.floatingLabel)
        self.floatingLabel.alpha = 0
        self.initFrame = CGRectMake(leftPadding, 0.5 * CGRectGetHeight(self.frame), 0, 0)
        self.floatingLabel.frame = self.initFrame
    }
    
    
    override var placeholder : String? {
        get {
            return super.placeholder
        }
        set (newValue) {
            super.placeholder = newValue
            floatingLabel.text = newValue
            floatingLabel.sizeToFit()
            if let value = newValue {
                self.attributedPlaceholder = NSAttributedString(string: value, attributes: [NSForegroundColorAttributeName: wmInactiveColor])
            }
            
        }
    }
    
    
    override func textRectForBounds (bounds :CGRect) -> CGRect
    {
        return UIEdgeInsetsInsetRect(super.textRectForBounds(bounds), floatingLabelInsets())
    }
    
    override func editingRectForBounds (bounds : CGRect) -> CGRect
    {
        return UIEdgeInsetsInsetRect(super.editingRectForBounds(bounds), floatingLabelInsets())
    }
    
    func floatingLabelInsets() -> UIEdgeInsets {
        floatingLabel.sizeToFit()
        return UIEdgeInsetsMake(floatingLabel.font.lineHeight, leftPadding, 0, 0)
    }
}


//MARK: actions
extension WMarshTextField {
    
    func textFieldDidChange(sender: UITextField) {
        if self.status == .Inactive {
            //realizamos animacion
            self.status = .Edditing
            self.floatingLabel.textColor = self.wmInactiveColor
            self.bottomLine.backgroundColor = self.wmActiveColor.CGColor
            self.showFloatingLabelWithAnimation(true)
        }else if self.status == .Edditing {
            if sender.text.isEmpty {
                //realizamos la animacion de esconder
                self.floatingLabel.textColor = self.wmInactiveColor
                self.bottomLine.backgroundColor = self.wmInactiveColor.CGColor
                self.hideFloatingLabel()
                self.status = .Inactive
            }
        }
    }
    
    func showFloatingLabelWithAnimation(isAnimated : Bool)
    {
        let frame = CGRectMake(leftPadding, 0, CGRectGetWidth(self.floatingLabel.frame), CGRectGetHeight(self.floatingLabel.frame))
        if (isAnimated) {
            let options = UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveEaseOut
            UIView.animateWithDuration(0.2, delay: 0, options: options, animations: {
                self.floatingLabel.alpha = 1
                self.floatingLabel.frame = frame
                }, completion: nil)
        } else {
            self.floatingLabel.alpha = 1
            self.floatingLabel.frame = frame
        }
    }
    
    func hideFloatingLabel () {
        let options = UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveEaseIn
        UIView.animateWithDuration(0.2, delay: 0, options: options, animations: {
            self.floatingLabel.alpha = 0
            self.floatingLabel.frame = self.initFrame
            }, completion: nil
        )
    }
    
}



