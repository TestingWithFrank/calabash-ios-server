//
//  MapRoute.h
//  Created by Karl Krukow on 13/08/11.
//  Copyright 2011 LessPainful. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoutingEntry.h"

@class UIScriptParser;

@interface LPMapRoute : NSObject<HTTPRequestHandler>

@property (nonatomic, retain) UIScriptParser *parser;
@end
