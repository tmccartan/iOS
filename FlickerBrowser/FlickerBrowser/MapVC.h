//
//  ViewController.h
//  FlickrBrowser
//
//  Created by comp41550 on 18/03/2014.
//  Copyright (c) 2014 comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapVC;

@protocol MapVCDelegate <NSObject>
- (void)mapVCDelegate:(MapVC *)mapVC didSelectLocation:(CLLocationCoordinate2D)location;
@end

@interface MapVC : UIViewController
@property (nonatomic, assign) id<MapVCDelegate> delegate;
@end
