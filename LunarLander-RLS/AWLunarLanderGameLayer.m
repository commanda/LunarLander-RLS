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
#define HUD_Z 4

#define GAME_FONT @"LiquidCrystal-Bold.otf"

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
		[self addChild:menu z:HUD_Z];
		
		// The menu starts off as invisible
		menu.visible = NO;
		
		// Create the altitude display
		altitudeLabel = [CCLabelTTF labelWithString:@"ALTITUDE: " fontName:GAME_FONT fontSize:40];
		altitudeLabel.anchorPoint = ccp(0,1);
		altitudeLabel.position = ccp(10, winSize.height - 20);
		[self addChild:altitudeLabel z:HUD_Z];
		
		// Create the won and lost sprites
		wonSprite = [CCSprite spriteWithFile:@"won-image.png"];
		wonSprite.position = ccp(winSize.width/2, winSize.height/2);
		wonSprite.visible = NO;
		[self addChild:wonSprite z:HUD_Z];
		
		loseSprite = [CCSprite spriteWithFile:@"lose-image.png"];
		loseSprite.position = ccp(winSize.width/2, winSize.height/2);
		loseSprite.visible = NO;
		[self addChild:loseSprite z:HUD_Z];
		
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
	
	// Remove the win/loss sprite from the screen
	wonSprite.visible = NO;
	loseSprite.visible = NO;
	
	handledGameover = NO;
	
	// Tell the ship to prepare itself for restarting the game
	[shipSprite startOver];
	[shipSprite startGravity];
}

-(void)update:(ccTime)dt
{
	
	// Check to see if the game is over
	if(shipSprite.didLand)
	{
		
		// Check if we've already handled the gameover transition
		if(!handledGameover)
		{

			// Show the restart button so the player can restart the game
			menu.visible = YES;
			
			if(shipSprite.didCrash)
			{
				// The player lost because the ship crash landed
				loseSprite.visible = YES;
				[shipSprite becomeEngulfedInFlames];
			}
			else 
			{
				// The player won because the ship didn't crash land
				wonSprite.visible = YES;
			}
			
			// Now we have handled transitioning to the gameover state - we don't want to do that again until the player restarts and then wins or loses again
			handledGameover = YES;
		}
	}
	// If we haven't crashed, see if we need to update the thruster velocity on the spaceship
	else 
	{
		if(isTouchingScreen)
		{
			[shipSprite pushThruster:dt];
		}
	}
	
	// Update the altitude label's number using the y position of the spaceship
	int altitude = [shipSprite altitude];
	altitudeLabel.string = [NSString stringWithFormat:@"ALTITUDE: %d", altitude];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
	
	isTouchingScreen = YES;
	
	// Tell the ship that the thruster should appear activated
	[shipSprite isPushingThruster:YES];
	
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	// The user lifted their finger off the screen
	isTouchingScreen = NO;
	
	// Tell the ship that the thruster should stop appearing activated
	[shipSprite isPushingThruster:NO];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	// The user's touch event was interrupted 
	isTouchingScreen = NO;

	// Tell the ship that the thruster should stop appearing activated
	[shipSprite isPushingThruster:NO];
}

@end
