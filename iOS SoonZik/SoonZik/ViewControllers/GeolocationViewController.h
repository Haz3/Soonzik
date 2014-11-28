//
//  GeolocationViewController.h
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GeolocationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIView *detailView;

@property (nonatomic, weak) IBOutlet UIButton *myPositionButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;

@property (nonatomic, strong) CLLocationManager *userPosition;

@property (nonatomic, weak) IBOutlet UIView *sliderView;

@end
