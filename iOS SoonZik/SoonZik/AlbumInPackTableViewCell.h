//
//  AlbumInPackTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 30/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumInPackTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *albumLabel;

- (void)initCell;

@end
