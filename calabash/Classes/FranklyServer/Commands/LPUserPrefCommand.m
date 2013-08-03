//
//  LPUserPrefRoute.m
//  calabash
//
//  Created by Karl Krukow on 02/02/12.
//  Copyright (c) 2012 LessPainful. All rights reserved.
//

#import "LPUserPrefCommand.h"
#import "LPJSONUtils.h"
#import "HTTPRequestContext.h"
#import "FranklyProtocolHelper.h"
#import "HTTPDataResponse.h"

@implementation LPUserPrefCommand

-(NSObject<HTTPResponse> *) handleRequest:(HTTPRequestContext *)context{
    
    if( [context isMethod:@"GET"] ){
        return [self handleGet:context];
    }else{
        return [self handlePost:context];
    }
}

-(NSObject<HTTPResponse> *) handleGet:(HTTPRequestContext *)context{    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud synchronize];
    
    NSString *key = [[context queryParams] valueForKey:@"key"];
    id curVal = [ud valueForKey:key];
    
    if( !curVal )
        curVal = [NSNull null];
    
    return [context successResponseWithResults: @[curVal]];
}

-(NSObject<HTTPResponse> *) handlePost:(HTTPRequestContext *)context{
    NSDictionary *data = context.bodyAsJsonDict;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud synchronize];
    
    NSString *key = [data valueForKey:@"key"];
    id curVal = [ud valueForKey:key];
    if( !curVal )
        curVal = [NSNull null];

    id newVal = [data valueForKey:@"value"];
    
    if ([newVal isKindOfClass:[NSNull class]])
    {
        [ud removeObjectForKey:key];
    }
    else
    {
        [ud setValue:newVal forKey:key];
    }
    [ud synchronize];
    
    
    return [context successResponseWithResults: @[newVal,curVal]];
}

@end
