//
//  Workout.h
//  Pulse
//
//  Created by CSIADMIN on 23/04/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Workout : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * avgHR;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) NSData * heartRateData;

@end
