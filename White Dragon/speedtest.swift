import Foundation

class SpeedTest {
    private var startTime: TimeInterval?
    private var endTime: TimeInterval?
    private let url = URL(string: "https://storage.googleapis.com/whitedragonspeedtest/testfile.bin")!
    
    static var totalDownloadedSize: Int64 = 0 // Static property to track total downloaded size
    
    var onCompletion: ((Double, Int64) -> Void)? // Closure to return speed and file size
    
    func startDownload() {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        startTime = Date().timeIntervalSince1970
        let downloadTask = session.downloadTask(with: url) { [weak self] (location, response, error) in
            guard let self = self else { return }
            self.endTime = Date().timeIntervalSince1970
            
            if let error = error {
                print("Download error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response, let location = location else {
                print("Server response error")
                return
            }
            
            let fileSize = response.expectedContentLength // The size of the file
            
            // Update the total downloaded size
            SpeedTest.totalDownloadedSize += fileSize
            
            let fileManager = FileManager.default
            do {
                let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let savedURL = documentsURL.appendingPathComponent(response.suggestedFilename ?? "testfile.bin")
                
                if fileManager.fileExists(atPath: savedURL.path) {
                    try fileManager.removeItem(at: savedURL)
                }
                
                try fileManager.moveItem(at: location, to: savedURL)
                
                // Calculate download speed and report size
                self.calculateSpeedAndReportSize(fileSize: fileSize)
            } catch {
                print("File error: \(error.localizedDescription)")
            }
        }
        downloadTask.resume()
    }
    
    private func calculateSpeedAndReportSize(fileSize: Int64) {
        guard let startTime = startTime, let endTime = endTime else { return }
        let timeTaken = endTime - startTime // Time taken in seconds
        let sizeInMegabits = Double(fileSize) * 8 / 1_000_000 // Size in Megabits
        let speed = sizeInMegabits / timeTaken // Speed in Mbps
        
        DispatchQueue.main.async {
            print("Downloaded... \(fileSize) bytes (\(Double(fileSize) / 1_000_000) MB)")
            print("Download Speed: \(speed) Mbps")
            // Ensure the completion handler is called with the correct parameters.
            self.onCompletion?(speed, fileSize)
        }
    }
    
    // Method to get the total downloaded size
    static func getTotalDownloadedSize() -> String {
        let sizeInMB = Double(totalDownloadedSize) / 1_000_000
        return "\(sizeInMB) MB"
    }
}
