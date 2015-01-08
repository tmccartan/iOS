//
//  Photo+Flickr.m
//  FlickrBrowser
//
//  Created by comp41550 on 18/03/2014.
//  Copyright (c) 2014 comp41550. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSString *unique = dict[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        NSLog(@"Error -- or multiple exisitng error " );
        // handle error
    } else if ([matches count]) {
        photo = [matches firstObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = unique;
        photo.title = [dict valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [dict valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.thumbnail = [dict valueForKey:@"thumbnail"];
        photo.owner = [dict valueForKey:FLICKR_PHOTO_OWNER];
        photo.imageURL = [[FlickrFetcher urlForPhoto:dict format:FlickrPhotoFormatLarge] absoluteString];
        //photo.whoTook = 
    }
    return photo;
}


@end
