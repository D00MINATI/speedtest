import SwiftUI

struct ContentView: View {
    @State private var speedTest = SpeedTest()
    @State private var networkManager = NetworkManager()

    var body: some View {
        VStack {
            Text("Network Information")
                .font(.headline)
            
            Text("Download Speed: \(networkManager.downloadSpeed) Mbps")
                .padding()
            Text("Total Downloaded: \(networkManager.totalDownloaded) MB")
                .padding()
            Text("Total Elapsed Time: \(networkManager.totalElapsedTime) sec")
                .padding()
            
            Button("Start Speed Test") {
                speedTest.startDownload()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onReceive(speedTest.$onCompletion) { data in
            let (speed, _, totalDownloaded, totalElapsedTime) = data
            networkManager.downloadSpeed = String(format: "%.4f", speed)
            networkManager.totalDownloaded = String(format: "%.4f", totalDownloaded / 1_000_000)
            networkManager.totalElapsedTime = String(format: "%.2f", totalElapsedTime)
        }
    }
}
