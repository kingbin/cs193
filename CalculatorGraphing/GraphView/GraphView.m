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

@interface GraphView()
	@property (nonatomic) CGFloat scale;
//	@property (nonatomic) CGPoint axesPoint;
@end


@implementation GraphView

	@synthesize dataSource = _dataSource;

	#define DEFAULT_SCALE 10
	@synthesize scale = _scale;
	- (CGFloat)scale
	{
		if (!_scale) {
			return DEFAULT_SCALE; // don't allow zero scale
		} else {
			return _scale;
		}
	}

//	@synthesize axesPoint = _axesPoint;
//	- (CGPoint)axesPoint
//	{
//		CGPoint graphPoint; // center of our bounds in our coordinate system if it hasn't been set
//		if(_axesPoint.x == 0)
//			graphPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
//		if(_axesPoint.y == 0)
//			graphPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
//		if(graphPoint.x != 0 || graphPoint.y != 0)
//			_axesPoint = graphPoint;
//		
//		return _axesPoint;
//	}


	- (void)pinch:(UIPinchGestureRecognizer *)gesture
	{
		if ((gesture.state == UIGestureRecognizerStateChanged) ||
			(gesture.state == UIGestureRecognizerStateEnded)) {
			self.scale *= gesture.scale; // adjust our scale
			gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
		}
	}

//	- (void)tripleTap:(UITapGestureRecognizer *)gesture
//	{
//		if (gesture.state == UIGestureRecognizerStateEnded) {
//			self.axesPoint = [gesture locationOfTouch:0 inView:self];
//		}
//	}

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

	- (void)drawTrigFunctioninContext:(CGContextRef)context
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

	- (void)drawAxes:(CGPoint)axesPoint inContext:(CGContextRef)context
	{
		UIGraphicsPushContext(context);
		[AxesDrawer drawAxesInRect:self.bounds originAtPoint:axesPoint scale:self.scale];
		UIGraphicsPopContext();
	}

	- (void)drawProgram:(NSArray *) function atAxesPoint:(CGPoint)axesPoint inContext:(CGContextRef)context
	{
		NSArray *functionArray = [[CalculatorBrains descriptionOfProgram:function] componentsSeparatedByString:@","];
		
		for(NSString *s in functionArray){
			NSMutableString	 *f = [NSMutableString stringWithFormat:@"%@", s];
			[f replaceOccurrencesOfString:@"x" withString:@"$x" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
			[f replaceOccurrencesOfString:@"y" withString:@"$y" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
			[f replaceOccurrencesOfString:@"z" withString:@"$z" options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
			
			if ([f isEqualToString:@"Tan"] || [f isEqualToString:@"Sin"]  || [f isEqualToString:@"Cos"] ) {
				[self drawTrigFunctioninContext:context];
			}
			else {
				//double d = topPoint.y - ( [[f numberByEvaluatingString] doubleValue] * self.scale );
				//[[DDMathEvaluator sharedMathEvaluator] evaluateString:f withSubstitutions:[self.dataSource useVariables:self]];
				double d = axesPoint.y - ( [[[DDMathEvaluator sharedMathEvaluator] evaluateString:f withSubstitutions:[self.dataSource useVariables:self]] doubleValue] * self.scale );

				[self drawLineFunction:d inContext:context];
			}
		}
	}

	- (void)drawRect:(CGRect)rect
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGPoint axesPoint = [self.dataSource drawAxes:self];
		self.scale = [self.dataSource drawScale:self];
		
		[self drawAxes:axesPoint inContext:context];
		
		// Draw Function
		NSArray *function = [self.dataSource drawFunctionGraphView:self];
		[self drawProgram:function atAxesPoint:axesPoint inContext:context];
	}

@end
