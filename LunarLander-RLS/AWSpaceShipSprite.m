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
@synthesize isPushingThruster;

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
	isPushingThruster = value;
}


-(void)pseudocodeUpdate:(ccTime)dt
{
	// if we haven't already landed,
		// find out how much we're going to change the velocity 
		// change the velocity by that much
		
		// if the thruster is on
			// lessen the current velocity
	
		// apply the velocity to the position of the ship so it moves
	
		// if we've hit the ground
			// stop the ship from going any further down
			// if the ship was going too fast, 
				// we crashed

}

-(void)updateWithoutComments:(ccTime)dt
{
//	if(!didLand)
//	{
//		float velocityChange = _____;
//		currentVelocity = _____;
//		if(isPushingThruster)
//		{
//			float thrusterVelocityChange = ______;
//			currentVelocity = ______;
//		}
//		
//		_____;
//		
//		if(_____)
//		{
//			didLand = YES;
//			if(_____)
//			{
//				didCrash = YES;
//			}
//		}
//	}
}

-(void)update:(ccTime)dt
{
	// Only run the update if we haven't already landed
//	if(!didLand)
//	{
//
//		// We accelerate downward at 10 pixels per second per second.
//		// "dt" stands for "delta time" is how much time has passed since the last time this function was called, so it's around 0.05 seconds
//		// Using our number 10, and our number dt, how do we create the value that we're going to use to change our velocity?
//		// How much should the velocity change every 0.05 seconds, if we're trying to make it change 10 pixels every second?
//		float velocityChange = _____;
//
//
//		// Now how do we use the value we made, velocityChange to change our variable currentVelocity?
//		currentVelocity = _____;
//		
//		// If the player is touching the screen, that means they want the thruster to be on.
//		// When the thruster is on, the spaceship should push against gravity
//		if(isPushingThruster)
//		{
//			float thrusterVelocityChange = _______;
//			
//			// Now we apply thrusterVelocityChange to the ship's currentVelocity
//			currentVelocity = _____;
//		}
//		
//		// What do we do here to make the ship move?
//		// We can use our variables position and currentVelocity
//		_____;
//		
//		// How do we know when to stop the ship from moving?
//		if(_____)
//		{
//			// Now we know that we landed, so set that variable to YES so that the game (the other file) knows about it and can bring up the "restart" button.
//			didLand = YES;
//			
//			// What should we do with the position of the ship to stop it from keeping going downward?
//			
//			// How do we find out if we crashed or if we won? Hint: This depends on how fast the ship was going when it hit the surface.
//			if(_____)
//			{
//				// We crashed!
//				didCrash = YES;
//			}
//		}
//	}
	
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
