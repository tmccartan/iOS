//
//  PolygoneShape.m
//  HelloPolly
//
//  Created by CSIADMIN on 09/01/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import "PolygoneShape.h"

@implementation PolygoneShape

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        _numberOfSides = 5;
    }
    return self;
}
-(void)setNumberOfSides:(NSInteger)numberOfSides
{
    if(numberOfSides<3)
    {
        NSLog(@"Cannot have less than 3 sides");
        return;
    }
    else if(numberOfSides>12)
    {
        NSLog(@"Cannot have more than 12 sides");
        return;
    }
    _numberOfSides = numberOfSides;
}
-(NSString *)name
{
    return [ @[ @"Triangle", @"Square",@"Pentagon",@"Hexagon",
             @"Heptagon",@"Octagon",@"Nonagon",
             @"Decagon",@"Hendecagon",@"Dodecagon",
             ] objectAtIndex:self.numberOfSides-3];
}
- (NSArray *)pointsForPolygonInRect:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    float radius = 0.9 * center.x; NSMutableArray *result = [NSMutableArray array];
    float angle = (2.0 * M_PI) / self.numberOfSides;
    float exteriorAngle = M_PI - angle;
    float rotationDelta = angle - (0.5 * exteriorAngle);
    for (int currentAngle = 0; currentAngle < self.numberOfSides; currentAngle++)
    {
        float newAngle = (angle * currentAngle) - rotationDelta;
        float curX = cos(newAngle) * radius;
        float curY = sin(newAngle) * radius;
        [result addObject:[NSValue valueWithCGPoint:CGPointMake(center.x+curX,center.y+curY)]];
    }
    return result; }
@end
