//
//  ColorPickerVie.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 26..
//

import Foundation
import UIKit

protocol ColorPickerViewDelegate: AnyObject {
    func didSelectColor(withColor: UIColor?)
}

class ColorPickerView: UICollectionView {
    
    weak var pickerDelegate: ColorPickerViewDelegate?
    
    private var clearImage: UIImage = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .default)
        let largeImage = UIImage(systemName: "x.circle", withConfiguration: imageConfig)
        
        
        return largeImage!
    }()
    
    private lazy var colors: [Any] = [UIColor.red, UIColor.green, UIColor.orange, self.clearImage]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.collectionView?.isScrollEnabled = false
        super.init(frame: .zero, collectionViewLayout: layout)
        
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
        let cell = ColorPickerViewCell(frame: .zero)
        cell.layer.cornerRadius = cell.bounds.width / 2
        self.register(ColorPickerViewCell.self, forCellWithReuseIdentifier: "cell")

        configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorPickerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.colors[indexPath.row] is UIColor) {
            pickerDelegate?.didSelectColor(withColor: self.colors[indexPath.row] as? UIColor)
        } else {
            pickerDelegate?.didSelectColor(withColor: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorPickerViewCell
        cell.configure(with: self.colors[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = cell.bounds.width / 2
    }
}

class ColorPickerViewCell: UICollectionViewCell {
    
    private var backgroundImageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .center
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: Any) {
        if(object is UIColor) {
            self.backgroundColor = object as? UIColor
        } else {
            self.backgroundColor = .clear
            let img = object as? UIImage
            self.backgroundImageView.image = img
            addSubview(self.backgroundImageView)
            NSLayoutConstraint.activate([
                self.backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                self.backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
    }
}
