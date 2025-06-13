//
//  CoreDataManager.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 02.06.2025.
//

import Foundation
import CoreData

final class CoreDataManager {

    // MARK: - Singleton

    static let shared = CoreDataManager()

    // MARK: - Core Data Stack

    private(set) var persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Initializer

    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Ошибка при загрузке хранилища: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Save Context

    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            // Лучше использовать логгер или краш-репортинг
            NSLog("❌ Ошибка при сохранении контекста: \(error.localizedDescription)")
        }
    }
}

// MARK: - For Unit Tests & In-Memory Store

extension CoreDataManager {

    /// Позволяет заменить persistentContainer (например, для тестов)
    func overrideContainer(_ container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    /// Создаёт in-memory CoreDataManager для юнит-тестов
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
                fatalError("❌ Не удалось загрузить in-memory хранилище: \(error.localizedDescription)")
            } else {
                NSLog("✅ In-memory CoreData загружен с моделью: \(modelName)")
            }
        }

        instance.persistentContainer = container
        return instance
    }
}

