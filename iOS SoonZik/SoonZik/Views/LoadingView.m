//
//  LoadingView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

+ (id)loadingViewInView:(UIView *)aSuperview
{
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:[aSuperview bounds]];
    UIView *loadingContentView = [[UIView alloc] initWithFrame:CGRectMake(aSuperview.frame.size.width/2-100/2, aSuperview.frame.size.height/2-100/2, 100, 100)];
    loadingContentView.backgroundColor = [UIColor blackColor];
    loadingContentView.layer.borderColor = [UIColor blackColor].CGColor;
    loadingContentView.layer.borderWidth = 1;
    loadingContentView.layer.cornerRadius = 10.0f;
    loadingContentView.layer.masksToBounds = false;
    loadingContentView.layer.shadowOffset = CGSizeMake(0, 2);
    loadingContentView.layer.shadowOpacity = 0.5;
    loadingContentView.alpha = 0.6;
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(loadingContentView.frame.size.width/2 - loadingContentView.frame.size.width/4, loadingContentView.frame.size.height/2 - loadingContentView.frame.size.height/4, loadingContentView.frame.size.width/2, loadingContentView.frame.size.height/2)];
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //activity.color = blueColor;
    [loadingContentView addSubview:activity];
    [activity startAnimating];
    [loadingView addSubview:loadingContentView];
    if (!loadingView)
    {
        return nil;
    }
    
    loadingView.opaque = NO;
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [aSuperview addSubview:loadingView];
    
    // Code to create and configure the label and activity view goes here.
    // Download the sample project to see it.
    
    // Set up the fade-in animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    return loadingView;
}

@end
