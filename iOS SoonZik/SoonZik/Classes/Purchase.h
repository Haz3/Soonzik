//
//  Purchase.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"
#import "Album.h"
#import "Pack.h"
#import "Music.h"

@interface Purchase : Element

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Pack *pack;
@property (nonatomic, strong) Music *music;
@property (nonatomic, strong) NSDate *date;

@end
