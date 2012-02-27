//
//  AWSpaceShipSprite.m
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AWSpaceShipSprite.h"


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

@end
