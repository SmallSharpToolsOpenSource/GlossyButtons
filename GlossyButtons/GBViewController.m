//
//  GBViewController.m
//  GlossyButtons
//
//  Created by Brennan Stehling on 4/6/12.
//  Copyright (c) 2012 SmallSharpTools LLC. All rights reserved.
//

#import "GBViewController.h"

#import "GBGlossyButton.h"

#pragma mark -
#pragma mark -

@interface GBViewController ()

@property (retain, nonatomic) IBOutlet GBGlossyButton *button1;
@property (retain, nonatomic) IBOutlet GBGlossyButton *button2;
@property (retain, nonatomic) IBOutlet GBGlossyButton *button3;
@property (retain, nonatomic) IBOutlet GBGlossyButton *button4;
@property (retain, nonatomic) IBOutlet GBGlossyButton *button5;
@property (retain, nonatomic) IBOutlet GBGlossyButton *button6;

- (IBAction)tappedButton:(id)sender;

@end

@implementation GBViewController

#pragma mark -
#pragma mark -

@synthesize button1 = _button1;
@synthesize button2 = _button2;
@synthesize button3 = _button3;
@synthesize button4 = _button4;
@synthesize button5 = _button5;
@synthesize button6 = _button6;

#pragma mark -
#pragma mark -

- (void)dealloc {
    [_button1 release];
    [_button2 release];
    [_button3 release];
    [_button4 release];
    [_button5 release];
    [_button6 release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setButton4:nil];
    [self setButton5:nil];
    [self setButton6:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)tappedButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    DebugLog(@"Button tapped: %i", button.tag);
}

@end
