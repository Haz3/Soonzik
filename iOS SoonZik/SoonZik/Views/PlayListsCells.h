//
//  PlayListsCells.h
//  SoonZik
//
//  Created by LLC on 25/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface PlayListsCells : UITableViewCell// SWTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *trackTitle;
@property (nonatomic, weak) IBOutlet UIImageView *trackImage;

- (void)initCell;

@end
