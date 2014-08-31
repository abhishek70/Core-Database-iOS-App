//
//  Contact.h
//  DatabaseApp
//
//  Created by Abhishek Desai on 8/10/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic) NSInteger Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;

@end
