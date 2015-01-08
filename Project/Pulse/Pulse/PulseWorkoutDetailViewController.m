//
//  PulseWorkoutDetailViewController.m
//  Pulse
//
//  Created by CSIADMIN on 23/04/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "PulseWorkoutDetailViewController.h"
#import "JBLineChartView.h"
#import "PulseTimer.h"

@interface PulseWorkoutDetailViewController () <JBLineChartViewDataSource,JBLineChartViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblHeartRate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *chartHolder;
@property (strong, nonatomic) NSArray* heartRateData;


@end



@implementation PulseWorkoutDetailViewController

-(NSArray *) heartRateData
{
    if(!_heartRateData)
    {
        _heartRateData = [NSKeyedUnarchiver unarchiveObjectWithData:self.model.heartRateData];
    }
    return _heartRateData;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.model)
    {
        JBLineChartView *lineChartView = [[JBLineChartView alloc] init];
        lineChartView.delegate = self;
        lineChartView.dataSource = self;
        [self.chartHolder addSubview:lineChartView];
        lineChartView.frame = CGRectMake(0, 0, self.chartHolder.frame.size.width, self.chartHolder.frame.size.height);
        [lineChartView reloadData];
    }
	// Do any additional setup after loading the view.
}
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [self.heartRateData count]; // number of values for a line
}
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[self.heartRateData objectAtIndex:horizontalIndex] floatValue]; // y-position (y-axis) of point at horizontalIndex (x-axis)
}
- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor]; // color of line in chart
}
- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor blackColor]; // color of selected line
}
 -(BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex;
{
    return YES;
}
- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    self.lblHeartRate.text = [NSString stringWithFormat:@"%@", [self.heartRateData objectAtIndex:horizontalIndex]];
    self.lblTime.text = [PulseTimer formattedTime:horizontalIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
