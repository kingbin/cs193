//
//  GraphView.m
//  Calculator
//
//  Created by Blazek Chris on 7/12/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "GraphView.h"
#import "CalculatorBrains.h"
#import "AxesDrawer.h"

#import "DDMathParser.h" // Using this to evaluate the NSString in my description seperated by ',' to a NSNumber

@implementation GraphView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 10

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
        self.scale *= gesture.scale; // adjust our scale
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

- (void)drawTrigFunction:(CGPoint)p /*withRadius:(CGFloat)radius*/ inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
//    CGContextBeginPath(context);
//    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
//    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawLineFunction:(CGFloat)y inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0, y );
	CGContextAddLineToPoint(context, self.bounds.size.width, y );
	[[UIColor redColor] setStroke];
	CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawAxes:(CGPoint)topPoint inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	[AxesDrawer drawAxesInRect:self.bounds originAtPoint:topPoint scale:self.scale];
    UIGraphicsPopContext();
}

- (void)drawProgram:(NSArray *) function withAxisPoint:(CGPoint)topPoint inContext:(CGContextRef)context
{
	NSArray *functionArray = [[CalculatorBrains descriptionOfProgram:function] componentsSeparatedByString:@","];
	
	for(NSString *s in functionArray){

		if ([s isEqualToString:@"Tan"] || [s isEqualToString:@"Sin"]  || [s isEqualToString:@"Cos"] ) {
			[self drawTrigFunction:topPoint inContext:context];
		}
		else {
			double d = topPoint.y - ( [[s numberByEvaluatingString] doubleValue] * self.scale );
//			double d = topPoint.y - ( [CalculatorBrains runProgram:function usingVariables:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"x"
//																							, [NSNumber numberWithInt:1],@"y"
//																							, [NSNumber numberWithInt:1],@"z", nil]] * self.scale);
			[self drawLineFunction:d inContext:context];
		}
	}
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint topPoint; // center of our bounds in our coordinate system
    topPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    topPoint.y = self.bounds.origin.y + self.bounds.size.height/2;

//	CGPoint topPoint = [self.dataSource setAxesCenterPoint:self];
	
//    CGFloat size = self.bounds.size.width / 2;
//    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
//    size *= self.scale; // scale is percentage of full view size
	
	[self drawAxes:topPoint inContext:context];
	
	// Draw Function
	NSArray *function = [self.dataSource drawFunctionGraphView:self];
	[self drawProgram:function withAxisPoint:topPoint inContext:context];
}


@end
