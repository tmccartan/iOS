//
//  PulseTimer.h
//  Pulse
//
//  Created by CSIADMIN on 15/03/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PulseTimer;
//All classes that define themselves as PolygonViewDelegates must implement these. (Similar to interface)
@protocol PulseTimerDelegate <NSObject>
-(void)timerTick;

@end
@interface PulseTimer : NSObject

@property (nonatomic,weak) id <PulseTimerDelegate> delegate;
@property (strong, nonatomic) NSString *currentTime;
@property (strong, nonatomic) NSNumber *totalTime;

-(void)startTimer;
-(void)stopTimer;
+(NSString*) formattedTime:(NSInteger) time;
@end
