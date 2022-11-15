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
    
    private var systems: [Array<ARModel>] = []
    private var systemsName: [String] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureUI()
        configure()
//
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Systems"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
    }
    
    public func configure() {
        Systems.allCases.forEach {
            let key = $0.rawValue
            if let data = UserDefaults.standard.value(forKey: key) as? Data {
                let system = try! PropertyListDecoder().decode(Array<ARModel>.self, from: data)
                self.systems.append(system)
                self.systemsName.append(key)
            }
        }
    }
    
    // MARK: - Selectors
}

// MARK: - UICollectionViewDataSource

extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return systemsName.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainViewCollectionViewCell
        cell.configureCell(withCategory: systemsName[indexPath.row], withSystems: systems[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! MainViewCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width - 50
        let height = view.frame.height / 4
        
        return CGSize(width: width, height: height)
    }
}
