//
//  FlickrFetcher.m
//


#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"

@implementation FlickrFetcher

+ (NSURL *)URLForQuery:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FlickrAPIKey];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}

+ (NSURL *)urlForPlacesFindByLatLon:(CLLocationCoordinate2D)location
{
    NSString *apiString = @"http://api.flickr.com/services/rest/?method=flickr.places.findByLatLon";
    NSString *query = [NSString stringWithFormat:@"%@&lat=%f&lon=%f&accuracy=6", apiString, location.latitude, location.longitude];
    return [FlickrFetcher URLForQuery:query];
    
}


+ (NSURL *)urlForPlacesTagsForPlace:(NSString *)placeID
{
    NSString *apiString = @"http://api.flickr.com/services/rest/?method=flickr.places.tagsForPlace";
    NSString *query = [NSString stringWithFormat:@"%@&place_id=%@&", apiString, placeID];
    return [FlickrFetcher URLForQuery:query];
}


+ (NSURL *)urlForPhotosInPlace:(NSString *)placeID andTag:(NSString *)tag
{
    NSString *apiString = @"http://api.flickr.com/services/rest/?method=flickr.photos.search";
    NSString *query = [NSString stringWithFormat:@"%@&place_id=%@&tags=%@&per_page=%d&extras=original_format,tags,description,geo,date_upload,owner_name,place_url", apiString, placeID, tag, MAX_RESULT];
    return [FlickrFetcher URLForQuery:query];
}

+ (void)startFlickrFetch:(NSURL *)url completion:(void (^)(NSData *data))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = nil;
        if (!error)
        {
            data = [NSData dataWithContentsOfURL:location];
        }
        completion(data);
    }];
    [task resume];
}

+ (NSString *)urlStringForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format {
	id farm = photo[@"farm"];
	id server = photo[@"server"];
	id photo_id = photo[@"id"];
	id secret = photo[@"secret"];
	if (format == FlickrPhotoFormatOriginal) secret = photo[@"originalsecret"];
    
	NSString *fileType = @"jpg";
	if (format == FlickrPhotoFormatOriginal) fileType = photo[@"originalformat"];
    
	if (!farm || !server || !photo_id || !secret) return nil;
    
	NSString *formatString = @"s";
	switch (format) {
		case FlickrPhotoFormatSquare:    formatString = @"s"; break; // small square 75x75
            
		case FlickrPhotoFormatLarge:     formatString = @"b"; break; // large, 1024 on longest sid
            
		case FlickrPhotoFormatThumbnail: formatString = @"t"; break; // thumbnail, 100 on longest side
            
		case FlickrPhotoFormatSmall:     formatString = @"m"; break; // small, 240 on longest side
            
		case FlickrPhotoFormatMedium500: formatString = @"-"; break; // medium, 500 on longest side
            
		case FlickrPhotoFormatMedium640: formatString = @"z"; break; // medium 640, 640 on longest side
            
		case FlickrPhotoFormatOriginal:  formatString = @"o"; break; // original image, either a jpg, gif or png, depending on source format
	}
    
	return [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
}

+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format {
	return [NSURL URLWithString:[self urlStringForPhoto:photo format:format]];
}

@end
