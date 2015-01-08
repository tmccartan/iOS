//
//  PulseHeartRate.h
//  Pulse
//
//  Created by CSIADMIN on 15/03/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PulseHeartRate;

@protocol PulseHeartRateDelegate <NSObject>
-(void)heartBeat:(NSInteger) bpm;

@end
@interface PulseHeartRate : NSObject

@property (nonatomic,weak) id <PulseHeartRateDelegate> delegate;
-(void) startHeartRateCapture;
-(void) stopHeartRateCapture;
@end
