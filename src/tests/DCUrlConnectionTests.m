//
//  UrlConnectionTests.m
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCUrlConnection.h"
#import "dXml.h"

@interface DCUrlConnectionTests : GHTestCase
{
}
@end

@implementation DCUrlConnectionTests

- (void) testInitWithUrl {
	DCUrlConnection *connection = [[[DCUrlConnection alloc] initWithUrl: @"abc"] autorelease];
	GHAssertNotNil(connection, @"Constructor returned nil object");
}

- (void) testCreateWithUrl {
	DCUrlConnection *connection = [DCUrlConnection createWithUrl: @"abc"];
	GHAssertNotNil(connection, @"Create returned nil object");
}

- (void) testInvalidURI {
	DCUrlConnection *connection = [DCUrlConnection createWithUrl: @"http://localhost/xxxx"];
	GHAssertNotNil(connection, @"Create returned nil object");
	NSError *error = nil;
	NSData *data = [connection post: @"" errorVar:&error];
	GHAssertNil(data, @"Data was returned");
	GHAssertEquals(error.code, -1004, @"Error code not correct");
	GHAssertEqualStrings(error.domain, @"NSURLErrorDomain", @"Error code not correct");
}

@end