//
//  PulseWorkOutViewController.m
//  Pulse
//
//  Created by CSIADMIN on 15/03/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "PulseWorkOutViewController.h"
#import "PulseTimer.h"
#import "PulseHeartRate.h"
#import "Workout+Pulse.h"
#import "PulseAppDelegate.h"

@interface PulseWorkOutViewController () <PulseTimerDelegate, PulseHeartRateDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UILabel *lblHeartRate;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblCalCount;
@property (weak, nonatomic) IBOutlet UILabel *lblAvgHR;
@property (weak, nonatomic) IBOutlet UILabel *lblHeartSign;
@property (strong, nonatomic) PulseTimer *timerObj;
@property (strong, nonatomic) PulseHeartRate *heartRateObj;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong,nonatomic) NSMutableArray *heartRates;
@property (strong,nonatomic) NSNumber *avgHR;
@property (strong,nonatomic) NSNumber *calories;

@property (nonatomic) BOOL isRunning;
@property (nonatomic) BOOL hasStarted;
@end
@implementation PulseWorkOutViewController

-(NSManagedObjectContext*)context
{
    if(!_context)
    {
        _context = ((PulseAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return _context;
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self finishActivity];
}
-(void)finishActivity {
    
    if(self.hasStarted)
    {
        Workout *newWorkout = [Workout createWorkout:self.context];
        newWorkout.dateCreated = [NSDate date];
        newWorkout.avgHR = self.avgHR;
        newWorkout.totalTime = self.timerObj.totalTime;
        newWorkout.heartRateData = [NSKeyedArchiver archivedDataWithRootObject:self.heartRates];
        newWorkout.calories = self.calories;
          [((PulseAppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timerObj = [PulseTimer new];
    self.timerObj.delegate = self;
    self.heartRateObj = [ PulseHeartRate new];
    self.heartRateObj.delegate = self;
    [self.heartRateObj startHeartRateCapture];
}
- (IBAction)btnStopClicked:(id)sender {
    
    //enable start button
    //disable stop button
    //stop timer
    //stop heartrate recording
    self.btnStop.enabled = NO;
    self.btnStart.enabled = YES;
    self.isRunning = NO;
    [self.timerObj stopTimer];
}
- (IBAction)btnStartClicked:(id)sender {
    
    //disable start button
    //enable stop button
    //kickoff timer
    //start recording heart rate
    if(!self.hasStarted)
    {
        self.heartRates = [NSMutableArray array];
        self.hasStarted = YES;
    }
    self.btnStop.enabled = YES;
    self.btnStart.enabled = NO;
    self.isRunning = YES;
    [self.timerObj startTimer];
   }
-(void) timerTick{
    
    self.lblTimer.text = self.timerObj.currentTime;
}
-(void) heartBeat:(NSInteger)bpm{
    
    
    [self makeHeartLabelBeat:bpm];
    
    if(self.isRunning)
    {
        [self.heartRates addObject:[NSNumber numberWithInteger:bpm]];
        [self updateAvgHeartRate];
        [self updateCalories:bpm];
    }
  

    //update AVG
    //update KCALS
        
}
-(void) updateAvgHeartRate{
    
    NSNumber *avgHR = [self.heartRates valueForKeyPath:@"@avg.self"];
    self.lblAvgHR.text = [NSString stringWithFormat:@"%ld",(long)avgHR.integerValue];
    self.avgHR = avgHR;
}
-(void) updateCalories:(NSInteger) bpm{
    
    //((-55.0969 + (0.6309 x HR) + (0.1988 x W) + (0.2017 x A))/4.184) x 60 x T
    double totalCals = (((-55.096 +(0.6309 * self.avgHR.doubleValue)+(0.1988 * 95) +(0.2017 * 26))/4.184) * 60 *(self.timerObj.totalTime.doubleValue / 3600));
    self.calories = [NSNumber numberWithDouble:totalCals];
    self.lblCalCount.text = [NSString stringWithFormat:@"%ld",(long)self.calories.integerValue];
}
-(void)makeHeartLabelBeat: (NSInteger) bpm{
    self.lblHeartRate.text = [NSString stringWithFormat:@"%ld",(long)bpm];
    
    if(bpm >= 80 && bpm <= 140)
    {
        self.lblHeartRate.textColor = [UIColor greenColor];
        self.lblHeartSign.textColor = [UIColor greenColor];
    }
    else if(bpm >= 140 && bpm <= 160)
    {
        self.lblHeartRate.textColor = [UIColor yellowColor];
        self.lblHeartSign.textColor = [UIColor yellowColor];
    }
    else if (bpm >= 160 && bpm <= 180)
    {
        self.lblHeartRate.textColor = [UIColor redColor];
        self.lblHeartSign.textColor = [UIColor redColor];
    }
    else
    {
        self.lblHeartRate.textColor = [UIColor whiteColor];
        self.lblHeartSign.textColor = [UIColor whiteColor];
    }
    
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform"];
    ba.autoreverses = YES;
    ba.duration = 0.3;
    ba.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)];
    [self.lblHeartSign.layer addAnimation:ba forKey:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
