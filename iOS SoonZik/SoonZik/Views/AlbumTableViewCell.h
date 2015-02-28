//
//  AlbumTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicOptionsButton.h"

@interface AlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *musicTitle;
@property (nonatomic, weak) IBOutlet UILabel *musicLength;
@property (nonatomic, weak) IBOutlet MusicOptionsButton *optionsButton;

- (void)initCell;

@end
