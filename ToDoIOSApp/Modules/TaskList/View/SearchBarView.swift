//
//  SearchBarView.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class SearchBarView: UIView {

    // MARK: - Public Properties

    let textField = UITextField()
    let micButton = UIButton(type: .system)

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        setupAppearance()
        setupTextField()
        setupMicButton()
        setupConstraints()
    }

    private func setupAppearance() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

    private func setupTextField() {
        let magnifyingGlass = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingGlass.tintColor = .secondaryLabel
        magnifyingGlass.contentMode = .scaleAspectFit
        magnifyingGlass.frame = CGRect(x: 8, y: 0, width: 20, height: 20)

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 20))
        leftPaddingView.addSubview(magnifyingGlass)

        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.placeholder = "Search"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .label
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupMicButton() {
        micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        micButton.tintColor = .secondaryLabel
        micButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        addSubview(textField)
        addSubview(micButton)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: micButton.leadingAnchor, constant: -8),

            micButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            micButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            micButton.widthAnchor.constraint(equalToConstant: 20),
            micButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
