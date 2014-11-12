//
//  BattleViewController.m
//  SoonZik
//
//  Created by LLC on 23/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "BattleViewController.h"
#import "LatestVotesViewController.h"

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
    
    [self.shareSection setFrame:CGRectMake(0, self.contentView.bounds.size.height*2, self.shareSection.frame.size.width, self.shareSection.frame.size.height)];

    [self initElements];
    
    [self getDataFromServer];
}

- (void)getDataFromServer
{
    self.firstArtistScore = 65.0;
    self.secondArtistScore = 35.0;
    
    self.artist1VoteLabel.text = [NSString stringWithFormat:@"%d %%", (int)self.firstArtistScore];
    self.artist2VoteLabel.text = [NSString stringWithFormat:@"%d %%", (int)self.secondArtistScore];
    
    [self refreshProgression];
}

- (void)initElements
{
    self.voteArtist1.tag = 1;
    self.voteArtist2.tag = 2;
    
    self.artist1Label.font = SOONZIK_FONT_BODY_BIG;
    self.artist2Label.font = SOONZIK_FONT_BODY_BIG;
    
    self.artist1VoteLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    self.artist2VoteLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    
    self.messageLabel.font = SOONZIK_FONT_BODY_SMALL;
    
    [self.voteArtist1 addTarget:self action:@selector(voteForTheArtist:) forControlEvents:UIControlEventTouchUpInside];
    [self.voteArtist2 addTarget:self action:@selector(voteForTheArtist:) forControlEvents:UIControlEventTouchUpInside];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    self.voteArtist1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.voteArtist1.layer.shadowOpacity = 1;
    self.voteArtist1.layer.cornerRadius = 10;
    self.voteArtist1.layer.shadowRadius = 10;
    self.voteArtist1.layer.shadowOffset = CGSizeMake(-2, 7);
    self.artist1Image.layer.borderWidth = 0.5;
    self.artist1Image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.voteArtist2.layer.shadowColor = [UIColor blackColor].CGColor;
    self.voteArtist2.layer.shadowOpacity = 1;
    self.voteArtist2.layer.cornerRadius = 10;
    self.voteArtist2.layer.shadowRadius = 10;
    self.voteArtist2.layer.shadowOffset = CGSizeMake(-2, 7);
    self.artist2Image.layer.borderWidth = 0.5;
    self.artist2Image.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.voteArtist1.titleLabel.font = SOONZIK_FONT_BODY_SMALL;
    self.voteArtist2.titleLabel.font = SOONZIK_FONT_BODY_SMALL;

    [self.artist1Image setImage:[UIImage imageNamed:@"artist1.jpg"]];
    [self.artist2Image setImage:[UIImage imageNamed:@"artist2.jpg"]];
    
    [self.latestVotes addTarget:self action:@selector(goToLatestVotes) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)goToLatestVotes
{
  //  [self closeTheMenuView];
    
    NSLog(@"go to the latest votes");
    LatestVotesViewController *vc = [[LatestVotesViewController alloc] initWithNibName:@"LatestVotesViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)voteForTheArtist:(UIButton *)artist
{
    // send to the server the numero of choosen artist
    if (artist.tag == 1) {
        self.firstArtistScore += 1;
        self.secondArtistScore -= 1;
    } else {
        self.firstArtistScore -= 1;
        self.secondArtistScore += 1;
    }
    // get the result
    // and display it
    self.artist1VoteLabel.text = [NSString stringWithFormat:@"%d %%", (int)self.firstArtistScore];
    self.artist2VoteLabel.text = [NSString stringWithFormat:@"%d %%", (int)self.secondArtistScore];
    
    self.messageLabel.text = [NSString stringWithFormat:@"Votre vote a bien été pris en compte"];
    
    [self.previewSection setHidden:YES];
    [UILabel animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.messageLabel setFrame:CGRectMake(0, self.previewSection.frame.origin.y, self.messageLabel.frame.size.width, self.messageLabel.frame.size.height)];
    } completion:nil];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.shareSection setFrame:CGRectMake(0, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height, self.shareSection.frame.size.width, self.shareSection.frame.size.height)];
    } completion:nil];
    
    CGSize changedSize = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height - self.shareSection.frame.size.height + self.playerPreviewView.frame.size.height);
    self.scrollView.contentSize = changedSize;
    
    [self refreshProgression];
}

- (void)refreshProgression
{
    /*float progressionWith = self.artist1VoteProgression.frame.size.width + self.artist2VoteProgression.frame.size.width;
    
    [self.artist1VoteProgression setFrame:CGRectMake(self.artist1VoteProgression.frame.origin.x, self.artist1VoteProgression.frame.origin.y, progressionWith * self.firstArtistScore / 100, self.artist1VoteProgression.frame.size.height)];
    [self.artist2VoteProgression setFrame:CGRectMake(self.artist1VoteProgression.frame.origin.x + self.artist1VoteProgression.frame.size.width, self.artist2VoteProgression.frame.origin.y, progressionWith * self.secondArtistScore / 100, self.artist2VoteProgression.frame.size.height)];*/
    
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
