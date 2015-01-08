//
//  ViewController.m
//  FlickrBrowser
//
//  Created by comp41550 on 18/03/2014.
//  Copyright (c) 2014 comp41550. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface MapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) id<MKAnnotation> annotation;

@end

@implementation MapVC


- (IBAction)dismissModalView:(id)sender
{
    [self.delegate mapVCDelegate:self didSelectLocation:self.annotation.coordinate];
}


- (IBAction)dropPin:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    
    if (self.annotation) [self.mapView removeAnnotation:self.annotation];
    
    Annotation *annotation = [Annotation new];
    annotation.coordinate = touchMapCoordinate;
    self.annotation = annotation;
    
    [self.mapView addAnnotation:self.annotation];
}

@end
