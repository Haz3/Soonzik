//
//  Music.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "Genre.h"
#import "User.h"
#import "Comment.h"

@interface Music : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int duration;
@property (nonatomic, strong) Genre *genre;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) User *artist;
@property (nonatomic, strong) NSString *image;
//@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) NSArray *listOfComments;
@property (nonatomic, assign) int isLimited;

@end
