//
//  LoadingView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *loadingV;

+ (id)loadingViewInView:(UIView *)aSuperview;

@end
