//
//  APAsyncDictionarySpec.mm
//  APAsyncDictionarySpec
//
//  Created by Alexey Belkevich on 1/16/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "CedarAsync.h"
#import "APAsyncDictionary.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(APAsyncDictionarySpec)

describe(@"APAsyncDictionary", ^
{
    __block APAsyncDictionary *dictionary;

    beforeEach((id)^
    {
        dictionary = [[APAsyncDictionary alloc] init];
    });

    it(@"should run callback block on callers thread", ^
    {
        __block BOOL result;
        NSThread *thread = NSThread.currentThread;
        [dictionary objectForKey:@"key" callback:^(id <NSCopying> key, id object)
        {
            result = [thread isEqual:NSThread.currentThread];
        }];
        in_time(result) should equal(YES);
    });

    it(@"should return nil if no object for key", ^
    {
        __block id notNilObject = [[NSObject alloc] init];
        [dictionary objectForKey:@"key" callback:^(id <NSCopying> key, id object)
        {
            notNilObject = object;
        }];
        in_time(notNilObject) should be_nil;
    });

    it(@"should set object for key", ^
    {
        __block NSObject *checkObject;
        NSObject *someObject = [[NSObject alloc] init];
        [dictionary setObject:someObject forKey:@"someKey"];
        [dictionary objectForKey:@"someKey" callback:^(id <NSCopying> key, id object)
        {
            checkObject = object;
        }];
        in_time(checkObject) should equal(someObject);
    });

    it(@"should set object and keys from NSDictionary", ^
    {
        __block NSObject *checkObject1, *checkObject2;
        NSObject *someObject = [[NSObject alloc] init];
        NSObject *anotherObject = [[NSObject alloc] init];
        [dictionary setObjectsAndKeysFromDictionary:@{@"someObject" : someObject,
                                                      @"anotherObject" : anotherObject}];
        [dictionary objectForKey:@"someObject" callback:^(id <NSCopying> key, id object)
        {
            checkObject1 = object;
        }];
        [dictionary objectForKey:@"anotherObject" callback:^(id <NSCopying> key, id object)
        {
            checkObject2 = object;
        }];
        in_time(checkObject1) should equal(someObject);
        in_time(checkObject2) should equal(anotherObject);
    });

    it(@"should remove object for key", ^
    {
        __block NSObject *checkObject1 = [[NSObject alloc] init];
        __block NSObject *checkObject2 = [[NSObject alloc] init];
        NSObject *someObject = [[NSObject alloc] init];
        NSObject *anotherObject = [[NSObject alloc] init];
        [dictionary setObjectsAndKeysFromDictionary:@{@"someObject" : someObject,
                                                      @"anotherObject" : anotherObject}];
        [dictionary removeObjectForKey:@"someObject"];
        [dictionary objectForKey:@"someKey" callback:^(id <NSCopying> key, id object)
        {
            checkObject1 = object;
        }];
        [dictionary objectForKey:@"anotherObject" callback:^(id <NSCopying> key, id object)
        {
            checkObject2 = object;
        }];
        in_time(checkObject1) should be_nil;
        in_time(checkObject2) should equal(anotherObject);
    });

    it(@"should remove object for keys array", ^
    {
        __block NSObject *checkObject1 = [[NSObject alloc] init];
        __block NSObject *checkObject2 = [[NSObject alloc] init];
        NSObject *someObject = [[NSObject alloc] init];
        NSObject *anotherObject = [[NSObject alloc] init];
        [dictionary setObjectsAndKeysFromDictionary:@{@"someObject" : someObject,
                                                      @"anotherObject" : anotherObject}];
        [dictionary removeObjectsForKeys:@[@"someObject", @"anotherObject"]];
        [dictionary objectForKey:@"someKey" callback:^(id <NSCopying> key, id object)
        {
            checkObject1 = object;
        }];
        [dictionary objectForKey:@"anotherObject" callback:^(id <NSCopying> key, id object)
        {
            checkObject2 = object;
        }];
        in_time(checkObject1) should be_nil;
        in_time(checkObject2) should be_nil;
    });

    it(@"should remove all object", ^
    {
        __block NSObject *checkObject1 = [[NSObject alloc] init];
        __block NSObject *checkObject2 = [[NSObject alloc] init];
        NSObject *someObject = [[NSObject alloc] init];
        NSObject *anotherObject = [[NSObject alloc] init];
        [dictionary setObjectsAndKeysFromDictionary:@{@"someObject" : someObject,
                                                      @"anotherObject" : anotherObject}];
        [dictionary removeAllObjects];
        [dictionary objectForKey:@"someKey" callback:^(id <NSCopying> key, id object)
        {
            checkObject1 = object;
        }];
        [dictionary objectForKey:@"anotherObject" callback:^(id <NSCopying> key, id object)
        {
            checkObject2 = object;
        }];
        in_time(checkObject1) should be_nil;
        in_time(checkObject2) should be_nil;
    });
});

SPEC_END
