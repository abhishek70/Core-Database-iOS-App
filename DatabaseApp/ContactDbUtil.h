//
//  ContactDbUtil.h
//  DatabaseApp
//
//  Created by Abhishek Desai on 8/10/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Contact.h"

@interface ContactDbUtil : NSObject {
    sqlite3 *mySqliteDB;
}

@property (nonatomic, strong) NSString *databasePath;
- (void) initDatabase;
- (BOOL) saveContact:(Contact *)contact;
- (BOOL) deleteContact:(NSInteger)Id;
- (NSMutableArray *) getContacts;
- (Contact *) getContact:(NSInteger) Id;
@end
