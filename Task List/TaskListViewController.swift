import UIKit

class TaskListViewController: UITableViewController {

    private var tasks = Task.mockedTasks

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")

        // "+" button to add a new task.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload so completion status updates after returning from the detail screen.
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = task.title
        // Show a completion indicator to the left of the title.
        let imageName = task.isComplete ? "checkmark.circle.fill" : "circle"
        content.image = UIImage(systemName: imageName)
        content.imageProperties.tintColor = task.isComplete ? .systemGreen : .systemGray3
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = TaskDetailViewController(task: tasks[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }


    @objc private func didTapAddButton() {
        let alert = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Description" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak alert] _ in
            guard let self, let alert else { return }
            let title = alert.textFields?[0].text ?? ""
            let description = alert.textFields?[1].text ?? ""
            guard !title.isEmpty else { return }
            self.tasks.append(Task(title: title, description: description))
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }
}
