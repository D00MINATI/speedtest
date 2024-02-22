//
//  NetworkManager.swift
//  White Dragon
//
//  Created by splitmine on 2/22/24.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    private var monitor: NWPathMonitor?
    
    @Published var downloadSpeed = "N/A"
    @Published var totalDownloaded = "0"
    @Published var totalElapsedTime = "0"
    
    init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                // Implement network monitoring logic here if needed
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor?.cancel()
    }
}
