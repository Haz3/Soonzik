//
//  NewsTypeAlbumCell.h
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "ShareNewsDelegate.h"

@interface NewsTypeAlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellContent;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) News *news;

@property (nonatomic, strong) id<ShareNewsDelegate>shareDelegate;

- (void)initCellWithNews:(News *)news;

@end
