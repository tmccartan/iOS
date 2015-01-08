//
//  FavouritesTVC.m
//  FlickerBrowser
//
//  Created by CSIADMIN on 20/03/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "FavouritesTVC.h"
#import "PhotoVC.h"
#import "FlickerBrowserAppDelegate.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@interface FavouritesTVC ()
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation FavouritesTVC

-(NSManagedObjectContext*)context
{
    if(!_context)
    {
        _context = ((FlickerBrowserAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return _context;
}

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    //sort descriptors !!
    request.sortDescriptors = @[];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.debug = YES;
    [self setupFetchedResultsController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Photo * photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
    return cell;
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.context deleteObject:photo];
        [((FlickerBrowserAppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
        
    }
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
        if([segue.destinationViewController isKindOfClass:[PhotoVC class]])
        {
            NSIndexPath *index = [self.tableView indexPathForSelectedRow];
            Photo *photo = (Photo *) [self.fetchedResultsController objectAtIndexPath:index];
            NSURL *photoURL = [NSURL URLWithString:photo.imageURL];
            [segue.destinationViewController setPhotoURL:photoURL];
            
            PhotoVC * photoViewer = (PhotoVC *) segue.destinationViewController;
            [photoViewer setPhotoURL:photoURL];
            photoViewer.title = photo.title;

        }
}

@end
