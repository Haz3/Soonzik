//
//  LongPressGestureRecognizer.h
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface LongPressGestureRecognizer : UILongPressGestureRecognizer

@property (strong, nonatomic) Song *song;

@end
