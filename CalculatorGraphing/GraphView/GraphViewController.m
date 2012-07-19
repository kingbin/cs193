//
//  GraphViewControllerViewController.m
//  Calculator
//
//  Created by Blazek Chris on 7/12/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrains.h"

@interface GraphViewController ()<GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic) CGPoint axesPoint;
@property (nonatomic) CGFloat scale;
@property (nonatomic, strong) NSDictionary *calcVariables;
@end

@implementation GraphViewController

	@synthesize graphView = _graphView;
	@synthesize programStack = _programStack;
	- (void) setProgramStack:(NSArray *)programStack
	{
		if( [programStack isKindOfClass:[NSArray class]]){
			_programStack = programStack;
			[self.graphView setNeedsDisplay];
		}
	}

	@synthesize axesPoint = _axesPoint;
	- (void) setAxesPoint:(CGPoint)axesPoint
	{
		_axesPoint = axesPoint;
		[self.graphView setNeedsDisplay];
	}

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

	- (void)setScale:(CGFloat)scale
	{
		if (scale != _scale) {
			_scale = scale;
			[self.graphView setNeedsDisplay];
		}
	}

	@synthesize calcVariables = _calcVariables;
	- (NSDictionary *) calcVariables{ 
		
		if(!_calcVariables){ 
			_calcVariables = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"x"
							  , [NSNumber numberWithInt:0],@"y"
							  , [NSNumber numberWithInt:0],@"z", nil];
		}
		
		return _calcVariables;
	}






	- (void)viewDidLoad
	{
		[super viewDidLoad];
//		self.title = [[[CalculatorBrains descriptionOfProgram:self.programStack] componentsSeparatedByString:@","] lastObject];
		self.title	= [CalculatorBrains descriptionOfProgram:self.programStack];
	}

	- (void)setGraphView:(GraphView *)graphView
	{
		_graphView = graphView;
		// enable pinch gestures in the FaceView using its pinch: handler
		[self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
		// recognize a pan gesture and modify our Model
		[self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
		self.graphView.dataSource = self;
	}

	- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
	{
		if ((gesture.state == UIGestureRecognizerStateChanged) ||
			(gesture.state == UIGestureRecognizerStateEnded)) {
			
			CGPoint translation = [gesture translationInView:self.graphView];
			self.axesPoint = CGPointMake(self.axesPoint.x + translation.x, self.axesPoint.y + translation.y);
			[gesture setTranslation:CGPointZero inView:self.graphView];
		}
	}

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
		return YES;
//		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

	- (NSArray *)drawFunctionGraphView:(GraphView *)sender
	{
		//return [CalculatorBrains descriptionOfProgram:self.programStack];
		return self.programStack;
	}

	- (CGPoint)drawAxes:(GraphView *)sender
	{
		CGPoint graphPoint; // center of our bounds in our coordinate system if it hasn't been set
		if(self.axesPoint.x == 0)
			graphPoint.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width/2;
		if(self.axesPoint.y == 0)
			graphPoint.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height/2;
		if(graphPoint.x != 0 || graphPoint.y != 0)
			self.axesPoint = graphPoint;

		return self.axesPoint;
	}

	- (CGFloat)drawScale:(GraphView *)sender
	{
		return self.scale;
	}

	- (NSDictionary *)useVariables:(GraphView *)sender
	{
		return self.calcVariables;
	}

@end
