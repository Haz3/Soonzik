//
//  RepartitionAmountViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 02/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "RepartitionAmountViewController.h"
#import "RepartionTableViewCell.h"
#import "PacksController.h"

@interface RepartitionAmountViewController ()
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end

@implementation RepartitionAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = DARK_GREY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initializeCells];
    
    [self initPayPal];
}

- (void)initPayPal {
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    
    // See PayPalConfiguration.h for details and default values.
    // Should you wish to change any of the values, you can do so here.
    // For example, if you wish to accept PayPal but not payment card payments, then add:
    _payPalConfiguration.acceptCreditCards = NO;
    // Or if you wish to have the user choose a Shipping Address from those already
    // associated with the user's PayPal account, then add:
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
}

- (void)initializeCells {
    self.cells = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RepartionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    for (int i = 1; i <= 3; i++) {
        RepartionTableViewCell *cell = (RepartionTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = DARK_GREY;
        cell.value.textColor = [UIColor whiteColor];
        
        cell.slider.minimumValue = 0;
        cell.slider.maximumValue = self.price;
        cell.slider.continuous = true;
        
        if (i == 1) {
            cell.slider.value = 0.65 * self.price;
            self.artist = cell.slider.value;
        } else if (i == 2) {
            cell.slider.value = 0.20 * self.price;
            self.association = cell.slider.value;
        } else if (i == 3) {
            cell.slider.value = 0.15 * self.price;
            self.website = cell.slider.value;
        }
        
        cell.slider.tag = i;
        cell.value.text = [NSString stringWithFormat:@"%.2f%%", cell.slider.value];
        [cell.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.cells addObject:cell];
    }
    
    UITableViewCell *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"b"];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, cell2.frame.size.width - 40, cell2.frame.size.height)];
    buttonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    buttonView.layer.borderWidth = 1;
    buttonView.layer.cornerRadius = 10;
    buttonView.layer.backgroundColor = BLUE_1.CGColor;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonView.frame.size.width, buttonView.frame.size.height)];
    text.text = [self.translate.dict objectForKey:@"buy_now"];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = SOONZIK_FONT_BODY_MEDIUM;
    text.textColor = [UIColor whiteColor];
    
    [buttonView addSubview:text];
    
    [cell2.contentView addSubview:buttonView];
    
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.backgroundColor = [UIColor clearColor];
    
    [self.cells addObject:cell2];

}

- (void)buyPack {
    NSLog(@"buy_pack");
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithFloat:self.price];
    payment.currencyCode = @"EUR";
    payment.shortDescription = @"Soonzik transaction";
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    /*
    payment.shippingAddress = address; // a previously-created PayPalShippingAddress object
    */
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    
    // continued below...
    
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self verifyCompletedPayment:completedPayment];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
   /* NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];*/

    NSDictionary *json = completedPayment.confirmation;    
    NSDictionary *response = [json objectForKey:@"response"];
    NSString *identifier = nil;
    if ([[response objectForKey:@"state"] isEqualToString:@"approved"]) {
        [self.navigationController popToRootViewControllerAnimated:true];
        identifier = [response objectForKey:@"id"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self.translate.dict objectForKey:@"payment_title_success"] message:[self.translate.dict objectForKey:@"payment_message_success"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"self.artist : %.2f", self.artist);
        NSLog(@"self.association : %.2f", self.association);
        NSLog(@"self.website : %.2f", self.website);
        [PacksController buyPack:self.packID amount:self.price artist:self.artist association:self.association website:self.website withPayPalInfos:completedPayment];
    }
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}

#pragma mark - TableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self.translate.dict objectForKey:@"repartition_artist"];
    } else if (section == 1) {
        return[self.translate.dict objectForKey:@"repartition_association"];
    } else if (section == 2) {
        return [self.translate.dict objectForKey:@"repartition_site"];
    }
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cells objectAtIndex:indexPath.section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        [self buyPack];
    }
}

- (void)sliderChanged:(UISlider *)slider {
    RepartionTableViewCell *cell1 = [self.cells objectAtIndex:0];
    RepartionTableViewCell *cell2 = [self.cells objectAtIndex:1];
    RepartionTableViewCell *cell3 = [self.cells objectAtIndex:2];
    
    if (slider.tag == 1) {
        cell2.slider.value = 1 * (self.price - cell1.slider.value);
        cell3.slider.value = 0.75 * (self.price - cell1.slider.value);
    } else if (slider.tag == 2) {
        cell1.slider.value = 1 * (self.price - cell2.slider.value);
        cell3.slider.value = (0.15 / 0.65) * (self.price - cell2.slider.value);
    } else if (slider.tag == 3) {
        cell1.slider.value = 1 * (self.price - cell3.slider.value);
        cell2.slider.value = (0.20 / 0.60) * (self.price - cell3.slider.value);
    }
    
    cell1.value.text = [NSString stringWithFormat:@"%.1f", cell1.slider.value];
    cell2.value.text = [NSString stringWithFormat:@"%.1f", cell2.slider.value];
    cell3.value.text = [NSString stringWithFormat:@"%.1f", cell3.slider.value];
    
    self.artist = cell1.slider.value;
    self.association = cell2.slider.value;
    self.website = cell3.slider.value;
}

- (NSArray *)getCells {
    return @[[self.cells objectAtIndex:1], [self.cells objectAtIndex:2], [self.cells objectAtIndex:3]];
}

@end