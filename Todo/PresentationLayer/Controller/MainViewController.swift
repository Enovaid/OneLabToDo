//
//  MainViewController.swift
//  Todo
//
//  Created by Айдана on 1/9/21.
//

import SnapKit

class MainViewController: UIViewController {
    
    private var tasks: [Task] = []
    private var historyTasks: [Task] = []
    private var viewModel = MainViewModel()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["To do", "History"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureTableView()
        configureNavigationBar()
        configureStackView()
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, tableView])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "Identifier")
    }
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidPress))
        self.navigationItem.rightBarButtonItem  = addButton
        navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.title = "Tasks"
    }
    
    private func reloadTableView() {
        tasks = viewModel.fetchTodoTasks(isCompleted: false)
        historyTasks = viewModel.fetchTodoTasks(isCompleted: true)
        tableView.reloadData()
    }
    
    private func showDeleteAlert(task: Task) {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let addAction = UIAlertAction(title: "Delete", style: .default) { [weak self] action in
            self?.viewModel.delete(task: task)
            self?.reloadTableView()
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showEdtiViewController(task: Task) {
        let AddViewController = AddEditViewController()
        AddViewController.nameTextField.text = task.name
        AddViewController.informationTextField.text = task.information
        AddViewController.navigationItem.title = "Edit a task"
        AddViewController.didSave = { name, information in
            task.name = name
            task.information = information
            self.viewModel.update()
        }
        self.navigationController?.pushViewController(AddViewController, animated: true)
    }
    
    @objc private func segmentedControlDidChange() {
        tableView.reloadData()
    }
    
    @objc private func addButtonDidPress(){
        let AddViewController = AddEditViewController()
        AddViewController.nameTextField.placeholder = "Task name"
        AddViewController.informationTextField.placeholder = "Task description"
        AddViewController.navigationItem.title = "Аdd a task"
        AddViewController.didSave = { name, information in
            self.viewModel.save(title: name, subtitle: information)
        }
        self.navigationController?.pushViewController(AddViewController, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return tasks.count
        default:
            return historyTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath) as! TaskCell
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.titleLabel.text = tasks[indexPath.row].name
            cell.subtitleLabel.text = tasks[indexPath.row].information
        default:
            cell.titleLabel.text = historyTasks[indexPath.row].name
            cell.subtitleLabel.text = historyTasks[indexPath.row].information
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.showDeleteAlert(task: self.tasks[indexPath.row])
            default:
                self.showDeleteAlert(task: self.historyTasks[indexPath.row])
            }
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Mark As Completed") { [weak self] (_, _, completionHandler)  in
            guard let self = self else { return }
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.tasks[indexPath.row].isCompleted.toggle()
            default:
                self.historyTasks[indexPath.row].isCompleted.toggle()
            }
            self.reloadTableView()
            self.viewModel.update()
            completionHandler(true)
        }
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            action.title = "Mark as completed"
            action.backgroundColor = .systemGreen
        default:
            action.title = "Mark as incomplete"
            action.backgroundColor = .systemOrange
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task: Task
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            task = self.tasks[indexPath.row]
        default:
            task = self.historyTasks[indexPath.row]
        }
        self.showEdtiViewController(task: task)
    }
}


