//
//  AWSpaceShipSprite.m
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AWSpaceShipSprite.h"

#define GRAVITY_RATE 10.0


@implementation AWSpaceShipSprite

-(id)initWithFile:(NSString *)filename
{
	self = [super initWithFile:filename];
	
	if(self)
	{
		
	}
	
	return self;
}

-(void)startOver
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, winSize.height - 100);
}

-(void)startGravity
{
	[self scheduleUpdate];
}

-(void)update:(ccTime)dt
{
	
	CGFloat nextY = self.position.y - dt * GRAVITY_RATE;
	
	CGPoint nextPosition = ccp(self.position.x, nextY);
	
	self.position = nextPosition;
	
}

@end
