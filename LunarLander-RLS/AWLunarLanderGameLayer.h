//
//  AWLunarLanderGameLayer.h
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 Meteor Grove Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class AWSpaceShipSprite;

@interface AWLunarLanderGameLayer : CCLayer <CCTargetedTouchDelegate>
{
    AWSpaceShipSprite *shipSprite;
	CCMenu *menu;
	CCLabelTTF *altitudeLabel;
	CCSprite *wonSprite;
	CCSprite *loseSprite;
	BOOL handledGameover;
}

+(CCScene *) scene;

@end
