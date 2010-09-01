//
//  DCXmlNodeTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <GHUnitIOS/GHUnitIOS.h>
#import "DCXmlNode+AsString.h"
#import "DCXmlAttribute.h"
#import "DCXmlNamespace.h"
#import "DCXmlDocument.h"
#import "dXml.h"
#import "NSObject+SoapTemplates.h"
#import "TestHeaders.h"

@interface DCXmlNode_AsStringTests : GHTestCase {
@private
}
@end

@implementation DCXmlNode_AsStringTests

- (void) testAsXmlString {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	GHAssertEqualStrings([element asXmlString], @"<abc />", @"Formatting failed.");
}

- (void) testAsXmlStringWithAttributes {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	[element setAttribute:@"nillable" value:@"true"];
	GHAssertEqualStrings([element asXmlString], @"<abc nillable=\"true\" />", @"Formatting failed.");
}

- (void) testAsXmlStringWithPrefix {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc" prefix:@"x"] autorelease];
	
	GHAssertNotNil([element asXmlString], @"Nil value returned when xml expected.");
	GHAssertEqualStrings([element asXmlString], @"<x:abc />", @"Formatting Failed.");
}

- (void) testAsXmlStringWithValue {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	element.value = @"def";
	GHAssertEqualStrings([element asXmlString], @"<abc>def</abc>", @"Formatting failed.");
}

- (void) testAsXmlStringWithSubElements {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	[element addXmlNodeWithName:@"def" value:@"ghi"];
	[element addXmlNodeWithName:@"ijk" value:@"mno"];
	GHAssertEqualStrings([element asXmlString], @"<abc><def>ghi</def><ijk>mno</ijk></abc>", @"Formatting failed.");
}

- (void) testAsXmlStringDocumentWithNodesAndRootSchema {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	element.defaultSchema = @"rootschema";
	GHAssertEqualStrings([element asXmlString], @"<abc xmlns=\"rootschema\" />", @"Formatting failed.");
}

- (void) testAsXmlStringWithNamespace {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc" prefix:@"x"] autorelease];
	
	[element addNamespace:@"url" prefix:@"x"];
	GHAssertEqualStrings([element asXmlString], @"<x:abc xmlns:x=\"url\" />", @"Formatting failed.");
}

- (void) testAsXmlStringSoapWebServiceCall {
	DCXmlDocument * document = [[[DCXmlDocument alloc] initWithName:@"envelope" prefix:@"soap"] autorelease];
	
	[document addNamespace:@"http://schemas.xmlsoap.org/soap/envelope/" prefix:@"soap"];
	[document setAttribute:@"soap:encodingStyle" value:@"http://schemas.xmlsoap.org/soap/encoding/"];
	DCXmlNode * bodyElement = [document addXmlNodeWithName:@"body" prefix:@"soap"];
	DCXmlNode * getLastTradePriceElement = [bodyElement addXmlNodeWithName:@"GetLastTradePrice" prefix:@"m"];
	[getLastTradePriceElement addNamespace:@"http://trading-site.com.au" prefix:@"m"];
	[getLastTradePriceElement addXmlNodeWithName:@"symbol" value:@"MOT"];
	
	NSString * resultXml = [document asXmlString];
	DHC_LOG(@"Expected: %@", WEB_SERVICE_XML);
	DHC_LOG(@"Got     : %@", resultXml);
	GHAssertEqualStrings(resultXml, WEB_SERVICE_XML, @"Formatting failed.");
}

- (void) testAsXmlStringMixedNodes {
	DCXmlNode * root = [[[DCXmlNode alloc] initWithName:@"root"] autorelease];
	
	[root addTextNodeWithValue:@"abc"];
	[root addXmlNodeWithName:@"element1" value:@"def"];
	[root addXmlNodeWithName:@"element2" value:@"ghi"];
	[root addTextNodeWithValue:@"lmn"];
	GHAssertEqualStrings([root asXmlString], @"<root>abc<element1>def</element1><element2>ghi</element2>lmn</root>", @"Xml not returned correctly.");
}

// Pretty printing tests.

- (void) testAsPrettyXmlString {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithAttributes {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	[element setAttribute:@"nillable" value:@"true"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc nillable=\"true\" />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithPrefix {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc" prefix:@"x"] autorelease];
	
	GHAssertNotNil([element asXmlString], @"Nil value returned when xml expected.");
	GHAssertEqualStrings([element asPrettyXmlString], @"<x:abc />", @"Formatting Failed.");
}

- (void) testAsPrettyXmlStringWithValue {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	element.value = @"def";
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc>def</abc>", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithSubElements {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc"] autorelease];
	
	[element addXmlNodeWithName:@"def" value:@"ghi"];
	[element addXmlNodeWithName:@"ijk" value:@"mno"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc>\n\t<def>ghi</def>\n\t<ijk>mno</ijk>\n</abc>", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithNamespace {
	DCXmlNode * element = [[[DCXmlNode alloc] initWithName:@"abc" prefix:@"x"] autorelease];
	
	[element addNamespace:@"url" prefix:@"x"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<x:abc xmlns:x=\"url\" />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringSoapWebServiceCall {
	DCXmlDocument * document = [[[DCXmlDocument alloc] initWithName:@"envelope" prefix:@"soap"] autorelease];
	
	[document addNamespace:@"http://schemas.xmlsoap.org/soap/envelope/" prefix:@"soap"];
	[document setAttribute:@"soap:encodingStyle" value:@"http://schemas.xmlsoap.org/soap/encoding/"];
	DCXmlNode * bodyElement = [document addXmlNodeWithName:@"body" prefix:@"soap"];
	DCXmlNode * getLastTradePriceElement = [bodyElement addXmlNodeWithName:@"GetLastTradePrice" prefix:@"m"];
	[getLastTradePriceElement addNamespace:@"http://trading-site.com.au" prefix:@"m"];
	[getLastTradePriceElement addXmlNodeWithName:@"symbol" value:@"MOT"];
	
	NSString * resultXml = [document asPrettyXmlString];
	DHC_LOG(@"Expected: %@", PRETTY_WEB_SERVICE_XML);
	DHC_LOG(@"Got     : %@", resultXml);
	GHAssertEqualStrings(resultXml, PRETTY_WEB_SERVICE_XML, @"Formatting failed.");
}


@end