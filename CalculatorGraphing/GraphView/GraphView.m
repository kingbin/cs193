//
//  GraphView.m
//  Calculator
//
//  Created by Blazek Chris on 7/12/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
//        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}

//- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
//{
//    UIGraphicsPushContext(context);
//    CGContextBeginPath(context);
//    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
//    CGContextStrokePath(context);
//    UIGraphicsPopContext();
//}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint topPoint; // center of our bounds in our coordinate system
    topPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    topPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
//	topPoint.x = self.bounds.origin.x;
//	topPoint.y = self.bounds.origin.y;
    
    CGFloat size = self.bounds.size.width / 2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= self.scale; // scale is percentage of full view size
	
	[AxesDrawer drawAxesInRect:self.bounds originAtPoint:topPoint scale:self.scale];
}


@end
