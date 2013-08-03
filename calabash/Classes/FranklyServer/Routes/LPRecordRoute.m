//
//  RecordRoute.m
//  Created by Karl Krukow on 15/08/11.
//  Copyright 2011 LessPainful. All rights reserved.
//

#import "LPRecordRoute.h"
#import "HTTPDataResponse.h"
#import "LPRecorder.h"
#import "LPNoContentResponse.h"
#import "HttpRequestContext.h"
#import "JSON.h"


@implementation LPRecordRoute

-(NSObject<HTTPResponse> *) handleRequest:(HTTPRequestContext *)context{
    NSDictionary *_params = FROM_JSON(context.bodyAsString);
    NSString* action = [_params objectForKey:@"action"];
    if ([action isEqualToString:@"start"]) {
        [self startRecording];
        return [[[LPNoContentResponse alloc] init] autorelease];
    }
    else if ([action isEqualToString:@"stop"]) {
        NSData* data = [self stopRecording];
        return [[[HTTPDataResponse alloc] initWithData:data] autorelease];
    } else {
        return nil;
    }
}

- (void) startRecording
{
    [[LPRecorder sharedRecorder] record];
}

- (NSData *) stopRecording
{
    [[LPRecorder sharedRecorder] stop];
    
    NSString *error=nil;
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:[[LPRecorder sharedRecorder] events]
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if (error) {
        NSLog(@"error getting plist data: %@",error);
        return nil;
    } else {
        return plistData;
    //
    }
}

@end
