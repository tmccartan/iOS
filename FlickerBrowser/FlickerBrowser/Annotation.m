//
//  Annotation.m
//  FlickrBrowser
//
//  Created by comp41550 on 18/03/2014.
//  Copyright (c) 2014 comp41550. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if ([placemarks count] > 0 && error == nil)
        {
            self.placemark = placemarks[0];
            NSArray *formattedAddressLines = self.placemark.addressDictionary[@"FormattedAddressLines"];
            self.title = [formattedAddressLines componentsJoinedByString:@", "];
        }
    }];
    
    _coordinate = coordinate;
}

@end
