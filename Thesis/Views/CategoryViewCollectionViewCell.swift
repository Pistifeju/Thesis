//
//  CategoryViewCollectionViewCell.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//

import Foundation
import UIKit

class CategoryViewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var anatomyModel: AnatomyModel = AnatomyModel()
    
    public var modelName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubview(modelName)
        
        backgroundColor = Colors.mainControllerCells
        layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            modelName.centerYAnchor.constraint(equalTo: centerYAnchor),
            modelName.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    // MARK: - Selectors
}
