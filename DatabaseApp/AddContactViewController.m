//
//  AddContactViewController.m
//  DatabaseApp
//
//  Created by Abhishek Desai on 8/7/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()

@end

@implementation AddContactViewController

@synthesize Id;
@synthesize name;
@synthesize email;
@synthesize phone;
@synthesize contactDbUtil;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contactDbUtil = [[ContactDbUtil alloc] init];
        [contactDbUtil initDatabase];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //well if we have the contact if then its an edit mode
    //load the existing values
    if(self.Id > 0){
        Contact *contact = [[Contact alloc] init];
        contact = [contactDbUtil getContact:self.Id];
        name.text = contact.name;
        phone.text = contact.phone;
        email.text = contact.email;
    }
    //add mode clear our fields
    else {
        name.text = @"";
        phone.text = @"";
        email.text = @"";
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self hideKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Function for saving the user data to the database.
 */
- (IBAction)Save:(id)sender {
    
    Contact *contact = [[Contact alloc] init];
    contact.Id = self.Id;
    contact.name = self.name.text;
    contact.phone = self.phone.text;
    contact.email = self.email.text;
    [contactDbUtil saveContact:contact];
    
    [self hideKeyboard];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * Function for resetting the user data fields.
 */
- (IBAction)Reset:(id)sender {
    
    name.text = @"";
    phone.text = @"";
    email.text = @"";
}

/*
 * Function for removing the keyboard based on the selected textfield.
 */
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == name) {
        [textField resignFirstResponder];
    } else if (textField == email) {
        [textField resignFirstResponder];
    } else if (textField == phone) {
        [textField resignFirstResponder];
    }
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == phone) {
        [self animateTextField: textField up: YES];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == phone) {
        [self animateTextField: textField up: NO];
    }
}

/*
 * Function for moving the view by predefine offset to avoid hiding of the save and reset button.
 */
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

/*
 * Function for hiding the keyboard whenever the user save the data or click on the back navigation button.
 */
- (void) hideKeyboard
{
    [name resignFirstResponder];
    [email resignFirstResponder];
    [phone resignFirstResponder];
}

@end
