//
//  MapRoute.m
//  Created by Karl Krukow on 13/08/11.
//  Copyright 2011 LessPainful. All rights reserved.
//

#import "LPMapRoute.h"
#import "UIScriptParser.h"
#import "LPOperation.h"
#import "LPTouchUtils.h"

#import "HttpRequestContext.h"
#import "HTTPDataResponse.h"


@implementation LPMapRoute
@synthesize parser;

- (NSArray*) applyOperation:(NSDictionary *)operation toViews:(NSArray *) views error:(NSError **)error {
    if ([operation valueForKey:@"method_name"] == nil) {
        return [[views copy] autorelease];
    }
    LPOperation *op = [LPOperation operationFromDictionary:operation];
    //LPHTTPLogDDLogVerbose(@"Applying operation %@ to views...",op);
    NSMutableArray* finalRes = [NSMutableArray arrayWithCapacity:[views count]];
    if (views == nil) {
        id res = [op performWithTarget:nil error:error];
        if (res != nil) {
            [finalRes addObject:res];
        }
    } else {
        for (id view in views) {
//            if ([view isKindOfClass:[UIView class]] && ![LPTouchUtils isViewVisible:view]) {continue;}            
            NSError *err = nil;
            id val = [op performWithTarget:view error:&err];
            if (err) {continue;}
            if (val == nil) {
                [finalRes addObject: [NSNull null]];
            } else {
                [finalRes addObject: val];
            }            
        }
    }
    return finalRes;
}

-(NSObject<HTTPResponse> *) handleRequest:(HTTPRequestContext *)context{

//- (NSDictionary *)JSONResponseForMethod:(NSString *)method URI:(NSString *)path data:(NSDictionary*)data {
    NSDictionary *data = [context bodyAsJsonDict];
    
    id scriptObj = [data objectForKey:@"query"];
    NSDictionary* operation = [data objectForKey:@"operation"];
    //DDLogVerbose(@"MapRoute received command\n%@", data);
    NSArray* result = nil;
    if ([NSNull null] != scriptObj) {
        
        self.parser = [UIScriptParser scriptParserWithObject:scriptObj];
        [self.parser parse];
        NSArray* tokens = [self.parser parsedTokens];
        NSLog(@"Parsed UIScript as\n%@", tokens);
        
        NSMutableArray* views = [NSMutableArray arrayWithCapacity:32];
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) 
        {
            [views addObjectsFromArray:[window subviews]];
            //        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            //            break;
            //        }
        }
        result = [self.parser evalWith:views];
        //DDLogVerbose(@"Evaled UIScript as\n%@", result);        
    } else {
        //DDLogInfo(@"Received null query.");
        result = nil;
    }
    
    NSError* error = nil;
    NSArray* resultArray = [self applyOperation:operation toViews:result error:&error];
    
    if (resultArray) {
        return [context successResponseWithResults:resultArray];
    } else {
        return [context errorResponseWithReason:@"" andDetails:@""];
    } 
}

-(void)dealloc
{
    self.parser = nil;
    [super dealloc];
}

@end
