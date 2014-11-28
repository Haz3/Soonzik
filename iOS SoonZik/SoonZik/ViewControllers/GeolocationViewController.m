//
//  GeolocationViewController.m
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "GeolocationViewController.h"
#import "ArtistViewController.h"
#import "UserAnnotation.h"
#import "CalloutView.h"

#define METERS_PER_MILE 1609.344

#define DEGREES_RADIANS(angle) (angle / 180.0 * M_PI)

@interface GeolocationViewController ()

@end

@implementation GeolocationViewController

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
    
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(90));
    self.sliderView.transform = rotationTransform;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem.title = @"";
    
    self.userPosition = [[CLLocationManager alloc] init];
    self.userPosition.delegate = self;
    self.userPosition.distanceFilter = kCLDistanceFilterNone;
    self.userPosition.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.userPosition respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.userPosition requestWhenInUseAuthorization];
    }
    
    [self.myPositionButton addTarget:self action:@selector(getUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self getUserLocation];
    
    self.slider.value = 400;
    self.slider.minimumValue = 200;
    self.slider.maximumValue = 30000;
    [self.slider setThumbImage:[UIImage imageNamed:@"cursor.png"] forState:UIControlStateNormal];
    
    [self getAllOtherUsers];
    
    [self.detailView setFrame:CGRectMake(0, self.view.frame.size.height - self.detailView.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height)];
    [self.view addSubview:self.detailView];
    
    [self.myPositionButton addTarget:self action:@selector(getUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.detailView setAlpha:0];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"last location : %@", [locations lastObject]);
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D zoomLocation = location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2 * METERS_PER_MILE, 2 * METERS_PER_MILE);
    [UIView animateWithDuration:0.8 animations:^{
        [self.mapView setRegion:viewRegion];
    }];
    
   // self.longitude = location.coordinate.longitude;
   // self.latitude = location.coordinate.latitude;
    NSArray *overlays = self.mapView.overlays;
    for (id overlay in overlays) {
        [self.mapView removeOverlay:overlay];
    }
    
    //[self.userPosition startUpdatingLocation];
    CLLocationDistance fenceDistance = (int)self.slider.value;
    CLLocationCoordinate2D circleMiddlePoint = location.coordinate;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    [self.mapView addOverlay:circle];
    
    [self.userPosition stopUpdatingLocation];
}

- (void)getUserLocation
{
    NSLog(@"get location");
    [self.userPosition startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"sender.value : %f", sender.value);
    [self getUserLocation];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    circleR.fillColor = [UIColor purpleColor];
    circleR.alpha = 0.2;
    
    return circleR;
}

    
    
    /*
- (void)goToUserLocation
{
    NSArray *overlays = self.mapView.overlays;
    for (id overlay in overlays) {
        [self.mapView removeOverlay:overlay];
    }
    
    [self.userPosition startUpdatingLocation];
    CLLocationDistance fenceDistance = (int)self.slider.value;
    CLLocationCoordinate2D circleMiddlePoint = self.userPosition.location.coordinate;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    [self.mapView addOverlay:circle];
}*/

- (void)getAllOtherUsers
{
    CLLocationCoordinate2D coord1;
    coord1.latitude = 45.001245;
    coord1.longitude = 4.001212;
    UserAnnotation *ann = [[UserAnnotation alloc] initWithCoordinate:coord1 username:@"user1" track:@"song1" artist:@"John Newman" album:@"song1.jpg"];
    
    [self.mapView addAnnotation:ann];
}

    /*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D zoomLocation = newLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2 * METERS_PER_MILE, 2 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion];
    
    [self.userPosition stopUpdatingLocation];
} */

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"customIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
    } else {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = NO;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        UIImage *img = [UIImage imageNamed:@"user_location.png"];
        CGSize newSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        annotationView.image = newImage;
    } else {
        UIImage *img = [UIImage imageNamed:@"other_location.png"];
        CGSize newSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        annotationView.image = newImage;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]]) {
        UserAnnotation *userAnnot = (UserAnnotation *)view.annotation;
        
        if (self.detailView.alpha == 0) {
            [UIView animateWithDuration:1 animations:^{
                [self.mapView setFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.mapView.frame.size.height - self.detailView.frame.size.height)];
                [self.detailView setAlpha:1];
            }];
        }
        
    }
    
    CLLocationCoordinate2D zoomLocation = view.annotation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1 * METERS_PER_MILE, 1 * METERS_PER_MILE);
    
    [UIView animateWithDuration:0.8 animations:^{
        [self.mapView setRegion:viewRegion];
    }];
}

- (void)goToArtistView:(UITapGestureRecognizer *)reco
{
    NSLog(@"ok tapped");
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
