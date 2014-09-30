//
//  Comment.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"

@interface Comment : Element

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *fromUser;
@property (nonatomic, strong) NSString *toUser;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *content;

@end
