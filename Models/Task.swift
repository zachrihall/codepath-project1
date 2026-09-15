import UIKit
import CoreLocation

class Task {

    let title: String
    let description: String

    // The photo attached to prove the task was completed.
    var image: UIImage?
    var imageLocation: CLLocation?
    var isComplete: Bool {
        image != nil
    }

    init(title: String, description: String, image: UIImage? = nil, imageLocation: CLLocation? = nil) {
        self.title = title
        self.description = description
        self.image = image
        self.imageLocation = imageLocation
    }

    func set(_ image: UIImage?, with location: CLLocation?) {
        self.image = image
        self.imageLocation = location
    }
}

extension Task {
    static var mockedTasks: [Task] {
        [
            Task(title: "Find a red door",
                 description: "Snap a photo of any red door you come across."),
            Task(title: "Spot a squirrel",
                 description: "Take a picture of a squirrel in the wild."),
            Task(title: "Visit a coffee shop",
                 description: "Grab a photo of your favorite local coffee shop.")
        ]
    }
}
