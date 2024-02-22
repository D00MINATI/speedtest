//
//  SpeedTest.swift
//  White Dragon
//
//  Created by splitmine on 2/22/24.
//

import Foundation

class SpeedTest {
    private var startTime: Date?
    private var endTime: Date?
    private var totalDownloadedSize: Int64 = 0
    private var totalElapsedTime: TimeInterval = 0
    
    var onCompletion: ((Double, Int64, Double, Double) -> Void)?
    
    func startDownload() {
        guard let url = URL(string: "https://storage.googleapis.com/whitedragonspeedtest/testfile.bin") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { [weak self] (location, response, error) in
            guard let self = self else { return }
            
            guard error == nil else {
                print("Download error: \(error!.localizedDescription)")
                return
            }
            
            guard let location = location else {
                print("Invalid location")
                return
            }
            
            do {
                let fileSize = try FileManager.default.attributesOfItem(atPath: location.path)[.size] as? Int64 ?? 0
                self.totalDownloadedSize += fileSize
                let elapsedTime = self.endTime?.timeIntervalSince(self.startTime!) ?? 0
                let speed = Double(fileSize) / (elapsedTime == 0 ? 1 : elapsedTime) / 1_000_000
                self.onCompletion?(speed, fileSize, Double(self.totalDownloadedSize), elapsedTime)
            } catch {
                print("File error: \(error.localizedDescription)")
            }
        }
        
        startTime = Date()
        task.resume()
    }
}
