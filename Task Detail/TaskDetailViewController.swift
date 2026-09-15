import UIKit
import PhotosUI
import MapKit

class TaskDetailViewController: UIViewController {

    private let task: Task
    private let completedImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let attachPhotoButton = UIButton(type: .system)
    private let viewPhotoButton = UIButton(type: .system)
    private let mapView = MKMapView()


    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        view.backgroundColor = .systemBackground

        setupViews()

        mapView.register(TaskAnnotationView.self, forAnnotationViewWithReuseIdentifier: TaskAnnotationView.identifier)

        mapView.delegate = self

        updateUI()
        updateMapView()
    }

    private func setupViews() {
        completedImageView.translatesAutoresizingMaskIntoConstraints = false
        completedImageView.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 0

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        attachPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        attachPhotoButton.setTitle("Attach Photo", for: .normal)
        attachPhotoButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        attachPhotoButton.addTarget(self, action: #selector(didTapAttachPhotoButton), for: .touchUpInside)

        viewPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        viewPhotoButton.setTitle("View Photo", for: .normal)
        viewPhotoButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        viewPhotoButton.addTarget(self, action: #selector(didTapViewPhotoButton), for: .touchUpInside)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 12
        mapView.clipsToBounds = true

        let titleStack = UIStackView(arrangedSubviews: [completedImageView, titleLabel])
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.alignment = .center

        view.addSubview(titleStack)
        view.addSubview(descriptionLabel)
        view.addSubview(attachPhotoButton)
        view.addSubview(mapView)
        view.addSubview(viewPhotoButton)

        let margin = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            completedImageView.widthAnchor.constraint(equalToConstant: 32),
            completedImageView.heightAnchor.constraint(equalToConstant: 32),

            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleStack.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            titleStack.trailingAnchor.constraint(equalTo: margin.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),

            attachPhotoButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            attachPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            mapView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            mapView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300),

            viewPhotoButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            viewPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    private func updateUI() {
        titleLabel.text = task.title
        descriptionLabel.text = task.description

        let imageName = task.isComplete ? "checkmark.circle.fill" : "circle"
        completedImageView.image = UIImage(systemName: imageName)
        completedImageView.tintColor = task.isComplete ? .systemGreen : .systemGray3

        attachPhotoButton.isHidden = task.isComplete
        mapView.isHidden = !task.isComplete
        viewPhotoButton.isHidden = !task.isComplete
    }

    private func updateMapView() {
        guard let imageLocation = task.imageLocation else { return }

        let coordinate = imageLocation.coordinate

        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }


    @objc private func didTapAttachPhotoButton() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self?.presentImagePicker()
                    }
                default:
                    DispatchQueue.main.async {
                        self?.presentGoToSettingsAlert()
                    }
                }
            }
        } else {
            presentImagePicker()
        }
    }

    @objc private func didTapViewPhotoButton() {
        let photoVC = PhotoViewController()
        photoVC.task = task
        navigationController?.pushViewController(photoVC, animated: true)
    }

    private func presentImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())

        config.filter = .images

        config.preferredAssetRepresentationMode = .current

        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)

        picker.delegate = self

        present(picker, animated: true)
    }

    private func presentGoToSettingsAlert() {
        let alert = UIAlertController(
            title: "Photo Access Required",
            message: "Please allow photo library access in Settings to attach a photo.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }

    private func showAlert(for error: Error) {
        let alert = UIAlertController(
            title: "Oops...",
            message: "\(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TaskDetailViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let result = results.first

        guard let assetId = result?.assetIdentifier,
              let location = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject?.location else {
            return
        }

        print("📍 Image location coordinate: \(location.coordinate)")

        guard let provider = result?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

            if let error = error {
                DispatchQueue.main.async { self?.showAlert(for: error) }
            }

            guard let image = object as? UIImage else { return }

            print("🌉 We have an image!")

            DispatchQueue.main.async {
                self?.task.set(image, with: location)

                self?.updateUI()

                self?.updateMapView()
            }
        }
    }
}

extension TaskDetailViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: TaskAnnotationView.identifier, for: annotation) as? TaskAnnotationView else {
            fatalError("Unable to dequeue TaskAnnotationView")
        }

        annotationView.configure(with: task.image)
        return annotationView
    }
}
