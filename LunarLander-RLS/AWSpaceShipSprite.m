//
//  AWSpaceShipSprite.m
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 Meteor Grove Software. All rights reserved.
//

#import "AWSpaceShipSprite.h"

// Downward acceleration - gravity. This is in pixels per second per second.
#define ACCELERATION 10.0

// How much the thruster affects the ship's velocity
#define THRUST_ACCELERATION 40.0

// Where the ship starts out at - 100 px down from the top of the screen
#define START_Y (winSize.height - 100)

// Where the landing point is - this many pixels up from the bottom of the screen
#define MOON_SURFACE_Y 160

// The maximum velocity the ship can be traveling at for a safe landing to occur
#define CRASH_VELOCITY 10


@implementation AWSpaceShipSprite

@synthesize didCrash;
@synthesize didLand;

-(id)initWithFile:(NSString *)filename
{
	self = [super initWithFile:filename];
	
	if(self)
	{
		
		// Create the 2-frame sprite animation for the flames
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flames.plist"];
		CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"flames.png"];
		[self addChild:batchNode];
		
		// Get the flames animation from our creator function
		thrusterFlames = [self animatingFlamesSprite];
		
		// Anchor it in the middle horizontally and vertically
		thrusterFlames.anchorPoint = ccp(0.5, 0.5);
		thrusterFlames.position = ccp(self.boundingBox.size.width/2, 0);
		[self addChild:thrusterFlames z:-1];
		
		// The flames start out as invisible because they only show up when the user is activating the thruster.
		thrusterFlames.visible = NO;
		
		[self startOver];
	}
	
	return self;
}

-(CCSprite *)animatingFlamesSprite
{
	// Get the two flame frames from the sprite frame cache and put them into an array
	NSMutableArray *framesArray = [NSMutableArray array];
	for(int i = 0; i < 2; i++)
	{
		// flame-sprite-0.png and flame-sprite-1.png
		NSString *frameName = [NSString stringWithFormat:@"flame-sprite-%d.png", i];
		
		// Get the frame from the sprite cache and put it into our array to make the animation with
		[framesArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
	}
	
	// Now that we've got our array full of sprite frames, make an animation object
	CCAnimation *animation = [CCAnimation animationWithFrames:framesArray delay:0.1];
	
	// Make an action out of it - that runs frame 0 then frame 1
	CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
	
	// Repeat that animation action forever
	CCAction *action = [CCRepeatForever actionWithAction:animateAction];
	
	// Create the flames sprite object that we'll add the frames to for animating
	CCSprite *flamesSprite = [CCSprite spriteWithSpriteFrameName:@"flame-sprite-0.png"];

	// Tell the flames to animate with the animation action we made for it
	[flamesSprite runAction:action];
	
	return flamesSprite;
}

-(void)startOver
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// Start out at the top of the screen
	self.position = ccp(winSize.width/2, START_Y);
	
	// We haven't crashed, and we haven't landed
	self.didCrash = NO;
	self.didLand = NO;
	
	// We just started, so our velocity is 0
	currentVelocity = 0;
	
	// Hide the crash flames
	crashFlames.visible = NO;
	
	// We aren't updating yet until startGravity gets called
	[self unscheduleUpdate];
}

-(void)startGravity
{
	[self scheduleUpdate];
}

-(int)altitude
{
	// How high are we above the surface?
	return self.position.y - MOON_SURFACE_Y;
}

-(void)setIsPushingThruster:(BOOL)value
{
	thrusterFlames.visible = value;
}

-(void)pushThruster:(ccTime)dt
{
	currentVelocity = currentVelocity - (THRUST_ACCELERATION * dt);
}

-(void)update:(ccTime)dt
{
	// Only run the update if we haven't already crashed
	if(!didLand)
	{
		// How much does the velocity change every time update is called? It changes by about 0.05 seconds * 10 pixels/second^2
		float velocityChange = ACCELERATION * dt;
		
		// Apply gravity so that the current velocity is getting bigger and bigger linearly
		currentVelocity = currentVelocity + velocityChange;
		
		// Print out what current velocity is to the log
		NSLog(@"currentVelocity: %f", currentVelocity);
		
		// Given the velocity, apply that to the position so that the ship drops downward exponentially
		CGFloat nextY = self.position.y - currentVelocity;
		
		// The ship stays at the same x all the time, but its y changes
		self.position = ccp(self.position.x, nextY);
		
		// Have we hit the surface of the moon? If so, we don't go any further down.
		if(self.position.y <= MOON_SURFACE_Y)
		{
			// We landed.
			didLand = YES;
			
			// Cap it, keep the ship here at the surface
			self.position = ccp(self.position.x, MOON_SURFACE_Y);
			
			// Find out if we crashed, or if we won. This depends on how fast the craft was going when it hit the surface.
			if(currentVelocity > CRASH_VELOCITY)
			{
				// We crashed!
				didCrash = YES;
			}
		}
	}
	
}

-(void)becomeEngulfedInFlames
{
	// If we haven't created the crashFlames yet, create them
	if(!crashFlames)
	{
		// crashFlames is a node, a holder for all the flame sprites we're about to put on it
		crashFlames = [CCNode node];
		
		[self addChild:crashFlames];
	
		// We'll create 5 flame animations and put them onto the crashFlames node
		for(int i = 0; i < 5; i++)
		{
			CCSprite *moreFlames = [self animatingFlamesSprite];
			
			// Put the anchor point at the middle of the top of this sprite because visually that's where the flames sprout from
			moreFlames.anchorPoint = ccp(0.5, 1);
			
			// Give the flames a random degree of rotation, anywhere from 0 to 359 degrees
			moreFlames.rotation = arc4random() % 360;
			
			// The flames will all sprout from the center of the spaceship
			moreFlames.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
			
			[crashFlames addChild:moreFlames];
			
		}
	}
	
	crashFlames.visible = YES;
	
}

@end
