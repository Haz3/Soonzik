//
//  BattleViewController.m
//  SoonZik
//
//  Created by LLC on 23/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "BattleViewController.h"

@interface BattleViewController ()

@end

@implementation BattleViewController

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
    
    [self.contentView layoutIfNeeded];
    CGSize size = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height + self.playerPreviewView.frame.size.height);
    self.scrollView.contentSize = size;
    [self.scrollView addSubview:self.contentView];
    
    [self initDraggableElements];
    
    self.contentView2.hidden = YES;
}

- (void)initDraggableElements
{
    self.firstArtistView.userInteractionEnabled = YES;
    self.secondArtistView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *recognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFirst:)];
    [self.firstArtistView addGestureRecognizer:recognizer1];
    UIPanGestureRecognizer *recognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSecond:)];
    [self.secondArtistView addGestureRecognizer:recognizer2];
}

- (void)handlePanFirst:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.view.center.x - recognizer.view.frame.size.width / 2 <= self.nokView.frame.size.width) {
        self.nokView.backgroundColor = [UIColor redColor];
    } else {
        self.nokView.backgroundColor = [UIColor clearColor];
    }
    if (recognizer.view.center.x + recognizer.view.frame.size.width / 2 >= self.view.frame.size.width - self.okView.frame.size.width) {
        self.okView.backgroundColor = [UIColor greenColor];
    } else {
        self.okView.backgroundColor = [UIColor clearColor];
    }
    
    CGPoint translation = [recognizer translationInView:self.contentView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        if (recognizer.view.center.x - recognizer.view.frame.size.width / 2 <= self.nokView.frame.size.width) {
            [UIView animateWithDuration:1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
                CGPoint finalPoint = CGPointMake(-100, (self.contentView.frame.size.height-self.contentView2.frame.size.height)/2);
                recognizer.view.center = finalPoint;
            } completion:nil];
            self.secondArtistView.userInteractionEnabled = NO;
            [self setTheWinner:2];
        } else if (recognizer.view.center.x + recognizer.view.frame.size.width / 2 >= self.view.frame.size.width - self.okView.frame.size.width) {
            [UIView animateWithDuration:1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
                CGPoint finalPoint = CGPointMake(self.view.frame.size.width + 100, (self.contentView.frame.size.height-self.contentView2.frame.size.height)/2);
                recognizer.view.center = finalPoint;
            } completion:nil];
            self.firstArtistView.userInteractionEnabled = NO;
            [self setTheWinner:1];
        } else {
            [UIView animateWithDuration:1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
                recognizer.view.center = self.firstArtistView.center;
            } completion:nil];
        }
        
        self.okView.backgroundColor = [UIColor clearColor];
        self.nokView.backgroundColor = [UIColor clearColor];
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.contentView];
}
    
- (void)handlePanSecond:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.view.center.x - recognizer.view.frame.size.width / 2 <= self.nokView.frame.size.width) {
        self.nokView.backgroundColor = [UIColor redColor];
    } else {
        self.nokView.backgroundColor = [UIColor clearColor];
    }
    if (recognizer.view.center.x + recognizer.view.frame.size.width / 2 >= self.view.frame.size.width - self.okView.frame.size.width) {
        self.okView.backgroundColor = [UIColor greenColor];
    } else {
        self.okView.backgroundColor = [UIColor clearColor];
    }
    
    CGPoint translation = [recognizer translationInView:self.contentView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (recognizer.view.center.x - recognizer.view.frame.size.width / 2 <= self.nokView.frame.size.width) {
            [UIView animateWithDuration:1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
                CGPoint finalPoint = CGPointMake(-100, (self.contentView.frame.size.height-self.contentView2.frame.size.height)/2);
                recognizer.view.center = finalPoint;
            } completion:nil];
            self.firstArtistView.userInteractionEnabled = NO;
            [self setTheWinner:1];
        } else if (recognizer.view.center.x + recognizer.view.frame.size.width / 2 >= self.view.frame.size.width - self.okView.frame.size.width) {
            [UIView animateWithDuration:1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
                CGPoint finalPoint = CGPointMake(self.view.frame.size.width + 100, (self.contentView.frame.size.height-self.contentView2.frame.size.height)/2);
                recognizer.view.center = finalPoint;
            } completion:nil];
            self.secondArtistView.userInteractionEnabled = NO;
            [self setTheWinner:2];
        } else {
            [UIView animateWithDuration:1 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
                recognizer.view.center = self.secondArtistView.center;
            } completion:nil];
        }
        
        self.okView.backgroundColor = [UIColor clearColor];
        self.nokView.backgroundColor = [UIColor clearColor];
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.contentView];
}

- (void)setTheWinner:(int)artistNbr
{
    self.choiceLabel.hidden = YES;
    if (artistNbr == 1) {
        self.firstArtistViewName.hidden = YES;
        [UIView animateWithDuration:1 animations:^{
            self.firstArtistView.frame = CGRectMake(self.firstArtistView.frame.origin.x, self.firstArtistView.frame.origin.y, self.view.frame.size.width * 0.75, self.view.frame.size.width * 0.75);
            self.firstArtistView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y / 1.5);
            self.firstArtistViewImage.frame = CGRectMake(0, 0, self.firstArtistView.frame.size.width, self.firstArtistView.frame.size.height);
            self.firstArtistViewButton.hidden = YES;
            self.secondArtistView.alpha = 0;
            self.artistLabel.text = self.firstArtistViewName.text;
        } completion:nil];
    } else if (artistNbr == 2) {
        self.secondArtistViewName.hidden = YES;
        [UIView animateWithDuration:1 animations:^{
            self.secondArtistView.frame = CGRectMake(self.secondArtistView.frame.origin.x, self.secondArtistView.frame.origin.y, self.view.frame.size.width * 0.75, self.view.frame.size.width * 0.75);
            self.secondArtistView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y / 1.5);
            self.secondArtistViewImage.frame = CGRectMake(0, 0, self.secondArtistView.frame.size.width, self.secondArtistView.frame.size.height);
            self.secondArtistViewButton.hidden = YES;
            self.firstArtistView.alpha = 0;
            self.artistLabel.text = self.secondArtistViewName.text;
        } completion:nil];
    }
    
    [self getDataFromServer];
}

- (void)getDataFromServer
{
    self.firstArtistScore = 65.0;
    self.secondArtistScore = 35.0;
    
    [self refreshProgression];
}

- (void)refreshProgression
{
    self.contentView2.hidden = NO;
    
    self.csView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.csView setPercentageColorArray:@[[[CSPercentageColor alloc] initWithTitle:@"One" color:[UIColor blueColor] percentage:self.firstArtistScore/100],
                                               [[CSPercentageColor alloc] initWithTitle:@"Two" color:[UIColor orangeColor] percentage:self.secondArtistScore/100]]];
    }];
    
    [self.csView setFillColor:[UIColor clearColor]];
    [self .csView setShowsLegend:NO];
    [self.csView setStartAngle:0];
    [self.csView setLineWidth:10];
    [self.csView setRadius:50.f];
    
    [self.view sendSubviewToBack:self.csView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
