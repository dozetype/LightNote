//
//  ContentView.swift
//  LightNote
//
//  Created by Xing Wei on 18/6/25.
//

import SwiftUI

private func writeFile(text: String, fileURL: URL){
    do {
        try text.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
    }
}

private func removeFile(fileURL: URL){
    let fileManager = FileManager.default
    let allowedExtensions = ["txt", "md", "log"]
    //ONLY LISTED EXTENSIONS
    guard allowedExtensions.contains(fileURL.pathExtension.lowercased()) else {
        return
    }
    
    do {
        try fileManager.removeItem(at: fileURL)
    } catch {
    }
}

private func readFile(filePath: String) -> String {
    do {
        let contents = try String(contentsOf: URL(fileURLWithPath: filePath), encoding: .utf8)
        return contents
    } catch {
        return ""
    }
}

struct ContentView: View {
    @State private var path: String = UserDefaults.standard.string(forKey: "recentFilePath") ?? "/Users/"
    @State private var textWords: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Text Editor
            TextEditor(text: $textWords)
                .frame(width: 320, height: 250)
                .border(Color.accentColor, width: 1)
                .font(.system(size: 13, design: .monospaced))
                .padding(5)

            // Path Input
            HStack {
                Spacer()
                TextField("Your Path", text: $path)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250)
                Spacer()
            }
            
            // Buttons: Save / Load / Delete
            HStack {
                // Left-aligned
                Button("Save") {
                    writeFile(text: textWords, fileURL: URL(fileURLWithPath: path))
                    storePath()
                }
                .keyboardShortcut("s", modifiers: .command)
                .padding(5)

                Spacer()

                // Center-aligned
                Button("Load") {
                    textWords = readFile(filePath: path)
                    storePath()
                }

                Spacer()
                
                // Right-aligned
                Button("Delete") {
                    removeFile(fileURL: URL(fileURLWithPath: path))
                    storePath()
                }
                .padding(5)
            
            }
            
            // Quit Button
            .safeAreaInset(edge: .bottom){
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Label("Quit", systemImage: "power")
                }.buttonStyle(.borderless).foregroundColor(.accentColor)
            }
            .frame(width: 330)
        }
    }
    
    private func storePath() {
        UserDefaults.standard.set(path, forKey: "recentFilePath")
    }
}
