//
//  FileManager.swift
//  spark-todo-list
//
//  Created by Parama Artha on 08/04/25.
//

import Foundation

class FileManagerService: ObservableObject {
    private let fileName = "tasks.json"

    // MARK: - File Handling
    
    func saveToFile(tasks:[Task]) {
        let url = getFileURL()
        if let data = try? JSONEncoder().encode(tasks) {
            try? data.write(to: url)
        }
    }

    func loadFromFile() -> [Task]? {
        let url = getFileURL()
        if let data = try? Data(contentsOf: url),
           let loadedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            return loadedTasks
        }
        return nil
    }

    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
}
