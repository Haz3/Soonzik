//
//  Message.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"
#import "User.h"

@interface Message : Element

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) User *fromUser;
@property (nonatomic, strong) User *toUser;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *content;

@end
