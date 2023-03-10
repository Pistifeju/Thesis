//
//  CategoryViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//

import UIKit

private let reuseIdentifier = "categoryCell"

class CategoryViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    public var systems: [AnatomyModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CategoryViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    // MARK: - Selectors
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension CategoryViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return systems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryViewCollectionViewCell
        let index = systems[indexPath.row]
        cell.modelName.text = index.name!.replacingOccurrences(of: "_", with: " ")
        cell.anatomyModel = index
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryViewCollectionViewCell
        
        UIView.animate(withDuration: 0.2,
                       animations: {
            cell.alpha = 0.5
        }) { (completed) in
            UIView.animate(withDuration: 0.2,
                           animations: {
                cell.alpha = 1
            })
        }
        
        let vc = ModelViewController()
        vc.model = cell.anatomyModel
        let index = systems[indexPath.row]
        vc.title = index.name!.replacingOccurrences(of: "_", with: " ")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 20) / 2
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
