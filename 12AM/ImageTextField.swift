//
//  ImageTextField.swift
//  12AM
//
//  Created by Michael Castillo on 4/22/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

@IBDesignable
class ImageTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // Properties to hold the image
    // We will see a properti in our atributes inspcetor
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateTexField()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateTexField()
        }
    }
    
    func updateTexField() {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName: tintColor])
        guard let image = leftImage else {
            leftViewMode = .never
            return
        }
        leftViewMode = .always
        
        let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.tintColor = tintColor
        
        var width = leftPadding + 20
        
        if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
            width = width + 5
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        view.addSubview(imageView)
        leftView = view
    }
    
}
