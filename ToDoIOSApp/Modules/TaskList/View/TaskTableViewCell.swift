//
//  TaskTableViewCell.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

// MARK: - Protocol

protocol TaskTableViewCellDelegate: AnyObject {
    func didToggleTaskCompletion(taskID: Int64)
}

final class TaskTableViewCell: UITableViewCell {

    // MARK: - Public Properties

    weak var delegate: TaskTableViewCellDelegate?

    // MARK: - Private Properties

    private var taskID: Int64?

    private let checkboxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "checkbox_unchecked")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        taskID = nil
        titleLabel.attributedText = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }

    // MARK: - Configuration

    func configure(with task: TaskModel) {
        taskID = task.id

        // Шрифты и цвета
        titleLabel.font = AppFont.title
        descriptionLabel.font = AppFont.body
        dateLabel.font = AppFont.date

        let textColor = task.completed ? AppColor.textCompleted : AppColor.textActive
        titleLabel.textColor = textColor
        descriptionLabel.textColor = textColor
        dateLabel.textColor = textColor

        // Чекбокс
        let imageName = task.completed ? "checkbox_checked" : "checkbox_unchecked"
        checkboxButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)

        // Заголовок
        let titleAttributes: [NSAttributedString.Key: Any] = task.completed
            ? [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: textColor
            ]
            : [.foregroundColor: textColor]

        titleLabel.attributedText = NSAttributedString(string: task.title, attributes: titleAttributes)

        // Описание
        descriptionLabel.text = task.taskDescription

        // Дата
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: task.createdAt)
    }

    // MARK: - Actions

    @objc private func didTapCheckbox() {
        guard let id = taskID else { return }
        delegate?.didToggleTaskCompletion(taskID: id)
    }

    // MARK: - UI Setup

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        checkboxButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)

        contentView.addSubview(checkboxButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkboxButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
