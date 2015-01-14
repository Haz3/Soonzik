//
//  Commentary.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"

@interface Commentary : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *fromUser;
@property (nonatomic, strong) NSString *toUser;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *content;

@end
