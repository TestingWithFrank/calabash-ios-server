//
//  LPJSONUtils.m
//  Created by Karl Krukow on 11/08/11.
//  Copyright 2011 LessPainful. All rights reserved.
//

#import "LPJSONUtils.h"
#import "LPCJSONSerializer.h"
#import "LPCJSONDeserializer.h"

@implementation LPJSONUtils

+ (NSString*) serializeDictionary:(NSDictionary*) dictionary {
    LPCJSONSerializer* s = [LPCJSONSerializer serializer];
    NSError* error = nil;
    NSData* d = [s serializeDictionary:dictionary error:&error];
    if (error) {
        NSLog(@"Unable to serialize dictionary (%@), %@",error,dictionary);
    }
    NSString* res = [[NSString alloc]  initWithBytes:[d bytes]
                              length:[d length] encoding: NSUTF8StringEncoding];
    return [res autorelease];
}
+ (NSDictionary*) deserializeDictionary:(NSString*) string {
    LPCJSONDeserializer* ds = [LPCJSONDeserializer deserializer];
    NSError* error = nil;
    NSDictionary* res = [ds deserializeAsDictionary:[string dataUsingEncoding:NSUTF8StringEncoding]error:&error];
    if (error) {
        NSLog(@"Unable to deserialize  %@",string);
    }
    return res;
}

+ (NSString*) serializeArray:(NSArray*) array {
    LPCJSONSerializer* s = [LPCJSONSerializer serializer];
    NSError* error = nil;
    NSData* d = [s serializeArray:array error:&error];
    if (error) {
        NSLog(@"Unable to serialize arrayy (%@), %@",error,array);
    }
    NSString* res = [[NSString alloc]  initWithBytes:[d bytes]
                                              length:[d length] encoding: NSUTF8StringEncoding];
    return [res autorelease];
}
+ (NSArray*) deserializeArray:(NSString*) string {
    LPCJSONDeserializer* ds = [LPCJSONDeserializer deserializer];
    NSError* error = nil;
    NSArray* res = [ds deserializeAsArray:[string dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    if (error) {
        NSLog(@"Unable to deserialize  %@",string);
    }
    return res;
}

+(NSString *)serializeObject:(id)obj
{
    LPCJSONSerializer* s = [LPCJSONSerializer serializer];
    NSError* error = nil;
    NSData* d = [s serializeObject:obj error:&error];
    if (error) {
        NSLog(@"Unable to serialize object (%@), %@",error,[obj description]);
    }
    NSString* res = [[NSString alloc]  initWithBytes:[d bytes]
                                              length:[d length] encoding: NSUTF8StringEncoding];
    return [res autorelease];

}

+(id)jsonifyObject:(id)object
{
        if (!object) {return nil;}
        if ([object isKindOfClass:[UIColor class]]) 
        {
            //todo special handling
            return [object description];        
        }
        if ([object isKindOfClass:[UIView class]])
        {
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           NSStringFromClass([object class]),@"class",
                                           
                                           nil];
            

            NSString *lbl = [object accessibilityLabel];
            if (lbl)
            {
                [result setObject:lbl forKey:@"label"];
            }
            else
            {
                [result setObject:[NSNull null] forKey:@"label"];                
            }

            if ([result respondsToSelector:@selector(accessibilityIdentifier)]) {

                NSString *aid = [object accessibilityIdentifier];
                if (aid)
                {
                    [result setObject:aid forKey:@"id"];
                }
                else
                {
                    [result setObject:[NSNull null] forKey:@"id"];
                }

            }
            
            CGRect frame = [object frame];
            NSDictionary *frameDic =  
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithFloat:frame.origin.x],@"x",
             [NSNumber numberWithFloat:frame.origin.y],@"y",
             [NSNumber numberWithFloat:frame.size.width],@"width",
             [NSNumber numberWithFloat:frame.size.height],@"height",
             nil];
            
            [result setObject:frameDic forKey:@"frame"];
            
            [result setObject:[object description] forKey:@"description"];
            
            return result;
        }
        
        LPCJSONSerializer* s = [LPCJSONSerializer serializer];
        NSError* error = nil;
        if (![s serializeObject:object error:&error] || error) 
        {
            return [object description];
        }    
        return object;
        

}
@end
