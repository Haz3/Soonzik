//
//  HomeViewController.m
//  SoonZik
//
//  Created by devmac on 26/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

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
    
    [self addUpdateButtonInNavigationBar];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - self.playerPreviewView.frame.size.height)];
    
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    if (self.player.listeningList.count == 0) {
        self.player.currentlyPlaying = NO;
    }
}


- (void)addUpdateButtonInNavigationBar
{
    UIImage *updateImage = [self imageWithImage:[UIImage imageNamed:@"share_icon.png"] scaledToSize:CGSizeMake(19, 19)];
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithImage:updateImage style:UIBarButtonItemStylePlain target:self action:@selector(updateTableView)];
    
    UIImage *searchImage = [self imageWithImage:[UIImage imageNamed:@"search_icon.png"] scaledToSize:CGSizeMake(19, 19)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(displaySearch)];
    
    self.navigationItem.rightBarButtonItems = @[searchButton, updateButton];
}

- (void)launchShareViewWithNews:(News *)news
{
    NSString *shareText = @"The text I am sharing";
    UIImage *shareImage = [UIImage imageNamed:@"artist2.jpg"];
    NSArray *itemsToShare = @[shareText, shareImage];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)updateTableView
{
    [self.tableView reloadData];
}

- (IBAction)loadPlaylist:(id)sender
{
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    
    Song *s1 = [[Song alloc] init];
    s1.title = @"song1";
    s1.artist = @"John Newman";
    s1.image = @"song1.jpg";
    s1.file = @"song1";
    
    Song *s2 = [[Song alloc] init];
    s2.title = @"song2";
    s2.artist = @"Route 94";
    s2.image = @"song2.jpg";
    s2.file = @"song2";
    
    Song *s3 = [[Song alloc] init];
    s3.title = @"song3";
    s3.artist = @"Duke Dumont";
    s3.image = @"song3.jpg";
    s3.file = @"song3";
    
    [self.player.listeningList addObject:s1];
    [self.player.listeningList addObject:s2];
    [self.player.listeningList addObject:s3];
    
    
    if (self.player.currentlyPlaying == NO) {
        self.player.index = 0;
        Song * s = [self.player.listeningList objectAtIndex:self.player.index];
        [self.player prepareSong:s.file];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId1 = @"cellID1";
    
    NewsTypeAlbumCell *cell = (NewsTypeAlbumCell *)[tableView dequeueReusableCellWithIdentifier:cellId1];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"NewsTypeAlbumCell" bundle:nil] forCellReuseIdentifier:cellId1];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
    }
    
    News *n = [[News alloc] init];
    
    cell.shareDelegate = self;
    
    [cell initCellWithNews:n];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
