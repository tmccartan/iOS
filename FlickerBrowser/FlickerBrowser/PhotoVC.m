//
//  PhotoVC.m
//  FlickrBrowser
//
//  Created by comp41550 on 18/03/2014.
//  Copyright (c) 2014 comp41550. All rights reserved.
//

#import "PhotoVC.h"
#import "FlickrFetcher.h"
#import "FlickerBrowserAppDelegate.h"
#import "Photo+Flickr.h"

@interface PhotoVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *addToFavBtn;
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation PhotoVC

-(NSManagedObjectContext*)context
{
    if(!_context)
    {
        _context = self.dataModel.managedObjectContext;
    }
    return _context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.spinner startAnimating];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.imageView];
    
    // Hide Favourites Icon if coming from favourites
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

// Image property has no _image iVar, using the image property of our imageview
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    [self updateContentSize];
    [self.spinner stopAnimating];
}

- (UIImage *)image
{
    return self.imageView.image;
}
-(void) setDelegate:(id<PhotoVCDelegate>)delegate
{
    _delegate = delegate;
    self.addToFavBtn.hidden = NO;
}
- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    self.scrollView.delegate = self;
}
- (void)updateContentSize
{
    self.scrollView.contentSize = CGSizeZero;
    if (self.image) {
        self.scrollView.contentSize = self.image.size;
        self.scrollView.minimumZoomScale = 0.2;
        self.scrollView.maximumZoomScale = 5.0;
    }
}

- (void)setPhotoURL:(NSURL *)photoURL
{
    _photoURL = photoURL;
    
    [FlickrFetcher startFlickrFetch:_photoURL completion:^(NSData *data) {
        if (data)
        {
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
        }
    }];
}

- (IBAction)addImageToFavourites:(id)sender {
    
    [self.delegate addPhotoToFavourites];
 }

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //NSLog(@"%f", scale);
}
@end
