//
//  AWSpaceShipSprite.m
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AWSpaceShipSprite.h"

#define ACCELERATION 10.0
#define THRUST_ACCELERATION 20.0
#define START_Y (winSize.height - 100)
#define MOON_SURFACE_Y 150
#define CRASH_VELOCITY 10


@implementation AWSpaceShipSprite

@synthesize didCrash;

-(id)initWithFile:(NSString *)filename
{
	self = [super initWithFile:filename];
	
	if(self)
	{
		
		// Create the 2-frame sprite animation for the flames
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flames.plist"];
		CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"flames.png"];
		[self addChild:batchNode];
		
		// Put these two frames into an array
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
		flames = [CCSprite spriteWithSpriteFrameName:@"flame-sprite-0.png"];
		
		// Anchor it in the middle horizontally and vertically
		flames.anchorPoint = ccp(0.5, 0.5);
		flames.position = ccp(self.boundingBox.size.width/2, 0);
		[self addChild:flames z:-1];
		
		// Tell the flames to animate with the animation action we made for it
		[flames runAction:action];
		
		[self startOver];
	}
	
	return self;
}

-(void)startOver
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, START_Y);
	self.didCrash = NO;
	currentVelocity = 0;
	[self unscheduleUpdate];
}

-(void)startGravity
{
	[self scheduleUpdate];
}

-(void)pushThruster:(ccTime)dt
{
	currentVelocity = currentVelocity - (THRUST_ACCELERATION * dt);
}

-(void)update:(ccTime)dt
{
	// Only run the update if we haven't already crashed
	if(!didCrash)
	{
		// Apply gravity so that the current velocity is getting bigger and bigger linearly
		currentVelocity = currentVelocity + (ACCELERATION * dt);
		
		// Print out what current velocity is to the log
		NSLog(@"currentVelocity: %f", currentVelocity);
		
		// Given the velocity, apply that to the position so that the ship drops downward exponentially
		CGFloat nextY = self.position.y - currentVelocity;
		
		// The ship stays at the same x all the time, but its y changes
		self.position = ccp(self.position.x, nextY);
		
		// Have we hit the surface of the moon? If so, we don't go any further down.
		if(self.position.y <= MOON_SURFACE_Y)
		{
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

@end
