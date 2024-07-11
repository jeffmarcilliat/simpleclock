//
//  simpleclockApp.swift
//  simpleclock
//
//  Created by Jeffrey Marcilliat on 7/10/24.
//

import SwiftUI

@main
struct ClockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 300, height: 300)
        .windowStyle(.plain)
        .windowResizability(.contentSize)
//        .windowManagerRole(.automatic)
    }
}
