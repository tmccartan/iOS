//
//  Workout+Pulse.m
//  Pulse
//
//  Created by CSIADMIN on 23/04/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "Workout+Pulse.h"

@implementation Workout (Pulse)

+ (Workout *)createWorkout:(NSManagedObjectContext *)context
{
    Workout *newWorkout = nil;
    
    
    newWorkout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:context];
    
    return newWorkout;
}



@end
