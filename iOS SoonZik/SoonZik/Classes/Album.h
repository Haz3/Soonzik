//
//  Album.h
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Album : NSObject

@property (nonatomic, assign) int identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) User *artist;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSDate *date;

@end
