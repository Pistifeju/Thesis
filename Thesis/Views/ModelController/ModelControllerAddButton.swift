//
//  ModelControllerAddButton.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 25..
//

import UIKit

class ModelControllerAddButton: UIButton {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        super.setTitle(title, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.black, for: .normal)
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        layer.cornerRadius = 14
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        tintColor = UIColor.greenButton
        setImage(image, for: .normal)
        alignTextBelow()
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    // MARK: - Selectors
    
}

public extension UIButton {
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
}
