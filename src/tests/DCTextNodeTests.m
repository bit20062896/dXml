//
//  DCTextNodeTests.m
//  dXml
//
//  Created by Derek Clarkson on 14/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCTextNode.h"

@interface DCTextNodeTests : GHTestCase
{
}

@end


@implementation DCTextNodeTests

-(void) testConstructor {
	
	DCTextNode * node = [[[DCTextNode alloc] initWithText:@"abc"]autorelease];
	GHAssertEqualStrings(node.value, @"abc", @"text not returned");
	
}

-(void) testAppendingText {
	
	DCTextNode * node = [[[DCTextNode alloc] initWithText:@"abc"]autorelease];
	NSMutableString * string = [[[NSMutableString alloc]init]autorelease];
	[node appendToXmlString:string prettyPrint:node indentDepth:0];
	GHAssertEqualStrings(string, @"abc", @"String not appended properly");
	
}

@end
