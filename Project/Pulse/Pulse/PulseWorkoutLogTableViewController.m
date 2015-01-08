//
//  PulseWorkoutLogViewController.m
//  Pulse
//
//  Created by CSIADMIN on 23/04/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "PulseWorkoutLogTableViewController.h"
#import "PulseAppDelegate.h"
#import "Workout+Pulse.h"
#import "PulseTimer.h"
#import "PulseWorkoutDetailViewController.h"
@interface PulseWorkoutLogTableViewController ()
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation PulseWorkoutLogTableViewController

-(NSManagedObjectContext*)context
{
    if(!_context)
    {
        _context = ((PulseAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return _context;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultsController];
    
	// Do any additional setup after loading the view.
}

-(void) setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    //sort descriptors !!
    request.sortDescriptors = @[];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"dateCreated" cacheName:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Workout * workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [PulseTimer formattedTime:workout.totalTime.integerValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)workout.avgHR.integerValue];
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    Workout * workout = [[sectionInfo objects] objectAtIndex:0];
    NSDateFormatter * format = [[NSDateFormatter  alloc]init];
    format.dateStyle = NSDateFormatterMediumStyle;
    format.timeStyle = NSDateFormatterMediumStyle;
    return [format stringFromDate:workout.dateCreated];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Workout * workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.context deleteObject:workout];
        [((PulseAppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
        
    }
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    PulseWorkoutDetailViewController * detailedViewer = (PulseWorkoutDetailViewController *) segue.destinationViewController;
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    detailedViewer.model = [self.fetchedResultsController objectAtIndexPath:index];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
