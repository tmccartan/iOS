//
//  PulseTimer.m
//  Pulse
//
//  Created by CSIADMIN on 15/03/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "PulseTimer.h"
@interface PulseTimer ()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) NSInteger ticker;


@end
@implementation PulseTimer
-(NSNumber*) totalTime{
    
    return [NSNumber numberWithLong:self.ticker];
}

-(void) startTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector: @selector(updateTimer) userInfo:Nil repeats:YES];

}
-(void)stopTimer{
     [self.timer invalidate];
}
-(void) updateTimer{
    self.ticker++;
    self.currentTime = [PulseTimer formattedTime:self.ticker];
   
    [self.delegate timerTick];
}
+ (NSString *)formattedTime:(NSInteger)totalSeconds
{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}

@end
