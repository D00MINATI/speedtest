//
//  ContentView.swift
//  White Dragon
//
//  Created by splitmine on 2/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var speedTest = SpeedTest()
    @State private var downloadSpeed = "Download Speed: N/A"
    @State private var totalDownloaded = "Total Downloaded: 0 MB"

    var body: some View {
        VStack {
            Button("Start Speed Test") {
                speedTest.onCompletion = { speed, fileSize in
                    self.downloadSpeed = "Download Speed: \(speed) Mbps"
                    self.totalDownloaded = "Total Downloaded: \(SpeedTest.getTotalDownloadedSize()) MB"
                }
                speedTest.startDownload()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Text(downloadSpeed)
                .padding()
            Text(totalDownloaded)
                .padding()
        }
    }
}




