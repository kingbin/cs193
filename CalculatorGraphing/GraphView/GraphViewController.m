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
	@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;        // to put splitViewBarButtonitem in

	@property (nonatomic) CGPoint axesPoint;
	@property (nonatomic) CGFloat scale;
	@property (nonatomic, strong) NSDictionary *calcVariables;
@end

@implementation GraphViewController


/* Controller Variables
 *****************************************************/
	@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;   // implementation of SplitViewBarButtonItemPresenter protocol
	@synthesize toolbar = _toolbar;                                 // to put splitViewBarButtonItem in

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
			[[NSUserDefaults standardUserDefaults] setFloat:self.scale forKey:@"scale"];
			[[NSUserDefaults standardUserDefaults] synchronize];
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


/* Controller Specific Functions
 *****************************************************/
	- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
	{
		NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
		if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
		if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
		self.toolbar.items = toolbarItems;
		_splitViewBarButtonItem = splitViewBarButtonItem;
	}

	- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
	{
		if (splitViewBarButtonItem != _splitViewBarButtonItem) {
			[self handleSplitViewBarButtonItem:splitViewBarButtonItem];
		}
	}

	- (void)viewDidLoad
	{
		// Get the stored data before the view loads
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		self.scale = [defaults floatForKey:@"scale"];
		self.axesPoint = CGPointFromString([defaults stringForKey:@"axesPoint"]);
		
		[super viewDidLoad];
		self.title	= [CalculatorBrains descriptionOfProgram:self.programStack];
		
		[self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
	}


	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
		return YES;
		//		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}



/* GraphView Gestures and Setup
 *****************************************************/
	- (void)setGraphView:(GraphView *)graphView
	{
		_graphView = graphView;
		// enable pinch gestures in the GraphView using its pinch: handler
		//[self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
		[self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)]];
		// recognize a pan gesture and modify our Model
		[self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
		// enable triple tap gesture in the GraphView using tripleTap: handler  
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTapGesture:)];
		tapGestureRecognizer.numberOfTapsRequired = 3;
		[self.graphView addGestureRecognizer:tapGestureRecognizer];
		
		self.graphView.dataSource = self;
	}

	- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture
	{
		if ((gesture.state == UIGestureRecognizerStateChanged) ||
			(gesture.state == UIGestureRecognizerStateEnded)) {
			self.scale *= gesture.scale; // adjust our scale
			gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
		}
	}

	- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
	{
		if ((gesture.state == UIGestureRecognizerStateChanged) ||
			(gesture.state == UIGestureRecognizerStateEnded)) {
			
			CGPoint translation = [gesture translationInView:self.graphView];
			self.axesPoint = CGPointMake(self.axesPoint.x + translation.x, self.axesPoint.y + translation.y);
			[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", NSStringFromCGPoint(self.axesPoint)] forKey:@"axesPoint"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[gesture setTranslation:CGPointZero inView:self.graphView];
		}
	}

	- (void)handleTripleTapGesture:(UIPanGestureRecognizer *)gesture
	{
		if (gesture.state == UIGestureRecognizerStateEnded) {
			self.axesPoint = [gesture locationOfTouch:0 inView:self.graphView];
			[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", NSStringFromCGPoint(self.axesPoint)] forKey:@"axesPoint"];
			[[NSUserDefaults standardUserDefaults] synchronize];
//			[gesture setTranslation:CGPointZero inView:self.graphView];
		}
	}


/* GraphView Protocols
 *****************************************************/
	- (NSArray *)drawFunctionGraphView:(GraphView *)sender
	{
		//return [CalculatorBrains descriptionOfProgram:self.programStack];
		return self.programStack;
	}

	- (CGPoint)drawAxes:(GraphView *)sender
	{
		if(self.axesPoint.x == 0 && self.axesPoint.y == 0){
			self.axesPoint = CGPointMake(self.graphView.bounds.origin.x + self.graphView.bounds.size.width/2, self.graphView.bounds.origin.y + self.graphView.bounds.size.height/2);
		}
		
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

// BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
// self.splitViewController
// View On Screen -> window = nil false || self.view.window
// @psoperty (CGFloat) contentScaleFactor



@end
