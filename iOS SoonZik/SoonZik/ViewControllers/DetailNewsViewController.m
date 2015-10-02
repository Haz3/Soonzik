//
//  DetailNewsViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 19/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "DetailNewsViewController.h"
#import "NewsText.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "SimplePopUp.h"
#import "CommentsController.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataLoaded = NO;
    [self getData];
    
    [self.tableView sizeToFit];
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = DARK_GREY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"listOfNews.text.count : %i", self.news.listOfNewsTexts.count);
    NSLog(@"listOfAttachments.count : %i", self.news.listOfAttachments.count);
}

- (void)getData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        
        self.listOfComments = [CommentsController getCommentsFromNews:self.news];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 130)];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:view.frame];
        
        
        bool found = false;
        int i = 0;
        while ((i < self.news.listOfAttachments.count) && (!found)) {
            Attachment *att = [self.news.listOfAttachments objectAtIndex:i];
            NSLog(@"%@", att.contentType);
            if ([att.contentType isEqualToString:@"image/jpegNews"]) {
                NSLog(@"att.url : %@", att.url);
                NSString *urlImage = [NSString stringWithFormat:@"%@assets/news/%@", API_URL, att.url];
                NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
                imgv.image = [UIImage imageWithData:imageData];
                found = true;
            }
            i++;
        }
        
        [view addSubview:imgv];
        imgv.contentMode = UIViewContentModeScaleAspectFit;
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width, 40)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = v.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1 alpha:0], (id)DARK_GREY.CGColor, nil];
        [v.layer insertSublayer:gradient atIndex:0];
        [view addSubview:v];
        
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-40, view.frame.size.height-30, 26, 26)];
        [shareButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"share_white"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        [shareButton setTintColor:[UIColor whiteColor]];
        [view addSubview:shareButton];
        
        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(4, 4, self.tableView.frame.size.width-8-50, 50-8)];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.backgroundColor = DARK_GREY;
    self.textView.font = SOONZIK_FONT_BODY_MEDIUM;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.delegate = self;
    self.textView.alpha = 0;
    [view addSubview:self.textView];
    view.tag = 500;
    UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
    [button setTitle:[self.translate.dict objectForKey:@"news_add_com"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showComTextView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}

- (void)showComTextView {
    
    
    for (UIView *view in self.tableView.subviews) {
        if (view.tag == 500) {
            for (UIView *v in view.subviews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-8-50, 4, 50, view.frame.size.height-8)];
                    [btn setTitle:[self.translate.dict objectForKey:@"title_send"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                    btn.alpha = 0;
                    self.textView.alpha = 0;
                    [UIView animateWithDuration:0.25
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         v.alpha = 0;
                                     } completion:^(BOOL finished) {
                                         [v removeFromSuperview];
                                         [UIView animateWithDuration:0.25
                                                               delay:0
                                                             options:UIViewAnimationOptionCurveEaseInOut
                                                          animations:^{
                                                              self.textView.alpha = 1;
                                                              btn.alpha = 1;
                                          } completion:^(BOOL finished) {
                                              nil;
                                          }];

                                     }];
                }
            }
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 130;
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataLoaded) {
        if (section == 0)
            return self.news.listOfNewsTexts.count + self.news.listOfAttachments.count + 1;
        return self.listOfComments.count+1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = self.news.title;
            cell.textLabel.font = SOONZIK_FONT_BODY_BIG;
        }
        else if (indexPath.row > 0 && indexPath.row < self.news.listOfNewsTexts.count+1) {
            NewsText *newsText = [self.news.listOfNewsTexts objectAtIndex:indexPath.row-1];
            cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
            cell.textLabel.text = newsText.content;
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell sizeToFit];
        
        return cell;

    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDCom"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIDCom"];
    }

    if (self.listOfComments.count > 0 && indexPath.row < self.listOfComments.count) {
        Com *comment = [self.listOfComments objectAtIndex:indexPath.row];
        cell.textLabel.text = comment.content;
        cell.textLabel.textColor = [UIColor whiteColor];
        unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitHour;
        NSDateComponents *conversionInfo = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:unitFlags fromDate:comment.date   toDate:[NSDate date]  options:0];
        
        NSLog(@"comment date : %@", comment.date);
        
        int seconds = [conversionInfo second];
        int days = [conversionInfo day];
        int hours = [conversionInfo hour];
        int minutes = [conversionInfo minute];
        
        NSLog(@"%i %i:%i%i", days, hours, minutes, seconds);
        
        if (days < 1) {
            if (hours < 1) {
                if (minutes < 1) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i secondes", seconds];
                } else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i minutes", minutes];
                }
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i heures", hours];
            }
        } else if (days == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i jour", 1];
        } else if (days > 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i jours", days];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
    [cell sizeToFit];
    return cell;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        [self sendComment];
        return false;
    }
    
    return true;
}

- (void)sendComment {
    if ([CommentsController addComment:self.news andComment:self.textView.text]) {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"news_com_added"] onView:self.view withSuccess:true] show];
        self.textView.text = @"";
        [self getData];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"news_com_added_error"] onView:self.view withSuccess:false] show];
    }
}

@end
