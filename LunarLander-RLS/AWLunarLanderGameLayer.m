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
#define SHIP_Z 2

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
	}
	
	return self;
	
}

-(void)dealloc
{
	[shipSprite release];
	[super dealloc];
}


@end
