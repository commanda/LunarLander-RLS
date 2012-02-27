//
//  AWLunarLanderGameLayer.m
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AWLunarLanderGameLayer.h"


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
		background.anchorPoint = ccp(0,0);
		background.position = ccp(0,0);
		[self addChild:background];
	}
	
	return self;
	
}


@end
