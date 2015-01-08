//
//  Photo+Flickr.h
//  FlickrBrowser
//
//  Created by comp41550 on 18/03/2014.
//  Copyright (c) 2014 comp41550. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;

@end
