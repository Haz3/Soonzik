//
//  AlbumViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AlbumViewController.h"
#import "HeaderAlbumTableView.h"
#import "AppDelegate.h"
#import "SVGKImage.h"
#import "AlbumTableViewCell.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

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
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.album = [[Factory alloc] provideObjectWithClassName:@"Album" andIdentifier:self.album.identifier];
    
    self.listOfMusics = self.album.listOfMusics;
    
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfMusics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderAlbumTableView *view = (HeaderAlbumTableView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderAlbumTableView" owner:self options:nil] firstObject];
    view.albumImage.image = [UIImage imageNamed:self.album.image];
    view.albumTitle.text = self.album.title;
    view.backgroundColor = BACKGROUND_COLOR;
    [view initHeader];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AlbumTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    
    Music *music = [self.listOfMusics objectAtIndex:indexPath.row];
    
    [cell initCell];
    
    cell.musicTitle.text = music.title;
    cell.musicLength.text = @"03:22";
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Music *s = [self.listOfMusics objectAtIndex:indexPath.row];
    NSLog(@"song: %@", s.title);
    NSLog(@"song.file : %@", s.file);
    
    NSString *file = [s.file stringByReplacingOccurrencesOfString:@".mp3" withString:@""];
    
    self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    if ([self.player currentlyPlaying])
        [self.player pauseSound];
    self.player.listeningList = nil;
    self.player.listeningList = [[NSMutableArray alloc] init];
    [self.player.listeningList addObject:s];
    self.player.index = 0;
    [self.player prepareSong:file];
    [self.player playSound];
    self.player.songName = s.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
