//
//  GuiltyViewController.m
//  NSAPrivacyViolator
//
//  Created by Stephen Compton on 1/22/14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import "GuiltyViewController.h"
#import <MapKit/MapKit.h>

@interface GuiltyViewController ()

{
    __weak IBOutlet MKMapView *map;
    
}

@end

@implementation GuiltyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    //request.region;
    request.naturalLanguageQuery = @"prison";
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        
//        NSLog(@"%@", response);
//        CLLocationCoordinate2D coordinate = [response.mapItems.firstObject placemark].coordinate;
//        MKCoordinateSpan span = MKCoordinateSpanMake((1, 1);
//        map.region = MKCoordinateRegionMake(coordinate, span);
        [self showDirectionsTo:response.mapItems.firstObject];
        
    }];
    
                                                     }

-(void)showDirectionsTo:(MKMapItem*)destinationItem
{
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destinationItem;
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKPolyline *polyline = [response.routes.firstObject polyline];
        [map addOverlay:polyline level:MKOverlayLevelAboveRoads];
    }];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc]initWithPolyline:overlay];
    routeRenderer.strokeColor = [UIColor redColor];
    return routeRenderer;
}


@end
