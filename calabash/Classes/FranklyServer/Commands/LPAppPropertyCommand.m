//
//  LPAppPropertyCommand.m
//  calabash
//
//  Created by Pete Hodgson on 7/5/13.
//  Copyright (c) 2013 LessPainful. All rights reserved.
//

#import "LPAppPropertyCommand.h"
#import "HTTPRequestContext.h"
#import "HTTPDataResponse.h"

@implementation LPAppPropertyCommand

-(NSObject<HTTPResponse> *) handleRequest:(HTTPRequestContext *)context{
    
    if( [context isMethod:@"GET"] ){
        return [self handleGet:context];
    }else{
        return [self handlePost:context];
    }
}

- (NSObject<HTTPResponse> *)handlePost:(HTTPRequestContext *)context{
    NSDictionary *data = context.bodyAsJsonDict;
    NSObject <UIApplicationDelegate> *delegate = [UIApplication sharedApplication].delegate;
    
    NSString *key = [data valueForKey:@"key"];
    
	@try {
		id curVal = [delegate valueForKeyPath:key];
        if( !curVal )
            curVal = [NSNull null];

        id val = [data valueForKey:@"value"];
		id kval = val;
        if ([val isKindOfClass:[NSNull class]])
        {
            kval = nil;
        }
        NSError *kerror;
        if (!([delegate validateValue:&kval forKeyPath:key error:&kerror]))
        {
            return [context errorResponseWithReason:@"value is invalid" andDetails:[kerror description]];
        }
        [delegate setValue:kval forKeyPath:key];
        
        return [context successResponseWithResults:@[val,curVal]];        
	}
	@catch (NSException *exception) {
        return [context errorResponseWithReason:[exception reason] andDetails:@""];
	}
}

- (NSObject<HTTPResponse> *)handleGet:(HTTPRequestContext *)context{
    NSDictionary *data = context.queryParams;
    NSObject <UIApplicationDelegate> *delegate = [UIApplication sharedApplication].delegate;
    
    NSString *key = [data valueForKey:@"key"];
    id curVal = [delegate valueForKeyPath:key];
    if( !curVal )
        curVal = [NSNull null];

    return [context successResponseWithResults:@[curVal]];
}


@end
