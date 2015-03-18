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
    self.tableView.backgroundColor = DARK_GREY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addBlurEffectOnView:self.blurView];
    
    
    /*for (Pack *pack in self.listOfPacks) {
        NSLog(@"pack.title : %@", pack.title);
        for (Album *album in pack.listOfAlbums) {
            NSLog(@"%@", album.title);
        }
    }*/
    
    self.listOfPacks = [[Factory alloc] provideListWithClassName:@"Pack"];
    if (self.listOfPacks.count > 0) {
        NSLog(@"No Error during loading");
        [self hideErrorDuringLoading];
    } else {
        NSLog(@"Error during loading");
        [self showErrorDuringLoading];
    }
    
    self.indexOfPage = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listOfPacks.count > 0) {
        Pack *pack = [self.listOfPacks objectAtIndex:self.indexOfPage];
        return pack.listOfAlbums.count;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderPackView *view = (HeaderPackView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderPackView" owner:self options:nil] firstObject];
    
    if (self.listOfPacks.count > 0) {
        [view createSliderWithPacks:self.listOfPacks andPage:self.indexOfPage];
        view.slideDelegate = self;
        view.backgroundColor = BLUE_2;
    }
    
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
    
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
