//
//  AddContactViewController.h
//  DatabaseApp
//
//  Created by Abhishek Desai on 8/7/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDbUtil.h"
#import "Contact.h"

@interface AddContactViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *phone;

@property (nonatomic) NSInteger Id;
@property (strong, nonatomic) ContactDbUtil *contactDbUtil;

- (IBAction)Save:(id)sender;
- (IBAction)Reset:(id)sender;

@end
