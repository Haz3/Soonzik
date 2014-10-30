//
//  LongPressGestureRecognizer.h
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "Playlist.h"

@interface LongPressGestureRecognizer : UILongPressGestureRecognizer

@property (strong, nonatomic) Music *song;
@property (strong, nonatomic) Playlist *playlist;

@end
