//
//  PolygonView.h
//  HelloPolly
//
//  Created by CSIADMIN on 09/01/2014.
//  Copyright (c) 2014 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class PolygonView;
//All classes that define themselves as PolygonViewDelegates must implement these. (Similar to interface)
@protocol PolygonViewDelegate <NSObject>
-(NSArray *)pointsForPolygonInRect:(CGRect)rect;

@end

@interface PolygonView : UIView

@property (nonatomic,weak) IBOutlet id <PolygonViewDelegate> delegate;
@property (nonatomic,strong) UIColor* fillColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic,strong) UIColor * borderColor;

@end

