//
//  ArtistViewController.m
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ArtistViewController.h"
#import "Album.h"
#import "AlbumSongCell.h"
#import "OtherArtistsCollectionViewCell.h"

@interface ArtistViewController ()

@end

@implementation ArtistViewController

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
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.songsTableView.delegate = self;
    self.songsTableView.dataSource = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    
    self.horizontalScrollView.tag = 2;
    
    self.horizontalScrollView.delegate = self;
    
    self.index = 0;

    CGSize size = CGSizeMake(self.horizontalContentView.frame.size.width, self.horizontalContentView.frame.size.height + self.playerPreviewView.frame.size.height);
    self.horizontalScrollView.contentSize = size;
    [self.horizontalScrollView addSubview:self.horizontalContentView];
    
    [self.songsTableView setFrame:CGRectMake(0, 0, self.horizontalContentView.frame.size.width/4, self.horizontalScrollView.contentSize.height)];

    [self.shareButton addTarget:self action:@selector(launchShareView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.section1 addTarget:self action:@selector(goToSection1) forControlEvents:UIControlEventTouchUpInside];
    [self.section2 addTarget:self action:@selector(goToSection2) forControlEvents:UIControlEventTouchUpInside];
    [self.section3 addTarget:self action:@selector(goToSection3) forControlEvents:UIControlEventTouchUpInside];
    [self.section4 addTarget:self action:@selector(goToSection4) forControlEvents:UIControlEventTouchUpInside];
    
    [self getAlbumInfos];
    
    [self.songsTableView reloadData];
}

- (void)launchShareView
{
    NSString *shareText = @"The text I am sharing";
    UIImage *shareImage = [UIImage imageNamed:@"artist2.jpg"];
    NSArray *itemsToShare = @[shareText, shareImage];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)getAlbumInfos
{
    self.albumTitles = [[NSMutableArray alloc] init];
    
    self.albumsList = [[NSMutableDictionary alloc] init];
    self.albumsContent = [[NSMutableDictionary alloc] init];
    Album *a = [[Album alloc] init];
    a.title = @"Album1";
    a.artist.username = @"Route 94";
    a.image = @"song2.jpg";
    
    self.songsList = [[NSMutableArray alloc] init];
    Music *s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    [self.albumsContent setValue:a forKey:@"albumInfos"];
    [self.albumsContent setValue:self.songsList forKey:@"albumContent"];
    
    [self.albumsList setValue:self.albumsContent forKey:a.title];
    [self.albumTitles addObject:a.title];
    
    self.albumsContent = [[NSMutableDictionary alloc] init];
    Album *a2 = [[Album alloc] init];
    a2.title = @"Album2";
    a2.artist.username = @"I got U";
    a2.image = @"song3.jpg";
    
    self.songsList = [[NSMutableArray alloc] init];
    s1 = [[Music alloc] init];
    s1.title = @"I got U";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"I got U UUU";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    [self.albumsContent setValue:a2 forKey:@"albumInfos"];
    [self.albumsContent setValue:self.songsList forKey:@"albumContent"];
    
    [self.albumsList setValue:self.albumsContent forKey:a2.title];
    [self.albumTitles addObject:a2.title];

    self.albumsContent = [[NSMutableDictionary alloc] init];
    Album *a3 = [[Album alloc] init];
    a3.title = @"Wesjjj";
    a3.artist.username = @"prout";
    a3.image = @"song3.jpg";
    
    self.songsList = [[NSMutableArray alloc] init];
    s1 = [[Music alloc] init];
    s1.title = @"dqsddd";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"yiytre";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    s1 = [[Music alloc] init];
    s1.title = @"My Love";
    [self.songsList addObject:s1];
    
    [self.albumsContent setValue:a3 forKey:@"albumInfos"];
    [self.albumsContent setValue:self.songsList forKey:@"albumContent"];
    
    [self.albumsList setValue:self.albumsContent forKey:a3.title];
    [self.albumTitles addObject:a3.title];

}

- (void)goToSection1
{
    self.index = 0;
    [self.horizontalScrollView setContentOffset:CGPointMake(self.index * self.view.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self.movingView setFrame:CGRectMake(self.view.frame.size.width / 4 * self.index, self.movingView.frame.origin.y, self.movingView.frame.size.width, self.movingView.frame.size.height)];
    }];
}

- (void)goToSection2
{
    self.index = 1;
    [self.horizontalScrollView setContentOffset:CGPointMake(self.index * self.view.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self.movingView setFrame:CGRectMake(self.view.frame.size.width / 4 * self.index, self.movingView.frame.origin.y, self.movingView.frame.size.width, self.movingView.frame.size.height)];
    }];
}

- (void)goToSection3
{
    self.index = 2;
    [self.horizontalScrollView setContentOffset:CGPointMake(self.index * self.view.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self.movingView setFrame:CGRectMake(self.view.frame.size.width / 4 * self.index, self.movingView.frame.origin.y, self.movingView.frame.size.width, self.movingView.frame.size.height)];
    }];
}

- (void)goToSection4
{
    self.index = 3;
    [self.horizontalScrollView setContentOffset:CGPointMake(self.index * self.view.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self.movingView setFrame:CGRectMake(self.view.frame.size.width / 4 * self.index, self.movingView.frame.origin.y, self.movingView.frame.size.width, self.movingView.frame.size.height)];
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.tag == 2) {
        self.index = (int)targetContentOffset->x / self.view.frame.size.width;
        //[self.pageControl setCurrentPage:self.index];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.movingView setFrame:CGRectMake(self.view.frame.size.width / 4 * self.index, self.movingView.frame.origin.y, self.movingView.frame.size.width, self.movingView.frame.size.height)];
        }];
    }
}

/*
 *      TABLE VIEW SONGS
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.albumTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *nameOfTheAlbum = [self.albumTitles objectAtIndex:section];
    NSDictionary *album = [[NSDictionary alloc] initWithDictionary:[self.albumsList objectForKey:nameOfTheAlbum]];
    NSArray *listOfSongs = [NSArray arrayWithArray:[album objectForKey:@"albumContent"]];
    
    return listOfSongs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *nameOfTheAlbum = [self.albumTitles objectAtIndex:section];
    NSDictionary *album = [[NSDictionary alloc] initWithDictionary:[self.albumsList objectForKey:nameOfTheAlbum]];
    Album *a = [album objectForKey:@"albumInfos"];
    
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    UIImageView *albumImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    albumImage.image = [UIImage imageNamed:a.image];
    [sectionView addSubview:albumImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + albumImage.frame.size.width, 5, sectionView.frame.size.width - albumImage.frame.size.width - 10, sectionView.frame.size.height - 10)];
    label.font = SOONZIK_FONT_BODY_BIG;
    label.textColor = [UIColor whiteColor];
    label.text = a.title;
    
    [sectionView addSubview:label];
    
    [sectionView setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellId";
    
    AlbumSongCell *cell = (AlbumSongCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AlbumSongCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    [cell initCell];
    
    NSString *nameOfTheAlbum = [self.albumTitles objectAtIndex:indexPath.section];
    NSDictionary *album = [[NSDictionary alloc] initWithDictionary:[self.albumsList objectForKey:nameOfTheAlbum]];
    NSArray *listOfSongs = [album objectForKey:@"albumContent"];
    Music *s = [listOfSongs objectAtIndex:indexPath.row];
    
    cell.songTitle.text = s.title;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    [collectionView registerNib:[UINib nibWithNibName:@"OtherArtistsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    OtherArtistsCollectionViewCell *cell = (OtherArtistsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    [cell initCell];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"element: %i", indexPath.row);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
