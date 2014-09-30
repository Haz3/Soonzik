//
//  AlbumSongCell.h
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllTheIncludes.h"

@interface AlbumSongCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *numberInTheAlbum;
@property (nonatomic, weak) IBOutlet UILabel *songTitle;
@property (nonatomic, weak) IBOutlet UILabel *duration;

- (void)initCell;

@end
