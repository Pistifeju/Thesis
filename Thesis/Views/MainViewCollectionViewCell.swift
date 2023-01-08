//
//  MainViewCollectionViewCell.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//

import UIKit

class MainViewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var categoryName = ""
    public var sectionCount = 0
    public var system: [AnatomyModel] = []
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        addSubview(cellImageView)
            
        let labelsStackView = UIStackView(arrangedSubviews: [categoryLabel, sectionLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 4
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.alignment = .center
        
        addSubview(labelsStackView)
        
        backgroundColor = Colors.mainControllerCells
        layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            cellImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cellImageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0),
            
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            //labelsStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 0)
        ])
    }
    
    public func configureCell(withCategory categoryName: String, withSystems system: [AnatomyModel]) {
        self.categoryName = categoryName
        self.cellImageView.image = UIImage(named: categoryName)
        self.cellImageView.layer.opacity = 0.7
        self.system = system
        
        switch categoryName {
        case "skeletalSystem":
            self.categoryLabel.text = "I. Skeletal System"
            self.sectionCount = system.count
            self.sectionLabel.text = "\(sectionCount) sections"
        case "visceralSystem":
            self.categoryLabel.text = "II. Visceral System"
            self.sectionCount = system.count
            self.sectionLabel.text = "\(sectionCount) sections"
        case "muscularSystem":
            self.categoryLabel.text = "III. Muscular System"
            self.sectionCount = system.count
            self.sectionLabel.text = "\(sectionCount) sections"
        default:
            break
        }
    }
    // MARK: - Selectors
}
