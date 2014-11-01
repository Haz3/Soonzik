//
//  User.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"
#import "Address.h"
#import "Factory.h"

@interface User : Element

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *phoneNbr;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSString *facebook;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *google;
@property (nonatomic, strong) NSString *idAPI;
@property (nonatomic, strong) NSArray *follows;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, assign) bool isAnArtist;

@end
