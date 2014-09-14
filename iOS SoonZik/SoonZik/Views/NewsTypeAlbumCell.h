//
//  NewsTypeAlbumCell.h
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@protocol NewsTypeAlbumDelegate <NSObject>

- (void)launchShareViewWithNews:(News *)news;

@end

@interface NewsTypeAlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellContent;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) News *news;

@property (nonatomic, strong) id<NewsTypeAlbumDelegate>shareDelegate;

- (void)initCellWithNews:(News *)news;

@end
