//
//  ModelControllerSegmentationControl.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 24..
//

import UIKit

protocol ModelControllerSegmentationControlDelegate: AnyObject {
    func changeToIndex(index: Int)
}

class ModelControllerSegmentationControl: UIView {
    
    // MARK: - Properties
    
    private var buttonTitles = ["Quizzes", "Your Quizzes"]
    private var buttons: [UIButton]
    private var selectorView: UIView
    
    private var textColor: UIColor = .black
    private var selectorViewColor: UIColor = .red
    private var selectorTextColor: UIColor = .red
    
    weak var delegate: ModelControllerSegmentationControlDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        self.buttons = []
        self.selectorView = UIView()
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height - 10, width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.setTitle(title, for: .normal)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    private func configureUI() {
        createButton()
        configSelectorView()
        configStackView()
    }
    // MARK: - Selectors
    
    @objc private func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                delegate?.changeToIndex(index: buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}
