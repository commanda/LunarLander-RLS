//
//  AWLunarLanderGameLayer.h
//  LunarLander-RLS
//
//  Created by awixted on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class AWSpaceShipSprite;

@interface AWLunarLanderGameLayer : CCLayer <CCTargetedTouchDelegate>
{
    AWSpaceShipSprite *shipSprite;
	BOOL isTouchingScreen;
}

+(CCScene *) scene;

@end
