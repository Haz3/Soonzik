//
//  ExploreCollectionViewCell.h
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgV;
@property (nonatomic, weak) IBOutlet UIView *titleView;

- (void)initCell;

@end
