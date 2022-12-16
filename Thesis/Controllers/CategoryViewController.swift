//
//  CategoryViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//

import Foundation
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
        navigationItem.title = "Skeletal System"
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    // MARK: - Selectors
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
}

extension CategoryViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return systems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryViewCollectionViewCell
        let index = systems[indexPath.row]
        cell.modelName.text = index.name
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
        
        //collectionView.showLoader(true)
        
        
        let vc = ARViewController(with: cell.anatomyModel)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
//        let vc = QuizViewController()
//        vc.questions = Array(cell.anatomyModel.questions)
//        vc.title = "\(cell.modelName.text!) Quiz"
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true)
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

extension CategoryViewController: ARViewControllerDelegate {
    func didLoad() {
        collectionView.showLoader(false)
    }
}
