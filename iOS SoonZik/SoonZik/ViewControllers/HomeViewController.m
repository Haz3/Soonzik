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
    
   /* NSArray *listOfUsers = [[Factory alloc] provideListWithClassName:@"User"];
    for (User *user in listOfUsers) {
        NSLog(@"user.firstname : %@", user.firstname);
    }
    */
    
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
    UIImage *updateImage = [Tools imageWithImage:[SVGKImage imageNamed:@"update"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithImage:updateImage style:UIBarButtonItemStylePlain target:self action:@selector(updateTableView)];
    
    UIImage *searchImage = [Tools imageWithImage:[SVGKImage imageNamed:@"search"].UIImage scaledToSize:CGSizeMake(30, 30)];
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
