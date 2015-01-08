//
//  PolygonView.m
//  HelloPolly
//
//  Created by CSIADMIN on 09/01/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "PolygonView.h"
@implementation PolygonView

//init method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupWithDefaultValues];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    //although im not using this method since im not using the IB
    // i left it in so the view can be reused
    self =[super initWithCoder:aDecoder];
    {
        [self setupWithDefaultValues];
    }
    return self;
}
-(void) setupWithDefaultValues
{
    self.fillColor = [UIColor whiteColor];
    self.borderColor = [UIColor blackColor];
    self.backgroundColor = [UIColor blueColor];
    self.borderWidth = 4.0;
}

-(void) drawRect:(CGRect)rect{
    // Drawing code
    NSArray *polygonPoints = [self.delegate pointsForPolygonInRect:rect];
    //if theres not enough points then dont draw
    if(polygonPoints.count <2)
    {
        //log error that cant draw with only 2 points
        return;
    }
    else
    {
        // Get current contest
        CGContextRef context = UIGraphicsGetCurrentContext();
        // start the line from the context
        CGContextBeginPath (context);
        
        for(NSValue * point in polygonPoints)
        {
            //get point from array
            CGPoint val = [point CGPointValue];
            //if its the first point move to start drawing from there
            if([polygonPoints indexOfObject:point]==0)
                CGContextMoveToPoint (context, val.x, val.y);
            //else draw from the previous point to this one
            else
                CGContextAddLineToPoint (context, val.x, val.y);
        }
        //close the path to the first point
        CGContextClosePath (context);
        //CG methods require CGColor objects rather than UIColor
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        CGContextSetLineWidth(context, self.borderWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        //Draw the paths on the current context
        CGContextDrawPath (context, kCGPathFillStroke);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
