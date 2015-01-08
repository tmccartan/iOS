//
//  PhotoVC.h
//  FlickrBrowser
//
//  Created by comp41550 on 18/03/2014.
//  Copyright (c) 2014 comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo+Flickr.h"

@class PhotoVC;
@protocol PhotoVCDelegate <NSObject>

-(void) addPhotoToFavourites;

@end

@interface PhotoVC : UIViewController
@property (nonatomic,weak) id <PhotoVCDelegate> delegate;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) Photo *dataModel;
//change this to Photo.H object
@end
