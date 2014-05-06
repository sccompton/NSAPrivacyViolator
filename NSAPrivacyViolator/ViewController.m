//
//  ViewController.m
//  NSAPrivacyViolator
//
//  Created by Stephen Compton on 1/22/14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>


@interface ViewController () <CLLocationManagerDelegate, UIActionSheetDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    __weak IBOutlet UILabel *addressLabel;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
}
- (IBAction)startViolatingPrivacy:(id)sender {
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIActionSheet *sheet = [UIActionSheet new];
    sheet.title = @"please";
    [sheet addButtonWithTitle:@"OK then"];
    [sheet addButtonWithTitle:@"No"];
    sheet.delegate = self;
    [sheet showInView:self.view];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy > 1000 || location.horizontalAccuracy > 1000) {
            continue;
        }
        currentLocation = location;
        [locationManager stopUpdatingLocation];
        
        CLGeocoder *geocoder = [CLGeocoder new];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark *placemark in placemarks)
            {
                NSLog(@"%@", placemark);
                addressLabel.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
                
                addressLabel.text = [NSString stringWithFormat:@"%@\nViolating privacy and determining guilt . . . ", addressLabel.text];
                
                [self performSelector:@selector(guilty) withObject:nil afterDelay:3];
            }
        }];
        break;
    }
    
}

-(void)guilty
{
    NSLog(@"guilty");
    [self performSegueWithIdentifier:@"GuiltSegue" sender:self.view];
}

@end
