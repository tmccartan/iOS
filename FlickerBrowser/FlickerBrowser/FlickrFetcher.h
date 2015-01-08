//
//  FlickrFetcher.h
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define MAX_RESULT 100
#define FLICKR_PLACE_ID @"place_id"
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_TAG_NAME @"_content"
#define FLICKR_PLACES @"places.place"
#define FLICKR_TAGS @"tags.tag"
#define FLICKR_PHOTOS @"photos.photo"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"
#define FLICKR_PHOTO_TITLE @"title"

typedef enum {
	FlickrPhotoFormatSquare = 1,
	FlickrPhotoFormatLarge = 2,
	FlickrPhotoFormatThumbnail = 3,
	FlickrPhotoFormatSmall = 4,
	FlickrPhotoFormatMedium500 = 5,
	FlickrPhotoFormatMedium640 = 6,
	FlickrPhotoFormatOriginal = 64
} FlickrPhotoFormat;

@interface FlickrFetcher : NSObject

+ (NSURL *)urlForPlacesFindByLatLon:(CLLocationCoordinate2D)location;
+ (NSURL *)urlForPlacesTagsForPlace:(NSString *)placeID;
+ (NSURL *)urlForPhotosInPlace:(NSString *)placeID andTag:(NSString *)tag;
+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;
+ (void)startFlickrFetch:(NSURL *)url completion:(void (^)(NSData *data))completion;

@end