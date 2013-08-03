//
//  CalabashServer.m
//
//  Created by Karl Krukow on 11/08/11.
//  Copyright 2011 LessPainful. All rights reserved.
//

#import "CalabashLoader.h"
#import "RequestRouter.h"

#import "LPAsyncPlaybackRoute.h"
#import "CalabashUISpecSelectorEngine.h"
#import "LPUserPrefCommand.h"
#import "LPAppPropertyCommand.h"
#import "LPVersionCommand.h"
#import "LPConditionRoute.h"
#import "LPRecordRoute.h"
#import "LPKeyboardRoute.h"
#import "FrankCommandRoute.h"
#import "LPMapRoute.h"
#import <dlfcn.h>


@interface SelectorEngineRegistry
+(void)registerSelectorEngine:(id <SelectorEngine>)engine WithName:(NSString *)name;
@end


@implementation CalabashLoader


+ (void)applicationDidBecomeActive:(NSNotification *)notification {
    [SelectorEngineRegistry registerSelectorEngine:[[CalabashUISpecSelectorEngine alloc] init] WithName:@"calabash_uispec"];
    NSLog(@"Calabash %@ registered with Frank as selector engine named 'calabash_uispec'",kLPCALABASHVERSION);
    
    [self handlePostTo:@"/record" with:^{
        return [[LPRecordRoute new] autorelease];
    }];
    
    [self handlePostTo:@"/play" with:^{
        return [[LPAsyncPlaybackRoute new] autorelease];
    }];
    
    [self handlePostTo:@"/keyboard" with:^{
        return [[LPKeyboardRoute new] autorelease];
    }];

    
    [self handlePostTo:@"/condition" with:^{
        return [[LPConditionRoute new] autorelease];
    }];
    
    [self handleGetOrPostTo:@"/userprefs" with:^{
        return [[LPUserPrefCommand new] autorelease];
    }];

    [self handleGetOrPostTo:@"/appproperty" with:^{
        return [[LPAppPropertyCommand new] autorelease];
    }];

    [self handlePostTo:@"/calabash/map" with:^{
        return [[LPMapRoute new] autorelease];
    }];
    [self handleGetTo:@"/calabash/version" with:^{
        return [[LPVersionCommand new] autorelease];
    }];

}

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:@"UIApplicationDidBecomeActiveNotification"
                                               object:nil];
    dlopen([@"/Developer/Library/PrivateFrameworks/UIAutomation.framework/UIAutomation" fileSystemRepresentation], RTLD_LOCAL);
}

+ (void) handlePostTo:(NSString*)path with:(HandlerCreator)handlerCreator{
    
    [[RequestRouter singleton] registerRouteForPath:path
                                  supportingMethods:@[@"POST"]
                                          createdBy:handlerCreator];
}

+ (void) handleGetTo:(NSString*)path with:(HandlerCreator)handlerCreator{
    
    [[RequestRouter singleton] registerRouteForPath:path
                                  supportingMethods:@[@"GET"]
                                          createdBy:handlerCreator];
}

+ (void) handleGetOrPostTo:(NSString*)path with:(HandlerCreator)handlerCreator{
    
    [[RequestRouter singleton] registerRouteForPath:path
                                  supportingMethods:@[@"GET",@"POST"]
                                          createdBy:handlerCreator];
}


@end
