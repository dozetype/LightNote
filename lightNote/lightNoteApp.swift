//
//  lightNoteApp.swift
//  lightNote
//
//  Created by Xing Wei on 18/6/25.
//

import SwiftUI

@main
struct lightNoteApp: App {
    var body: some Scene {
        MenuBarExtra{
            ContentView()
        } label: {
            Label("LightNote", systemImage: "note.text")
        }
        .menuBarExtraStyle(.window)
    }
}
