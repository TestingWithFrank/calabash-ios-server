//
//  LPKeyboardRoute.h
//  calabash
//
//  Created by Karl Krukow on 29/01/12.
//  Copyright (c) 2012 LessPainful. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "LPGenericAsyncRoute.h"

@interface LPKeyboardRoute : LPGenericAsyncRoute
{    
    BOOL _playbackDone;
    NSArray *_events;
}
@end
