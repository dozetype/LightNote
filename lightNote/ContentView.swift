//
//  ContentView.swift
//  LightNote
//
//  Created by Xing Wei on 18/6/25.
//

import SwiftUI

func writeFile(text: String, fileURL: URL){
    do {
        try text.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    catch {
        print("Error writing: \(error.localizedDescription)")
    }
}

func removeFile(fileURL: URL){
    let fileManager = FileManager.default
    let allowedExtensions = ["txt", "md", "log"]
    //ONLY LISTED EXTENSIONS
    guard allowedExtensions.contains(fileURL.pathExtension.lowercased()) else {
        return
    }
    
    do {
        try fileManager.removeItem(at: fileURL)
    } catch {
        print("Error: \(error)")
    }
}

func readFile(from path: String) -> String? {
    let fileURL = URL(fileURLWithPath: path)

    do {
        let contents = try String(contentsOf: fileURL, encoding: .utf8)
        return contents
    } catch {
        return ""
    }
}


struct ContentView: View {
    @State private var path: String = "/Users/"
    @State private var textword: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $textword)
                .frame(width: 320, height: 250)
                .border(Color.accentColor, width: 1)
                .font(.system(size: 13, design: .monospaced))
                .padding(5)

            
            HStack {
                Spacer()
                TextField("Your Path", text: $path)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250)
                Spacer()
            }
            
            HStack {
                // Left-aligned
                Button("Save") {
                    writeFile(text: textword, fileURL: URL(filePath: path))
                }
                .keyboardShortcut("s", modifiers: .command)
                .padding(5)

                Spacer()

                // Center-aligned
                Button("Load") {
                    if let contents = readFile(from: path) {
                        textword = contents
                    }
                }

                Spacer()
                
                // Right-aligned
                Button("Delete") {
                    let url = URL(filePath: path)
                    removeFile(fileURL: url)
                }
                .padding(5)
            
            }
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
}
