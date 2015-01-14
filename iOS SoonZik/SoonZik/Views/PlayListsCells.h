//
//  PlayListsCells.h
//  SoonZik
//
//  Created by LLC on 25/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "MusicOptionsButton.h"

@interface PlayListsCells : UITableViewCell// SWTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *trackTitle;
@property (nonatomic, weak) IBOutlet UILabel *trackArtist;
@property (nonatomic, weak) IBOutlet MusicOptionsButton *optionsButton;

- (void)initCell;

@end
