//
//  SearchBarView.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class SearchBarView: UIView {

    let textField = UITextField()
    let micButton = UIButton(type: .system)
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 36)
//    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        
        let magnifyingGlass = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlass.tintColor = .secondaryLabel
        magnifyingGlass.contentMode = .scaleAspectFit

        // Оборачиваем в UIView с паддингом
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 20))
        magnifyingGlass.frame = CGRect(x: 8, y: 0, width: 20, height: 20)
        leftPaddingView.addSubview(magnifyingGlass)

        textField.leftView = leftPaddingView
        textField.leftViewMode = .always


        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true

        textField.placeholder = "Search"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .label
        textField.translatesAutoresizingMaskIntoConstraints = false

        micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        micButton.tintColor = UIColor.secondaryLabel
        micButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textField)
        addSubview(micButton)

        NSLayoutConstraint.activate([

            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: micButton.leadingAnchor, constant: -8),

            micButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            micButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            micButton.widthAnchor.constraint(equalToConstant: 20),
            micButton.heightAnchor.constraint(equalToConstant: 20),

            
        ])
    }
}

