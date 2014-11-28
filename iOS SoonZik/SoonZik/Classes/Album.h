//
//  Album.h
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"
#import "User.h"
#import "Music.h"

@interface Album : Element

@property (nonatomic, assign) int identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) User *artist;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSMutableArray *listOfMusics;

@end
