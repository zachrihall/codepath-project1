import UIKit

class PhotoViewController: UIViewController {

    private let photoView = UIImageView()

    var task: Task!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        view.backgroundColor = .systemBackground

        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFit
        photoView.image = task.image
        view.addSubview(photoView)

        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
