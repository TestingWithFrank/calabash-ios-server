//
//  LPVersionRoute.h
//  calabash
//
//  Created by Karl Krukow on 22/06/12.
//  Copyright (c) 2012 LessPainful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestRouter.h"
static const NSString *kLPCALABASHVERSION = @"0.10.0";

@interface LPVersionCommand : NSObject<HTTPRequestHandler>

@end
