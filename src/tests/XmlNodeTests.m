//
//  XmlNodeTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GHUnit.h"
#import "XmlNode.h"
#import "XmlAttribute.h"
#import "XmlNamespace.h"
#import "XmlDocument.h"
#import "dXml.h"

const NSString * WEB_SERVICE_XML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
											  @"<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""
											  @" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
											  @"<soap:body>"
											  @"<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
											  @"<symbol>MOT</symbol>"
											  @"</m:GetLastTradePrice>"
											  @"</soap:body>"
											  @"</soap:envelope>";
const NSString *PRETTY_WEB_SERVICE_XML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
													  @"\n<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
													  @"\n\t<soap:body>"
													  @"\n\t\t<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
													  @"\n\t\t\t<symbol>MOT</symbol>"
													  @"\n\t\t</m:GetLastTradePrice>"
													  @"\n\t</soap:body>"
													  @"\n</soap:envelope>";

@interface XmlNodeTests : GHTestCase {
	@private
}
@end

@implementation XmlNodeTests

- (void) testInitWithName {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
}

- (void) testInitWithNameAndNamespacePrefix {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"name not stored.");
	GHAssertEqualStrings(testElement.prefix, @"x", @"prefix not stored.");
}

- (void) testCreateWithName {
	XmlNode * testElement = [XmlNode createWithName: @"abc"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
}

- (void) testCreateWithNameAndPrefix {
	XmlNode * testElement = [XmlNode createWithName: @"abc" prefix:@"def"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
	GHAssertEqualStrings(testElement.prefix, @"def", @"PRefix not set");
}

- (void) testCreateWithNameAndValue {
	XmlNode * testElement = [XmlNode createWithName: @"abc" value:@"ghi"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
	GHAssertEqualStrings(testElement.value, @"ghi", @"Value not set");
}

- (void) testCreateWithNamePrefixAndValue {
	XmlNode * testElement = [XmlNode createWithName: @"abc" prefix:@"def" value:@"ghi"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
	GHAssertEqualStrings(testElement.prefix, @"def", @"PRefix not set");
	GHAssertEqualStrings(testElement.value, @"ghi", @"Value not set");
}

- (void) testIsEqualToName {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertTrue([testElement isEqualToName: @"abc"], @"Should have matched name.");
	GHAssertFalse([testElement isEqualToName: @"ABC"], @"Should not have matched name.");
}

- (void) testSubNodesAppendedAndRetrievedByKey {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	XmlNode *subElement1 = [[[XmlNode alloc] initWithName: @"def"] autorelease];
	XmlNode *subElement2 = [[[XmlNode alloc] initWithName: @"ghi"] autorelease];
	[testElement addNode: subElement1];
	[testElement addNode: subElement2];

	GHAssertEqualObjects([testElement xmlNodeWithName: @"def"], subElement1, @"SubElement1 not retrieved.");
	GHAssertEqualObjects([testElement xmlNodeWithName: @"ghi"], subElement2, @"SubElement2 not retrieved.");
}

- (void) testSubNodesRetrievedByIndex {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	XmlNode *subElement1 = [[[XmlNode alloc] initWithName: @"def"] autorelease];
	XmlNode *subElement2 = [[[XmlNode alloc] initWithName: @"ghi"] autorelease];
	[testElement addNode: subElement1];
	[testElement addNode: subElement2];

	GHAssertEqualObjects([testElement nodeAtIndex: 0], subElement1, @"SubElement1 not retrieved.");
	GHAssertEqualObjects([testElement nodeAtIndex: 1], subElement2, @"SubElement2 not retrieved.");
}

-(void) testSettingValueRemovesOldNodes {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName:@"abc"];
	[testElement setValue: @"Value"];
	GHAssertEqualStrings(testElement.value, @"Value", @"Returned xml not what was expected.");
	GHAssertFalse([testElement hasXmlNodeWithName:@"abc"], @"Nodes not cleared out.");

}

- (void) testValueAdded {
	XmlNode * testElement = [[XmlNode alloc] initWithName: @"abc"];
	[testElement setValue: @"Value"];
	GHAssertEqualStrings(testElement.value, @"Value", @"Returned xml not what was expected.");
}

- (void) testAttributeAddedToElement {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement setAttribute: @"def" value: @"ghi"];
	GHAssertEqualStrings([testElement attributeValue: @"def"], @"ghi", @"Attribute not added.");
}

- (void) testMultipleAttributesAddedToElement {
	XmlNode * testElement = [[XmlNode alloc] initWithName: @"abc"];
	[testElement setAttribute: @"def" value: @"ghi"];
	[testElement setAttribute: @"ijk" value: @"lmn"];
	GHAssertEqualStrings([testElement attributeValue: @"def"], @"ghi", @"Attribute def not added.");
	GHAssertEqualStrings([testElement attributeValue: @"ijk"], @"lmn", @"Attribute ijk not added.");
}

- (void) testAttributeEnumeration {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement setAttribute: @"def" value: @"ghi"];
	[testElement setAttribute: @"ijk" value: @"lmn"];
	int count = 0;
	for (XmlAttribute *attribute in[testElement attributes]) {
		DHC_LOG(@"Found attribute %@, value %@", attribute.name, attribute.value);
		if ( ([@"def" isEqualToString: attribute.name] &&[@"ghi" isEqualToString: attribute.value])
			  || ([@"ijk" isEqualToString: attribute.name] &&[@"lmn" isEqualToString: attribute.value])
			  ) {
			count++;
		}
	}
	GHAssertEquals(count, 2, @"2 Attributes not found.");
}

- (void) testAddNode {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	XmlNode *subElement = [[[XmlNode alloc] initWithName:  @"def"] autorelease];
	[testElement addNode: subElement];

	//Test and validate.
	XmlNode *returnedElement = [testElement xmlNodeWithName: @"def"];
	GHAssertNotNil(returnedElement, @"Expected an element to be returned.");
	GHAssertEqualObjects(returnedElement, subElement, @"Expected the sub element instance back");
}

- (void) testAddNodeByNameAndValue {
	XmlNode * testElement = [[[XmlNode alloc] initWithName:  @"abc"] autorelease];
	XmlNode *subElement = [testElement addXmlNodeWithName: @"def" value: @"ghi"];
	GHAssertNotNil(subElement, @"New sub element not returned.");
	GHAssertEqualStrings([subElement name], @"def", @"Sub element name incorrect.");
	GHAssertEqualStrings([subElement value], @"ghi", @"Sub element value incorrect.");
}

- (void) testAddingNamespace {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addNamespace: @"namespace" prefix: @"prefix"];
	for (XmlNamespace *namespace in[testElement namespaces]) {
		if ([@"prefix" isEqualToString: namespace.prefix] &&[@"namespace" isEqualToString: namespace.url]) {
			//Found namespace;
			return;
		}
	}
	GHFail(@"Namespace not found.");
}

- (void) testHasSubElementSuccess {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"def"];
	GHAssertTrue([testElement hasXmlNodeWithName: @"def"], @"hasSubElement failed to find element.");
}

- (void) testHasSubElementFail {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"def"];
	GHAssertFalse([testElement hasXmlNodeWithName: @"ghi"], @"hasSubElement failed to find element.");
}

- (void) testSubElements {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"def" value: @"012"];
	[testElement addXmlNodeWithName: @"def" value: @"345"];
	[testElement addXmlNodeWithName: @"def" value: @"678"];

	BOOL found[3] = {
		false, false, false
	};

	int counter = 0;
	for (XmlNode *element in[testElement nodes]) {
		counter++;
		DHC_LOG(@"Checking result element %@", element.name);
		if ([element.value isEqualToString:  @"012"]) found[0] = true;
		if ([element.value isEqualToString: @"345"]) found[1] = true;
		if ([element.value isEqualToString:  @"678"]) found[2] = true;
	}

	GHAssertEquals(counter, 3, @"Not 3 elements in list");
	for (int i = 0; i < 3; i++) {
		if (!found[i]) {
			GHFail(@"Sub element not found %i", i);
		}
	}
}

- (void) testSubElementsWithName {
	XmlNode * testElement = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"ghi" value: @"0"];
	[testElement addXmlNodeWithName: @"def" value: @"1"];
	[testElement addXmlNodeWithName: @"def" value: @"2"];
	[testElement addXmlNodeWithName: @"gHi" value: @"3"];
	[testElement addXmlNodeWithName: @"def" value: @"4"];
	[testElement addXmlNodeWithName: @"DEF" value: @"5"];

	BOOL found[3] = {
		false, false, false
	};
	int counter = 0;

	for (XmlNode *element in[testElement xmlNodesWithName : @"def"]) {
		counter++;
		DHC_LOG(@"Checking result element %@ value %@", element.name, element.value);
		if ([element.value isEqualToString: @"1"]) found[0] = true;
		if ([element.value isEqualToString:  @"2"]) found[1] = true;
		if ([element.value isEqualToString:  @"4"]) found[2] = true;
	}

	GHAssertEquals(counter, 3, @"Not 3 elements in list");
	for (int i = 0; i < 3; i++) {
		if (!found[i]) {
			GHFail(@"Sub element not found %i", i);
		}
	}
}

// Printing tests.

- (void) testAsXmlString {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertEqualStrings([element asXmlString], @"<abc />", @"Formatting failed.");
}

- (void) testAsXmlStringWithAttributes {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[element setAttribute: @"nillable" value: @"true"];
	GHAssertEqualStrings([element asXmlString], @"<abc nillable=\"true\" />", @"Formatting failed.");
}

- (void) testAsXmlStringWithPrefix {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	GHAssertNotNil([element asXmlString], @"Nil value returned when xml expected.");
	GHAssertEqualStrings([element asXmlString], @"<x:abc />", @"Formatting Failed.");
}

- (void) testAsXmlStringWithValue {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	element.value = @"def";
	GHAssertEqualStrings([element asXmlString], @"<abc>def</abc>", @"Formatting failed.");
}

- (void) testAsXmlStringWithSubElements {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[element addXmlNodeWithName: @"def" value: @"ghi"];
	[element addXmlNodeWithName: @"ijk" value: @"mno"];
	GHAssertEqualStrings([element asXmlString], @"<abc><def>ghi</def><ijk>mno</ijk></abc>", @"Formatting failed.");
}

- (void) testAsXmlStringDocumentWithNodesAndRootSchema {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	element.defaultSchema = @"rootschema";
	GHAssertEqualStrings([element asXmlString], @"<abc xmlns=\"rootschema\" />", @"Formatting failed.");
}

- (void) testAsXmlStringWithNamespace {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	[element addNamespace: @"url" prefix: @"x"];
	GHAssertEqualStrings([element asXmlString], @"<x:abc xmlns:x=\"url\" />", @"Formatting failed.");
}

- (void) testAsXmlStringSoapWebServiceCall {
	XmlDocument *document = [[[XmlDocument alloc] initWithName: @"envelope" prefix: @"soap"] autorelease];
	[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
	[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
	XmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
	XmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
	[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
	[getLastTradePriceElement addXmlNodeWithName: @"symbol" value: @"MOT"];

	NSString *resultXml = [document asXmlString];
	DHC_LOG(@"Expected: %@", WEB_SERVICE_XML);
	DHC_LOG(@"Got     : %@", resultXml);
	GHAssertEqualStrings(resultXml, WEB_SERVICE_XML, @"Formatting failed.");
}

- (void) testAsXmlStringMixedNodes {
	XmlNode *root = [[[XmlNode alloc] initWithName: @"root"] autorelease];
	[root addTextNodeWithValue: @"abc"];
	[root addXmlNodeWithName: @"element1" value:@"def"];
	[root addXmlNodeWithName: @"element2" value:@"ghi"];
	[root addTextNodeWithValue: @"lmn"];
	GHAssertEqualStrings([root asXmlString], @"<root>abc<element1>def</element1><element2>ghi</element2>lmn</root>", @"Xml not returned correctly.");
}


// Pretty printing tests.

- (void) testAsPrettyXmlString {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithAttributes {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[element setAttribute: @"nillable" value: @"true"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc nillable=\"true\" />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithPrefix {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	GHAssertNotNil([element asXmlString], @"Nil value returned when xml expected.");
	GHAssertEqualStrings([element asPrettyXmlString], @"<x:abc />", @"Formatting Failed.");
}

- (void) testAsPrettyXmlStringWithValue {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	element.value = @"def";
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc>def</abc>", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithSubElements {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc"] autorelease];
	[element addXmlNodeWithName: @"def" value: @"ghi"];
	[element addXmlNodeWithName: @"ijk" value: @"mno"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc>\n\t<def>ghi</def>\n\t<ijk>mno</ijk>\n</abc>", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithNamespace {
	XmlNode *element = [[[XmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	[element addNamespace: @"url" prefix: @"x"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<x:abc xmlns:x=\"url\" />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringSoapWebServiceCall {
	XmlDocument *document = [[[XmlDocument alloc] initWithName: @"envelope" prefix: @"soap"] autorelease];
	[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
	[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
	XmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
	XmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
	[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
	[getLastTradePriceElement addXmlNodeWithName: @"symbol" value: @"MOT"];

	NSString *resultXml = [document asPrettyXmlString];
	DHC_LOG(@"Expected: %@", PRETTY_WEB_SERVICE_XML);
	DHC_LOG(@"Got     : %@", resultXml);
	GHAssertEqualStrings(resultXml, PRETTY_WEB_SERVICE_XML, @"Formatting failed.");
}


@end