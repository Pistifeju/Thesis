//
//  MainViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import UIKit

private let reuseIdentifier = "systemCell"

class MainViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var systems: [[AnatomyModel]] = []
    private var systemsName: [String] = ["Skeletal_System", "Visceral_System", "Muscular_System"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if let encoded = UserDefaults.standard.data(forKey: "skeletalModels"), let anatomyModels = try? JSONDecoder().decode([AnatomyModel].self, from: encoded) {
            // Use the retrieved anatomy models
            self.systems.append(anatomyModels)
            self.systems.append([])
            self.systems.append([]) //TODO: - Load the other models as well
        }
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Categories"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        let cellSize = CGSize(width: view.frame.width - 50, height: view.frame.width / 2)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.reloadData()
    }

    // MARK: - Selectors
}

// MARK: - UICollectionViewDataSource

extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainViewCollectionViewCell
        cell.configureCell(withCategory: systemsName[indexPath.row], withSystems: systems[indexPath.row])
                
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
        vc.title = cell.categoryName.replacingOccurrences(of: "_", with: " ")
        vc.systems = cell.system
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
