//
//  TaskDetailViewController.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskDetailViewController: UIViewController, TaskDetailViewInput {

    var presenter: TaskDetailViewOutput!

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = AppFont.taskTitle
        textField.textColor = .label
        textField.placeholder = "Введите заголовок"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.date
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = AppFont.body
        textView.textColor = .tertiaryLabel
        textView.text = "Введите описание задачи..."
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        textView.delegate = self
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let title = (titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let description = (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        let finalDescription = textView.textColor == .tertiaryLabel ? "" : description

        presenter.didUpdateTask(title: title, description: finalDescription)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "Назад"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(dateLabel)
        contentView.addSubview(textView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),

            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            textView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    // В контроллере
    func displayTask(title: String, description: String?, date: Date) {
        titleTextField.text = title
        dateLabel.text = formatted(date)

        if let description, !description.isEmpty {
            textView.text = description
            textView.textColor = .label
        } else {
            textView.text = "Введите описание задачи..."
            textView.textColor = .tertiaryLabel
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }

}

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .tertiaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Введите описание задачи..."
            textView.textColor = .tertiaryLabel
        }
    }
}
