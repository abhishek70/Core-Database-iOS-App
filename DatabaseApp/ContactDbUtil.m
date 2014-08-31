//
//  ContactDbUtil.m
//  DatabaseApp
//
//  Created by Abhishek Desai on 8/10/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import "ContactDbUtil.h"

@implementation ContactDbUtil

@synthesize databasePath;

- (void) initDatabase {
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    //the file will not be there when we load the application for the first time
    //so this will create the database table
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
        {
            char *errMsg;
            NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS CONTACTS (";
            sql_stmt = [sql_stmt stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"name TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"phone TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"email TEXT)"];
            
            if (sqlite3_exec(mySqliteDB, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            else
            {
                NSLog(@"Contact table created successfully");
            }
            
            sqlite3_close(mySqliteDB);
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    
}

//save our data
- (BOOL) saveContact:(Contact *)contact
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        if (contact.Id > 0) {
            NSLog(@"Exitsing data, Update Please");
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE CONTACTS set name = '%@', phone = '%@', email = '%@' WHERE id = ?",
                                   contact.name,
                                   contact.phone,
                                   contact.email];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, update_stmt, -1, &statement, NULL );
            sqlite3_bind_int(statement, 1, contact.Id);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"New data, Insert Please");
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO CONTACTS (name, phone, email) VALUES (\"%@\", \"%@\", \"%@\")",
                                   contact.name,
                                   contact.phone,
                                   contact.email];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
}

//get a list of all our contacts
- (NSMutableArray *) getContacts
{
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT id, name, phone, email FROM CONTACTS";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Contact *contact = [[Contact alloc] init];
                contact.Id = sqlite3_column_int(statement, 0);
                contact.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                contact.phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                contact.email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [contactList addObject:contact];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
    }
    
    return contactList;
}

//get information about a specfic contact by it's id
- (Contact *) getContact:(NSInteger)Id
{
    Contact *contact = [[Contact alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT id, name, phone, email FROM CONTACTS WHERE id=%d",
                              Id];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                contact.Id = sqlite3_column_int(statement, 0);
                contact.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                contact.phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                contact.email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
    }
    
    return contact;
}

//delete the contact from the database
- (BOOL) deleteContact:(NSInteger)Id
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        if (Id >= 0) {
            NSLog(@"Exitsing data, Delete Please");
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from CONTACTS WHERE id = %d", Id];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, delete_stmt, -1, &statement, NULL );
            //sqlite3_bind_int(statement, 1, Id);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"New data, Nothing to delete");
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
}

@end
