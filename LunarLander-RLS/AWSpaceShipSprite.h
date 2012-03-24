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
}

@property BOOL didCrash;

/*
 Reset the ship to its starting position.
 */
-(void)startOver;

/*
 Starts gravity pulling on the space ship. 
 */
-(void)startGravity;

/*
 Let the ship know that the thruster is still on and that it has been dt number of seconds since the last time we updated.
 This allows the ship to calculate its gravity value based on how long the thruster has been pushed down.
 */
-(void)pushThruster:(ccTime)dt;

/*
 Treat the thruster as an on/off so we can display the fire sprite animation under the spaceship.
 */
-(void)isPushingThruster:(BOOL)value;


@end
