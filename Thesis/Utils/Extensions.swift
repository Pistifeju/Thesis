//
//  Extensions.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 16..
//

import UIKit
import JGProgressHUD

extension UICollectionView {
    public static let hud = JGProgressHUD(style: .light)
    
    func showLoader(_ show: Bool) {
        endEditing(true)
        
        if show {
            UICollectionView.hud.show(in: self, animated: true)
        } else {
            UICollectionView.hud.dismiss(animated: false)
        }
    }
}

extension UIViewController {
    static let hud = JGProgressHUD(style: .light)
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view, animated: true)
        } else {
            UIViewController.hud.dismiss(animated: false)
        }
    }
}
