//
//  FirstLaunchViewController.m
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "FirstLaunchViewController.h"
#import "ConnexionViewController.h"

@interface FirstLaunchViewController ()

@end

@implementation FirstLaunchViewController

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
    
    [self.navigationController setNavigationBarHidden:YES];
    [self initScrollView];
    
    [self.connexionButton addTarget:self action:@selector(goToConnexion) forControlEvents:UIControlEventTouchUpInside];

    self.connexionButton.hidden = YES;
}

- (void)initScrollView
{
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    self.imageWidth = self.view.frame.size.width;
    self.imageHeight = self.view.frame.size.height;
    
    self.scrollView.clipsToBounds = NO;
    
    self.index = 0;
    
	CGFloat contentOffset = 0.0f;
    for (int i = 0; i < 3; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.imageWidth, 0, self.imageWidth, self.imageHeight)];
        image.backgroundColor = [UIColor grayColor];
        [self.scrollView addSubview:image];
        
        contentOffset += image.frame.size.width;
		self.scrollView.contentSize = CGSizeMake(contentOffset, self.imageHeight);
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)goToConnexion
{
    ConnexionViewController *vc = [[ConnexionViewController alloc] initWithNibName:@"ConnexionViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIButton animateWithDuration:1.0 animations:^{
        [self.connexionButton setFrame:CGRectMake(self.connexionButton.frame.origin.x, self.view.frame.size.height*2, self.connexionButton.frame.size.width, self.connexionButton.frame.size.height)];
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.index = (int)targetContentOffset->x / (int)self.imageWidth;
    [self.pageControl setCurrentPage:self.index];
    
    if (self.index == 2) {
        self.connexionButton.hidden = NO;
        [UIButton animateWithDuration:1.0 animations:^{
            [self.connexionButton setFrame:CGRectMake(self.connexionButton.frame.origin.x, 374, self.connexionButton.frame.size.width, self.connexionButton.frame.size.height)];
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
