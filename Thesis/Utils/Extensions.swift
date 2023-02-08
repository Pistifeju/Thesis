//
//  Extensions.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 16..
//

import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIColor {
    static var greenButton = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1)
    static var lightCyan = UIColor(red: 203/255, green: 238/255, blue: 243/255, alpha: 1)
    static var exitRed = UIColor(red: 219/255, green: 84/255, blue: 97/255, alpha: 1)
}

extension UIButton {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        super.touchesBegan(touches, with: event)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesEnded(touches, with: event)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesCancelled(touches, with: event)
    }

}
