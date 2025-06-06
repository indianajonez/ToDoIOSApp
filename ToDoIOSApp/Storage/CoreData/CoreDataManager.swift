//
//  CoreDataManager.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 02.06.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    // ⚠️ Сделано var, чтобы можно было переопределить в тестах
    var persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка при загрузке хранилища: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении: \(error)")
            }
        }
    }
}

extension CoreDataManager {
    func overrideContainer(_ container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    static func inMemory(modelName: String = "TaskModel") -> CoreDataManager {
        let instance = CoreDataManager()

        guard let modelURL = Bundle(for: CoreDataManager.self).url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("❌ Не удалось найти или загрузить модель данных \(modelName)")
        }

        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Не удалось загрузить inMemory хранилище: \(error)")
            } else {
                print("✅ In-memory CoreData загружен с моделью: \(modelName)")
            }
        }

        instance.persistentContainer = container
        return instance
    }
}

