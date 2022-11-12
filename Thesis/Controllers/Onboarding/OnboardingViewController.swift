//
//  OnboardingViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
        
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(imageName: String, titleText: String, subtitleText: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    // MARK: - Selectors
    
}
