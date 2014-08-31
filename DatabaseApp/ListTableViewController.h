//
//  ListTableViewController.h
//  DatabaseApp
//
//  Created by Abhishek Desai on 8/7/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContactViewController.h"
#import "Contact.h"
#import "ContactDbUtil.h"

@interface ListTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) AddContactViewController *addContactViewController;
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) ContactDbUtil *contactDbUtil;

@property (strong, nonatomic) NSMutableArray *contactList;

@end
