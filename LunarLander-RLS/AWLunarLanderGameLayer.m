//
//  AWLunarLanderGameLayer.m
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AWLunarLanderGameLayer.h"
#import "AWSpaceShipSprite.h"

#define BACKGROUND_Z 1
#define SURFACE_Z 2
#define SHIP_Z 3
#define RESTART_BUTTON_Z 4

@implementation AWLunarLanderGameLayer


+(CCScene *) scene
{
	
	CCScene *scene = [CCScene node];
	
	AWLunarLanderGameLayer *layer = [AWLunarLanderGameLayer node];
	
	[scene addChild: layer];
	
	return scene;
}


-(id)init
{
	
	self = [super init];
	
	if(self)
	{
		// Get the size of the screen for use in positioning stuff on it
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		// Create the background from its image file and add it as a layer 
		CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
		
		// Anchor it in its lower left corner because it's easier to position that way - we just want it to take up the whole screen and we know its size is the same size as the iPad screen.
		background.anchorPoint = ccp(0,0);
		
		// Position it in the lower left corner of the scene (screen)
		background.position = ccp(0,0);
		
		// Add it to the screen
		[self addChild:background z:BACKGROUND_Z];
		
		// Create the space ship sprite with the ship image
		shipSprite = [[AWSpaceShipSprite alloc] initWithFile:@"ship.png"];
		
		// We'll anchor it in the middle of itself - halfway in the x axis and halfway in the y axis
		shipSprite.anchorPoint = ccp(0.5, 0.5);
		
		[shipSprite startOver];
		[shipSprite startGravity];
		
		// Add the ship to the screen
		[self addChild:shipSprite z:SHIP_Z];
		
		// Create the surface of the moon
		CCSprite *surface = [CCSprite spriteWithFile:@"moon-surface.png"];
		surface.anchorPoint = ccp(0,0);
		surface.position = ccp(0,0);
		[self addChild:surface z:SURFACE_Z];
		
		// Create the "restart" button
		CCMenuItemImage *restartButton = [CCMenuItemImage itemFromNormalImage:@"restart-button.png" selectedImage:@"restart-button.png" target:self selector:@selector(pressedRestart)];
		restartButton.anchorPoint = ccp(1,1);
		menu = [CCMenu menuWithItems:restartButton, nil];
		menu.position = ccp(winSize.width - 10, winSize.height - 10);
		menu.anchorPoint = ccp(1,1);
		[self addChild:menu z:RESTART_BUTTON_Z];
		
		// The menu starts off as invisible
		menu.visible = NO;
		
		// The user is not yet touching the screen
		isTouchingScreen = NO;
		
		// Register our update function to be called on the tick
		[self scheduleUpdate];
		
		// register to receive targeted touch events
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
														 priority:0
												  swallowsTouches:YES];
	}
	
	return self;
	
}

-(void)dealloc
{
	[shipSprite release];
	[super dealloc];
}

-(void)pressedRestart
{
	NSLog(@"restart");
	
	[shipSprite startOver];
	[shipSprite startGravity];
}

-(void)update:(ccTime)dt
{
	// Check to see if the game is over - if the space ship has crashed or landed successfully
	if(shipSprite.didCrash)
	{
		// Show the restart button so the player can restart the game
		menu.visible = YES;
	}
	// If we haven't crashed, see if we need to update the thruster velocity on the spaceship
	else 
	{
		if(isTouchingScreen)
		{
			[shipSprite pushThruster:dt];
		}
	}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
	
	isTouchingScreen = YES;
	
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	// The user lifted their finger off the screen
	isTouchingScreen = NO;
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	// The user's touch event was interrupted 
	isTouchingScreen = NO;
}

@end
