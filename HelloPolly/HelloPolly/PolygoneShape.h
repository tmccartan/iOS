//
//  PolygoneShape.h
//  HelloPolly
//
//  Created by CSIADMIN on 09/01/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolygoneShape : NSObject
@property (nonatomic) NSInteger numberOfSides;
@property (weak, readonly) NSString *name;
-(NSArray *) pointsForPolygonInRect:(CGRect) rect;
@end
