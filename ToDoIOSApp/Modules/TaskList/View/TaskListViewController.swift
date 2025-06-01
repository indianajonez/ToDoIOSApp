//
//  TaskListViewController.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskListViewController: UIViewController {
    var presenter: TaskListViewOutput!
    
    private var tasks: [TaskModel] = []
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let taskCountLabel = UILabel()
    private let addTaskButton = UIButton(type: .system)
    private let searchBar = SearchBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        setupUI()
        searchBar.textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        searchBar.micButton.addTarget(self, action: #selector(micTapped), for: .touchUpInside)
        presenter.viewDidLoad()
    }

    private func setupUI() {
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        taskCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        taskCountLabel.textColor = .secondaryLabel
        
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        
        let pencilImage = UIImage(systemName: "square.and.pencil")
        addTaskButton.setImage(pencilImage, for: .normal)
        addTaskButton.tintColor = UIColor(named: "AccentColor") ?? .systemYellow
        addTaskButton.addTarget(self, action: #selector(didTapAddTask), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        bottomBar.addSubview(taskCountLabel)
        bottomBar.addSubview(addTaskButton)
        view.addSubview(bottomBar)

        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),

            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
    
    @objc private func didTapAddTask() {
        presenter.didTapAddTask()
    }
    
    @objc private func textChanged(_ sender: UITextField) {
        let query = sender.text ?? ""
        presenter.filterTasks(by: query)
    }

    @objc private func micTapped() {
        print("Mic tapped")
        // Будет позже: запуск голосового ввода
    }

}

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

}

extension TaskListViewController: TaskListViewInput {
    func reloadTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.taskCountLabel.text = "\(tasks.count) задач"

        }
    }
}

extension TaskListViewController: TaskTableViewCellDelegate {
    func didToggleTaskCompletion(taskID: Int64) {
        presenter.didToggleCompletion(for: taskID)
    }
}

