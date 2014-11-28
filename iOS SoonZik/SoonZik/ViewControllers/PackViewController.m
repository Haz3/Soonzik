//
//  PackViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 08/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PackViewController.h"
#import "Pack.h"
#import "AlbumInPackTableViewCell.h"
#import "AlbumViewController.h"

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addBlurEffectOnView:self.blurView];
    
    self.listOfPacks = [[Factory alloc] provideListWithClassName:@"Pack"];
    /*for (Pack *pack in self.listOfPacks) {
        NSLog(@"pack.title : %@", pack.title);
        for (Album *album in pack.listOfAlbums) {
            NSLog(@"%@", album.title);
        }
    }*/
    
    self.indexOfPage = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Pack *pack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    
    return pack.listOfAlbums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderPackView *view = (HeaderPackView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderPackView" owner:self options:nil] firstObject];
    [view createSliderWithPacks:self.listOfPacks andPage:self.indexOfPage];
    view.slideDelegate = self;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 195;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    AlbumInPackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AlbumInPackTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    [cell initCell];
    
    Pack *pack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    
    Album *album = [pack.listOfAlbums objectAtIndex:indexPath.row];
    
    cell.artistLabel.text = @"Artist Name";
    cell.albumLabel.text = album.title;
    
    return cell;
}

- (void)changeIndex:(int)index
{
    NSLog(@"slider tourne");
    self.indexOfPage = index;
    
    //[self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pack *pack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    Album *album = [pack.listOfAlbums objectAtIndex:indexPath.row];
    
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = album;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
