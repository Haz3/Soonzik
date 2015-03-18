//
//  HomeViewController.m
//  SoonZik
//
//  Created by devmac on 26/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Pack.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "NewsNouvelleCell.h"
#import "REComposeViewController.h"

@interface HomeViewController () {
    REComposeViewController *composeViewController;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"SoonZik";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self addUpdateButtonInNavigationBar];
    
    self.listOfNews = [[NSMutableArray alloc] initWithArray:[[Factory alloc] provideListWithClassName:@"News"]];
    if (self.listOfNews.count > 0) {
        NSLog(@"No Error during loading");
        [self hideErrorDuringLoading];
    } else {
        NSLog(@"Error during loading");
       [self showErrorDuringLoading];
    }

    
    for (News *news in self.listOfNews) {
        NSLog(@"news : %@", news.title);
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    /*self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    if (self.player.listeningList.count == 0) {
        self.player.currentlyPlaying = NO;
    }*/
}


- (void)addUpdateButtonInNavigationBar
{
    UIImage *updateImage = [Tools imageWithImage:[SVGKImage imageNamed:@"update"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithImage:updateImage style:UIBarButtonItemStylePlain target:self action:@selector(updateTableView)];

}

- (void)launchShareViewWithNews:(News *)news andCell:(UITableViewCell *)cell
{
    AAShareBubbles *shareBubbles = [[AAShareBubbles alloc] initWithPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2) radius:100 inView:self.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 45; // Default is 40
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showMailBubble = NO;
    shareBubbles.showGooglePlusBubble = YES;
    shareBubbles.showTumblrBubble = NO;
    shareBubbles.showVkBubble = NO;
    
    // add custom buttons -- buttonId for custom buttons MUST be greater than or equal to 100
    //[shareBubbles addCustomButtonWithIcon:[UIImage imageNamed:@"custom-icon"] backgroundColor:[UIColor greenColor] andButtonId:100];
    
    
    [shareBubbles show];
}

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    composeViewController = [[REComposeViewController alloc] init];
    composeViewController.delegate = self;
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
        {
           
            composeViewController.title = @"Facebook";
            composeViewController.hasAttachment = YES;
            composeViewController.attachmentImage = [UIImage imageNamed:@"artist2.jpg"];
            composeViewController.text = @"The text I am sharing";
            
            //[composeViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"facebook_logo.png"] forBarMetrics:UIBarMetricsCompact];
            composeViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:194/255.0 alpha:1];
            composeViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:29/255.0 green:118/255.0 blue:143/255.0 alpha:1];
            
        }
            break;
        case AAShareBubbleTypeTwitter:
        {
            
            composeViewController.title = @"Twitter";
            composeViewController.hasAttachment = YES;
            composeViewController.attachmentImage = [UIImage imageNamed:@"artist2.jpg"];
            composeViewController.text = @"The text I am sharing";
            
            //[composeViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"facebook_logo.png"] forBarMetrics:UIBarMetricsCompact];
            composeViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:194/255.0 alpha:1];
            composeViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:29/255.0 green:118/255.0 blue:143/255.0 alpha:1];
            
        }            break;
        case AAShareBubbleTypeMail:
            NSLog(@"Email");
            break;
        case AAShareBubbleTypeGooglePlus:
        {
            
            composeViewController.title = @"Google +";
            composeViewController.hasAttachment = YES;
            composeViewController.attachmentImage = [UIImage imageNamed:@"artist2.jpg"];
            composeViewController.text = @"The text I am sharing";
            
            //[composeViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"facebook_logo.png"] forBarMetrics:UIBarMetricsCompact];
            composeViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:194/255.0 alpha:1];
            composeViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:29/255.0 green:118/255.0 blue:143/255.0 alpha:1];
            
        }
            break;
        case AAShareBubbleTypeTumblr:
            NSLog(@"Tumblr");
            break;
        case AAShareBubbleTypeVk:
            NSLog(@"Vkontakte (vk.com)");
            break;
        case 100:
            // custom buttons have type >= 100
            NSLog(@"Custom Button With Type 100");
            break;
        default:
            break;
    }
    composeViewController.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
        if (result == REComposeResultCancelled) {
            NSLog(@"Cancelled");
        }
        if (result == REComposeResultPosted) {
            NSLog(@"Text: %@", composeViewController.text);
        }
    };
    [composeViewController presentFromRootViewController];
}

-(void)aaShareBubblesDidHide:(AAShareBubbles *)bubbles {
    NSLog(@"All Bubbles hidden");
}

- (void)updateTableView
{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfNews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = (News *)[self.listOfNews objectAtIndex:indexPath.row];
    
    if ([news.type isEqualToString:@"Nouvelle"]) {
        return 188;
    }
    
    return 188;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId1 = @"cellID1";
    static NSString *cellId2 = @"cellID2";
    
    News *news = (News *)[self.listOfNews objectAtIndex:indexPath.row];
    
    if ([news.type isEqualToString:@"Nouvelle"]) {
        NewsNouvelleCell *cell = (NewsNouvelleCell *)[tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"NewsNouvelleCell" bundle:nil] forCellReuseIdentifier:cellId1];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        }
        cell.shareDelegate = self;
        
        [cell initCellWithNews:news];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    }
        
    NewsTypeAlbumCell *cell = (NewsTypeAlbumCell *)[tableView dequeueReusableCellWithIdentifier:cellId2];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"NewsTypeAlbumCell" bundle:nil] forCellReuseIdentifier:cellId2];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
    }
    cell.shareDelegate = self;
    
    [cell initCellWithNews:news];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = (News *)[self.listOfNews objectAtIndex:indexPath.row];
    
    if ([news.type isEqualToString:@"Sortie"]) {
        // Go to album view controller
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
