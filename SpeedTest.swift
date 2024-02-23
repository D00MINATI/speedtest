import Foundation
import Combine

class SpeedTest: ObservableObject {
    @Published var downloadSpeed: Double = 0.0
    @Published var totalDownloaded: Double = 0.0
    @Published var totalElapsedTime: TimeInterval = 0.0

    init() {} // Add an initializer if needed

    func startDownload() {
        // Simulate download process
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            // Update properties with dummy values
            DispatchQueue.main.async {
                self.downloadSpeed = 10.0
                self.totalDownloaded = 1024.0
                self.totalElapsedTime = 5.0
            }
        }
    }
}
