//
//  WebServiceResponseTests.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceResponse.h"
#import "XmlDocument.h"
#import "GHUnit.h"

@interface WebServiceResponseTests : GHTestCase {
}
- (XmlDocument *) soapResponseGraph;

@end

@implementation WebServiceResponseTests

- (void) testResponseIsStoredAndReturned {
	XmlDocument *doc = [[[XmlDocument alloc] initWithName: @"Envelope"] autorelease];
	WebServiceResponse *response = [[[WebServiceResponse alloc] initWithDocument: doc] autorelease];
	GHAssertEqualObjects(response.document, doc, @"Expected object not returned.");
}

- (void) testBodyElement {
	XmlDocument * doc = [self soapResponseGraph];
	XmlNode * body = [doc xmlNodeWithName:@"Body"];
	WebServiceResponse *response = [[[WebServiceResponse alloc] initWithDocument:doc] autorelease];
	GHAssertEqualObjects([response bodyElement], body, @"Expected body object not returned.");
}

- (void) testBodyContent {
	XmlDocument * doc = [self soapResponseGraph];
	XmlNode * tradePriceResponse = [[doc xmlNodeWithName:@"Body"]xmlNodeWithName:@"GetLastTradePriceResponse"];
	WebServiceResponse *response = [[[WebServiceResponse alloc] initWithDocument:doc] autorelease];
	GHAssertEqualObjects([response bodyContent], tradePriceResponse, @"Expected body object not returned.");
}

- (void) testBodyContents {
	XmlDocument * doc = [self soapResponseGraph];
	XmlNode * tradePriceResponse = [[doc xmlNodeWithName:@"Body"]xmlNodeWithName:@"GetLastTradePriceResponse"];
	WebServiceResponse *response = [[[WebServiceResponse alloc] initWithDocument:doc] autorelease];
	NSEnumerator * enumerator = [response bodyContents];
	GHAssertEqualObjects([enumerator nextObject], tradePriceResponse, @"Expected body object not returned.");
	GHAssertNil([enumerator nextObject], @"Expected just the one object.");
}

- (XmlDocument *) soapResponseGraph {
	XmlDocument *document = [[[XmlNode alloc] initWithName: @"Envelope" prefix: @"soap"] autorelease];
	[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
	[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
	XmlNode *bodyElement = [document addXmlNodeWithName: @"Body" prefix: @"soap"];
	XmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePriceResponse" prefix: @"m"];
	[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
	[getLastTradePriceElement addXmlNodeWithName: @"Price" value: @"14.5"];

	return document;
}

@end