//
//  FirstLaunchViewController.h
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLaunchViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, weak) IBOutlet UIButton *connexionButton;

@property (nonatomic, assign) int index;

@property (nonatomic, assign) int imageWidth;
@property (nonatomic, assign) int imageHeight;


@end
