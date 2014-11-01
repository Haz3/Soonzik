//
//  PackViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 08/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PackViewController.h"
#import "Pack.h"

@interface PackViewController ()

@end

@implementation PackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.listOfPacks = [[Factory alloc] provideListWithClassName:@"Pack"];
    for (Pack *pack in self.listOfPacks) {
        NSLog(@"pack.title : %@", pack.title);
    }
    
    Pack *p1 = [[Pack alloc] init];
    p1.identifier = 1;
    p1.title = @"Pack 1";
    p1.genre = [[Genre alloc] init];
    p1.genre.name = @"Rock";
    p1.price = 5.0;
    
    Pack *p2 = [[Pack alloc] init];
    p2.identifier = 2;
    p2.title = @"Pack 2";
    p2.genre = [[Genre alloc] init];
    p2.genre.name = @"Rock";
    p2.price = 5.0;
    
    Pack *p3 = [[Pack alloc] init];
    p3.identifier = 3;
    p3.title = @"Pack 3";
    p3.genre = [[Genre alloc] init];
    p3.genre.name = @"Rock";
    p3.price = 5.0;
    
    Pack *p4 = [[Pack alloc] init];
    p4.identifier = 4;
    p4.title = @"Pack 4";
    p4.genre = [[Genre alloc] init];
    p4.genre.name = @"Rock";
    p4.price = 5.0;

    [self createSlider];
    
    self.indexOfPage = 0;
}

- (void)createSlider
{
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    float imageWith = 200.0f;
    float imageEcart = (self.scrollView.frame.size.width - imageWith) / 2;
    NSLog(@"imageEcart : %f", imageEcart);
    
    self.scrollView.clipsToBounds = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
	CGFloat contentOffset = 0.0f;
    
    for (int i = 0; i < self.listOfPacks.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWith + imageEcart * (i * 2 + 1), self.scrollView.frame.origin.y+self.navigationController.navigationBar.frame.size.height, imageWith, imageWith)];
        //imgV.image = [self.listOfPacks objectAtIndex:i];
        imgV.layer.backgroundColor = [UIColor blackColor].CGColor;
        imgV.layer.shadowOffset = CGSizeMake(5, 5);
        imgV.layer.shadowRadius = 5.0;
        imgV.layer.shadowColor = [UIColor blackColor].CGColor;
        imgV.layer.shadowOpacity = 0.8;
        [self.scrollView addSubview:imgV];
        contentOffset += self.scrollView.frame.size.width;
        
    }
    self.scrollView.contentSize = CGSizeMake(contentOffset, self.scrollView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSLog(@"index : %i", self.indexOfPage);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
