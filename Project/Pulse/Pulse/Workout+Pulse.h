//
//  Workout+Pulse.h
//  Pulse
//
//  Created by CSIADMIN on 23/04/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "Workout.h"

@interface Workout (Pulse)
+ (Workout *)createWorkout: (NSManagedObjectContext *)context;
@end
