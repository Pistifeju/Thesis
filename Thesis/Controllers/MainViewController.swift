//
//  MainViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import Foundation
import UIKit

private let reuseIdentifier = "systemCell"

class MainViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var systems: [AnatomyModel] = []
    private var systemsName: [String] = ["skeletalSystem", "visceralSystem", "muscularSystem"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.systems = AnatomyModelArray
        
        configureUI()
        configure()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Categories"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let cellSize = CGSize(width:view.frame.width - 50, height:view.frame.width / 2)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.reloadData()
    }
    
    public func configure() {
    }
    
    // MARK: - Selectors
}


// MARK: - UICollectionViewDataSource

extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainViewCollectionViewCell
        cell.configureCell(withCategory: systemsName[indexPath.row], withSystems: systems)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return systemsName.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainViewCollectionViewCell
    
        UIView.animate(withDuration: 0.2,
                       animations: {
            //Fade-out
            cell.alpha = 0.5
        }) { (completed) in
            UIView.animate(withDuration: 0.2,
                           animations: {
                //Fade-out
                cell.alpha = 1
            })
        }
        
        let vc = CategoryViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.title = cell.categoryName
        vc.systems = cell.system
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true)
    }
    
    
}
