//
//  MainTabController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 30..
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(with: user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showFetchingUserErrorAlert(on: strongSelf, with: error)
                return
            }
            
            if let user = user {
                strongSelf.user = user
            }
        }
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        tabBar.isHidden = false
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
    }
    
    private func configureViewControllers(with user: User) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let main = templateNavigationController(unselectedImage: UIImage(systemName: "square.grid.2x2")!, selectedImage: UIImage(systemName: "square.grid.2x2.fill")!, rootViewController: MainViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        main.title = "Section"
        
        let profile = templateNavigationController(unselectedImage: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!, rootViewController: ProfileViewController(user: user))
        profile.title = "Profile"
        
        viewControllers = [main, profile]
    }
    
    private func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.isHidden = false
        nav.navigationBar.backgroundColor = .white
        nav.navigationBar.tintColor = .black
        return nav
    }
}
