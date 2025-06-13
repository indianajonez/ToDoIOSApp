//
//  TaskListViewController.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskListViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: TaskListViewOutput!

    // MARK: - Private Properties

    private var tasks: [TaskModel] = []
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let taskCountLabel = UILabel()
    private let addTaskButton = UIButton(type: .system)
    private let searchBar = SearchBarView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        setupUI()
        configureBindings()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always

        setupSearchBar()
        setupBottomBar()
        setupTableView()
        setupLayout()
    }

    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupBottomBar() {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = view.backgroundColor

        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCountLabel.font = .systemFont(ofSize: 14)
        taskCountLabel.textColor = .secondaryLabel

        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addTaskButton.tintColor = UIColor(named: "AccentColor") ?? .systemYellow
        addTaskButton.addTarget(self, action: #selector(didTapAddTask), for: .touchUpInside)

        bottomBar.addSubview(taskCountLabel)
        bottomBar.addSubview(addTaskButton)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:))))
    }

    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),

            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),

            taskCountLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            taskCountLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            taskCountLabel.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 8),
            taskCountLabel.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -8),

            addTaskButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            addTaskButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor)
        ])
    }

    private func configureBindings() {
        searchBar.textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        searchBar.micButton.addTarget(self, action: #selector(micTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point), indexPath.row < tasks.count {
            presenter.didLongPressTask(tasks[indexPath.row])
        }
    }

    @objc private func didTapAddTask() {
        presenter.didTapAddTask()
    }

    @objc private func textChanged(_ textField: UITextField) {
        presenter.filterTasks(by: textField.text ?? "")
    }

    @objc private func micTapped() {
        print("🎤 Mic tapped — голосовой ввод будет позже")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.delegate = self
        cell.configure(with: task)
        return cell
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { _ in
                self.presenter.didSelectTask(task)
            }

            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let activityVC = UIActivityViewController(activityItems: [task.title, task.taskDescription ?? ""], applicationActivities: nil)
                self.present(activityVC, animated: true)
            }

            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.presenter.didRequestTaskDeletion(task)
            }

            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
}

// MARK: - TaskListViewInput

extension TaskListViewController: TaskListViewInput {
    func reloadTasks(_ newTasks: [TaskModel]) {
        self.tasks = newTasks
        tableView.reloadData()
        taskCountLabel.text = "\(newTasks.count) задач"
    }

    func showTaskActions(for task: TaskModel) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Редактировать", style: .default) { _ in
            self.presenter.didSelectTask(task)
        })

        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.presenter.didRequestTaskDeletion(task)
        })

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(alert, animated: true)
    }
}

// MARK: - TaskTableViewCellDelegate

extension TaskListViewController: TaskTableViewCellDelegate {
    func didToggleTaskCompletion(taskID: Int64) {
        presenter.didToggleCompletion(for: taskID)
    }
}
