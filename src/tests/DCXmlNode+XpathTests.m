//
//  DCXmlNode+XpathTests.m
//  dXml
//
//  Created by Derek Clarkson on 21/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import "GHUnit.h"
#import "DCXmlNode.h"
#import "DCXmlDocument.h"
#import "NSObject+SoapTemplates.h"
#import "DCXmlNode+XPath.h"

const NSString * testXml = @"";

@interface DCXmlNode_XpathTests : GHTestCase

@end

@implementation DCXmlNode_XpathTests

- (void) testXmlNodeFromXPathFindsNode {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"/Body";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Body", @"Incorrect node returned");
}

- (void) testValueFromXPathFindsValue {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"/Body";
	DCXmlNode * body = [doc xmlNodeWithName:@"Body"];

	body.value = @"abc";
	NSString * value = [doc valueFromXPath:xpath];
	GHAssertEqualStrings(value, @"abc", @"Value returned");
}

- (void) testXmlNodeFromXPathInvalidPath {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"/XBody";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertNil(node, @"Expected nil back");
}

- (void) testValueFromXPathWithInvalidPath {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"/XBody";

	[[doc xmlNodeWithName:@"Envelope"] xmlNodeWithName:@"Body"];
	NSString * value = [doc valueFromXPath:xpath];

	GHAssertNil(value, @"Expected nil");
}

- (void) testValueFromXPathWithNoValue {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"/Body";

	[[doc xmlNodeWithName:@"Envelope"] xmlNodeWithName:@"Body"];
	NSString * value = [doc valueFromXPath:xpath];

	GHAssertNil(value, @"Expected nil");
}

// XPath analysis tests.
- (void) testXPathSingleElement {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"Body";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Body", @"Incorrect node returned");
}

- (void) testXPathChildIndex {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"[1]";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Body", @"Incorrect node returned");
}

- (void) testXPathElementAndChildIndex {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	DCXmlNode * body = [doc xmlNodeWithName:@"Body"];

	[body addXmlNodeWithName:@"abc"];
	NSString * xpath = @"Body[0]";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"abc", @"Incorrect node returned");
}

- (void) testXPathParent {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	DCXmlNode * header = [doc xmlNodeWithName:@"Header"];
	NSString * xpath = @"..";
	DCXmlNode * node = [header xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Envelope", @"Incorrect node returned");
}
- (void) testXPathPath {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	DCXmlNode * body = [doc xmlNodeWithName:@"Body"];

	[body addXmlNodeWithName:@"abc"];
	NSString * xpath = @"/Body/abc";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"abc", @"Incorrect node returned");
}

- (void) testXPathLeadingSlash {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"/Body";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Body", @"Incorrect node returned");
}

- (void) testXPathRootNodeSpecified {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"//Envelope/Body";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Body", @"Incorrect node returned");
}

- (void) testXPathParentAndChild {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	DCXmlNode * header = [doc xmlNodeWithName:@"Header"];
	NSString * xpath = @"../Body";
	DCXmlNode * node = [header xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Body", @"Incorrect node returned");
}

- (void) testXPathIgnoreSelfRef {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"./";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Envelope", @"Incorrect node returned");
}

- (void) testXPathIgnoreSelfRefFindsChild {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"./Body";
	DCXmlNode * node = [doc xmlNodeFromXPath:xpath];

	GHAssertEqualStrings(node.name, @"Body", @"Incorrect node returned");
}

- (void) testXPathInvalidDoubleSlashAfterSelf {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @".//Body";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"InvalidXpathException", @"Exception not thrown");
}
- (void) testXPathInvalidDoubleSlashAfterParent {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	DCXmlNode * header = [doc xmlNodeWithName:@"Header"];
	NSString * xpath = @"..//Body";

	GHAssertThrowsSpecificNamed([header xmlNodeFromXPath:xpath], NSException, @"InvalidXpathException", @"Exception not thrown");
}

- (void) testXPathNoScanException {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @":";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"UnknownTokenInXpathException", @"Exception not thrown");
}

- (void) testXPathAfterTextNodeException {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	DCXmlNode * body = [doc xmlNodeWithName:@"Body"];

	[body addTextNodeWithValue:@"abc"];
	NSString * xpath = @"Body[0]/invalidNode";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"TextNodeInPathException", @"Exception not thrown");
}

- (void) testXPathIncompleteException {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"//";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"IncompleteXpathException", @"Exception not thrown");
}

- (void) testXPathRootNodeNameNotSpecifiedException {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"///";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"InvalidXpathException", @"Exception not thrown");
}

- (void) testXPathNoArrayIndexException {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"[/";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"InvalidXpathException", @"Exception not thrown");
}

- (void) testXPathNoArrayIndex2Exception {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"[]";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"InvalidXpathException", @"Exception not thrown");
}

- (void) testXPathNoEndBracketException {
	DCXmlDocument * doc = [NSObject createBasicSoapDM];
	NSString * xpath = @"[1/abc";

	GHAssertThrowsSpecificNamed([doc xmlNodeFromXPath:xpath], NSException, @"InvalidXpathException", @"Exception not thrown");
}


@end
