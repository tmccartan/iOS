//
//  HelloPollyViewController.m
//  HelloPolly
//
//  Created by CSIADMIN on 09/01/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "HelloPollyViewController.h"
#import "PolygoneShape.h"
#import "PolygonView.h"


@interface HelloPollyViewController () <PolygonViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *polygoneDisplay;
@property (weak, nonatomic) IBOutlet UILabel *numSidesLabel;
@property (weak, nonatomic) IBOutlet UILabel *polygonName;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightGesture;

@property (strong,nonatomic) PolygoneShape *polygoneShapeModel;
@property (strong, nonatomic) PolygonView *polgoneView;
@end

@implementation HelloPollyViewController

-(PolygoneShape*) polygoneShapeModel
{
    if(!_polygoneShapeModel)
    {
        _polygoneShapeModel = [PolygoneShape new];
    }
    return _polygoneShapeModel;
}
-(PolygonView *) polgoneView
{
    //I impleneted it like this so that polgoneView can be removed and recreated in memory
    // if the is a system memory warning raised
    if(!_polgoneView)
    {
        _polgoneView = [[PolygonView alloc] initWithFrame:CGRectMake(0, 0, self.polygoneDisplay.frame.size.width,self.polygoneDisplay.frame.size.height)];
        _polgoneView.delegate = self;
    }
    return _polgoneView;
}
//implement Protocol
-(NSArray *) pointsForPolygonInRect:(CGRect)rect
{
    return [self.polygoneShapeModel pointsForPolygonInRect:rect];
}

-(void)updateUI
{
    self.numSidesLabel.text = [NSString stringWithFormat:@"%d",self.polygoneShapeModel.numberOfSides];
    self.polygonName.text = self.polygoneShapeModel.name;
    
    if(self.polygoneShapeModel.numberOfSides == 3)
    {
        self.decreaseButton.enabled = NO;
        self.swipeRightGesture.enabled = NO;
    }
    else
    {
        self.decreaseButton.enabled = YES;
        self.swipeRightGesture.enabled = YES;
    }
    if(self.polygoneShapeModel.numberOfSides == 12)
    {
        self.increaseButton.enabled = NO;
        self.swipeLeftGesture.enabled = NO;
    }
    else
    {
        self.increaseButton.enabled = YES;
        self.swipeLeftGesture.enabled = YES;
    }
    //Set the frame to be redrawn
    [self.polgoneView setNeedsDisplay];
    
    //Store Users picks
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:self.polygoneShapeModel.numberOfSides forKey:@"numberOfSides"];
    [defaults synchronize];

}
- (IBAction)increaseSides:(id)sender {
    
    self.polygoneShapeModel.numberOfSides = self.polygoneShapeModel.numberOfSides+1;
    [self updateUI];
}
- (IBAction)decreaseSides:(id)sender {
    
     self.polygoneShapeModel.numberOfSides = self.polygoneShapeModel.numberOfSides-1;
    [self updateUI];
}
- (IBAction)swipeLeftGesture:(id)sender {
     [self increaseSides:sender];
}
- (IBAction)swipeRightGesture:(id)sender {
    [self decreaseSides:sender];
}

//Disable rotation since its not supported
- (BOOL)shouldAutorotate{

    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //if no user defaults use labels text
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"numberOfSides"])
    {
        self.polygoneShapeModel.numberOfSides = [[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfSides"];
    }
    else
    {
        self.polygoneShapeModel.numberOfSides = [self.numSidesLabel.text integerValue];
    }
    //add the view to the display holder
    [self.polygoneDisplay addSubview:self.polgoneView];
    [self updateUI];
   

	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidUnload {
    self.polygoneShapeModel = nil;
    self.polgoneView = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
