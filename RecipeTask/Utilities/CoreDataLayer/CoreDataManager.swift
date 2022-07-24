//
//  CoreDataManager.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-23.
//

import Foundation
import CoreData
import UIKit

public class CoreDataManager {
    
    static public let shared = CoreDataManager()
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveSearchData(s: SearchCD) {
       
        let search = SearchCD(context: context())
        var arr = getSearchData()
        if arr.count > 10 {
            arr.remove(at: 0)
            for srhElement in arr {
                search.id = srhElement.id
                search.key = srhElement.key
            }
        }
        search.id = s.id
        search.key = search.key
       
        do {
            try context().save()
            print("✅ Success")
        } catch let error as NSError {
            print(error)
        }
        
        
    }
    
    
    func countSearchData() -> Int {
        let context = context()
        let fetchRequest: NSFetchRequest<SearchCD> = SearchCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        return objects.count
    }
    
    func clearSearchData() {
        let context = context()
        let fetchRequestSearch: NSFetchRequest<SearchCD> = SearchCD.fetchRequest()
        let objects = try! context.fetch(fetchRequestSearch)
        
        for obj in objects {
            context.delete(obj)
        }
        
        do {
            try context.save()
        } catch {
            print("❌ Error Delete Object")
        }
    }
    
    
    func getSearchData() -> [SearchCD] {
        let context = context()
        let fetchRequest: NSFetchRequest<SearchCD> = SearchCD.fetchRequest()
        guard let objects = try? context.fetch(fetchRequest) else{return []}
        return objects
    }
    
}
extension CoreDataManager{
    
    
    func context() ->  NSManagedObjectContext {
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func save() {
        appDelegate.saveContext()
    }
    
    
}

