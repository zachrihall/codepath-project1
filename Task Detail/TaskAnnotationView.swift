//
//  TaskAnnotationView.swift
//  project1
//
//  A custom map annotation view that displays the task's attached photo.
//

import MapKit

class TaskAnnotationView: MKAnnotationView {

    /// Reuse identifier used to register and dequeue this annotation view.
    static let identifier = "TaskAnnotationView"

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let pointView = UIView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    /// Sets the image shown inside the annotation.
    func configure(with image: UIImage?) {
        imageView.image = image
    }

    private func setupViews() {
        // The small rotated square that forms the "pin point" at the bottom.
        pointView.translatesAutoresizingMaskIntoConstraints = false
        pointView.backgroundColor = .white
        pointView.transform = CGAffineTransform(rotationAngle: .pi / 4)
        addSubview(pointView)

        // Container that holds the image.
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.clipsToBounds = true
        addSubview(containerView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 80),
            containerView.heightAnchor.constraint(equalToConstant: 80),

            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            pointView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pointView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            pointView.widthAnchor.constraint(equalToConstant: 16),
            pointView.heightAnchor.constraint(equalToConstant: 16),
            pointView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Anchor the view so its bottom point sits on the coordinate.
        centerOffset = CGPoint(x: 0, y: -48)
    }
}
