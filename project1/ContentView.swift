import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        TaskListView()
            .ignoresSafeArea()
    }
}

struct TaskListView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: TaskListViewController())
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview {
    ContentView()
}
