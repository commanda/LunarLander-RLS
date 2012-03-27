//
//  AWSpaceShipSprite.h
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 Meteor Grove Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AWSpaceShipSprite : CCSprite 
{
	CCSprite *thrusterFlames;
	float currentVelocity;
	CCNode *crashFlames;
}

@property BOOL didCrash;
@property BOOL didLand;
@property (nonatomic) BOOL isPushingThruster;

-(id)initDefault;

/*
 Reset the ship to its starting position.
 */
-(void)startOver;

/*
 Starts gravity pulling on the space ship. 
 */
-(void)startGravity;

/*
 Treat the thruster as an on/off so we can display the fire sprite animation under the spaceship.
 */
-(void)setIsPushingThruster:(BOOL)value;

/*
 Returns the altitude relative to the landing spot
 */
-(int)altitude;

/*
 Returns a new flames sprite that's animating
 */
-(CCSprite *)animatingFlamesSprite;

/*
 Change to our crashed image
 */
-(void)appearCrashed;

/*
 Become engulfed in flames!
 */
-(void)becomeEngulfedInFlames;

@end
