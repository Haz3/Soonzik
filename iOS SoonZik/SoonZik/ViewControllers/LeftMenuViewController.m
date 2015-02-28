
#import "LeftMenuViewController.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"
#import "PackViewController.h"
#import "GeolocationViewController.h"
#import "ContentViewController.h"
#import "FriendsViewController.h"
#import "BattleViewController.h"
#import "Tools.h"
#import "SVGKImage.h"

@interface LeftMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 8) / 2.0f, self.view.frame.size.width, 54 * 8) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 1:
            // explorer
        {
            ExploreViewController *vc = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 2:
            // pack
        {
            PackViewController *vc = [[PackViewController alloc] initWithNibName:@"PackViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 3:
            // monde musical
        {
            GeolocationViewController *vc = [[GeolocationViewController alloc] initWithNibName:@"GeolocationViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 4:
            // battles
        {
            BattleViewController *vc = [[BattleViewController alloc] initWithNibName:@"BattleViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 5:
            // playlists
        {
            ContentViewController *vc = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 6:
            // amis
        {
            FriendsViewController *vc = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 7:
           // [self closeTheSession];
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"News", @"Explore", @"Pack", @"Geoloc", @"Battle", @"Playlists", @"Friends", @"Deconnection"];
    NSArray *images = @[@"news", @"explore", @"", @"geoloc", @"battle", @"content", @"friends", @"deconect"];
    cell.textLabel.text = titles[indexPath.row];
    //UIImage *menuImage = ;
    cell.imageView.image = [Tools imageWithImage:[SVGKImage imageNamed:@"user"].UIImage scaledToSize:CGSizeMake(30, 30)];
    
    return cell;
}

@end
