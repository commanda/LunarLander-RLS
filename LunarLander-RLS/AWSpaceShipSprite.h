//
//  AWSpaceShipSprite.h
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AWSpaceShipSprite : CCSprite 
{
	CCSprite *flames;
	float currentVelocity;
	BOOL didCrash;
}

/*
 Reset the ship to its starting position.
 */
-(void)startOver;

/*
 Starts gravity pulling on the space ship. 
 */
-(void)startGravity;

@end
