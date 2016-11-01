//
//  DBManager.swift
//  salamiha
//
//  Created by Admin on ۱۳۹۵/۵/۱۷ ه‍.ش..
//  Copyright © ۱۳۹۵ ه‍.ش. mhmhb. All rights reserved.
//

import UIKit
import GRDB

class DBManager: NSObject {
    
    // The shared database queue
    //var dbQueue: DatabaseQueue!

    ///Create databse for contacts if needed
    static func setupDatabase(application: UIApplication)  {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let url = NSURL(fileURLWithPath: documentsPath as String)
        
        let filePath = url.appendingPathComponent("media_item.sqlite")?.path
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: filePath!) {
            
            
            // Connect to the database
            let databasePath = documentsPath.appendingPathComponent("media_item.sqlite")
            
            let dbQueue = try! DatabaseQueue(path: databasePath)
            
            
            // Be a nice iOS citizen, and don't consume too much memory
            
            dbQueue.setupMemoryManagement(in: application)
            
            
            // Use DatabaseMigrator to setup the database
            
            var migrator = DatabaseMigrator()
            
           try? dbQueue.inDatabase { db in
                try db.create(table: "Media") { t in
                    t.column("media_name", .text).notNull()
                    t.column("media_id", .text).notNull()
                    t.column("media_pic", .integer).notNull()
                    t.column("media_url", .text).notNull()
                    t.column("media_singer", .text).notNull()
                    t.column("media_singer_id", .text).notNull()
                    t.column("media_type", .text).notNull()
                    t.column("media_service_type", .text).notNull()
                    t.column("media_irancell", .text).notNull()
                    t.column("media_hamrahaval", .text).notNull()
                    t.column("media_time", .text).notNull()
                    t.column("media_share", .text).notNull()
                    t.column("id", .integer).primaryKey(onConflict: Database.ConflictResolution.ignore, autoincrement: true).notNull()
                }
            }
            
            try? dbQueue.inDatabase { db in
                try db.create(table: "Favorites") { t in
                    t.column("media_name", .text).notNull()
                    t.column("media_id", .text).notNull()
                    t.column("media_pic", .integer).notNull()
                    t.column("media_url", .text).notNull()
                    t.column("media_singer", .text).notNull()
                    t.column("media_singer_id", .text).notNull()
                    t.column("media_type", .text).notNull()
                    t.column("media_service_type", .text).notNull()
                    t.column("media_irancell", .text).notNull()
                    t.column("media_hamrahaval", .text).notNull()
                    t.column("media_time", .text).notNull()
                    t.column("media_share", .text).notNull()
                    t.column("id", .integer).primaryKey(onConflict: Database.ConflictResolution.ignore, autoincrement: true).notNull()
                }
            }
            
            try? dbQueue.inDatabase { db in
                try db.create(table: "Likes") { t in
                    t.column("media_id", .text).notNull()
                    t.column("media_type", .text).notNull()
                    t.column("media_service_type", .text).notNull()
                    t.column("id", .integer).primaryKey(onConflict: Database.ConflictResolution.ignore, autoincrement: true).notNull()
                }
            }
            
//            migrator.registerMigration("MediaItems") { db in
//                // Compare person names in a localized case insensitive fashion
//                try db.create(table: "MediaItems") { t in
//                    t.column("media_name", .text).notNull()
//                    t.column("media_id", .text).notNull()
//                    t.column("media_pic", .integer).notNull()
//                    t.column("media_url", .text).notNull()
//                    t.column("media_singer", .text).notNull()
//                    t.column("media_singer_id", .text).notNull()
//                    t.column("media_type", .text).notNull()
//                    t.column("media_service_type", .text).notNull()
//                    t.column("media_irancell", .text).notNull()
//                    t.column("media_hamrahaval", .text).notNull()
//                    t.column("media_time", .text).notNull()
//                    t.column("media_share", .text).notNull()
//                    t.column("id", .integer).primaryKey(onConflict: Database.ConflictResolution.fail, autoincrement: true)
//                }
//            }
            
//            migrator.registerMigration("MediaLikes") { db in
//                // Compare person names in a localized case insensitive fashion
//                try db.create(table: "MediaLikes") { t in
//                    t.column("media_id", .text).notNull()
//                    t.column("media_type", .text).notNull()
//                    t.column("media_service_type", .text).notNull()
//                    t.column("id", .integer).primaryKey(onConflict: Database.ConflictResolution.fail, autoincrement: true)
//                }
//            }
            
            try! migrator.migrate(dbQueue)
        }
    }
}
