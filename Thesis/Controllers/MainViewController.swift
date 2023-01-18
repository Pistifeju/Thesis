//
//  MainViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import UIKit
import RealmSwift

private let reuseIdentifier = "systemCell"

class MainViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var systems: [AnatomyModel] = []
    private var systemsName: [String] = ["Skeletal_System", "Visceral_System", "Muscular_System"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        if let encoded = UserDefaults.standard.data(forKey: "skeletalModels"), let anatomyModels = try? JSONDecoder().decode([AnatomyModel].self, from: encoded) {
            // Use the retrieved anatomy models
            self.systems = anatomyModels
        }
        
        configureUI()
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didPressLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        let cellSize = CGSize(width: view.frame.width - 50, height: view.frame.width / 2)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.reloadData()
    }

    // MARK: - Selectors
    
    @objc private func didPressLogout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            AuthService.shared.signOut { [weak self] error in
                guard let strongSelf = self else { return }
                if let error = error {
                    AlertManager.showLogoutErrorAlert(on: strongSelf, with: error)
                    return
                }
                
                if let sceneDelegate = strongSelf.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
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
        vc.title = cell.categoryName.replacingOccurrences(of: "_", with: " ")
        vc.systems = cell.system
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true)
    }
    
}
