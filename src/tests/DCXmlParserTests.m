//
//  XmlParserTests.m
//  dXml
//
//  Created by Derek Clarkson on 11/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlParser.h"
#import "GHUnit.h"
#import "DCXmlDocument.h"
#import "dXml.h"
#import "DCXmlNode+AsString.h"

@interface DCXmlParserTests:GHTestCase {
}
- (void) runXmlDocumentTest: (NSString *) expectedXml;
- (void) runXmlSubtreeTest: (NSString *) expectedXml;
@end

@implementation DCXmlParserTests

- (void) testDocumentMinimal {
	[self runXmlDocumentTest: @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><abc />"];
}

- (void) testDocumentHasAttribute {
	[self runXmlDocumentTest: @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><abc x=\"value\" />"];
}

- (void) testDocumentHasNamespace {
	[self runXmlDocumentTest: @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><cba:abc xmlns:cba=\"someurl1\" />"];
}

- (void) testDocumentHasAValue {
	[self runXmlDocumentTest: @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><abc>def</abc>"];
}

- (void) testSubtreeMinimal {
	[self runXmlSubtreeTest: @"<abc />"];
}

- (void) testSubtreeHasAttribute {
	[self runXmlSubtreeTest: @"<abc x=\"value\" />"];
}

- (void) testSubtreeHasNamespace {
	[self runXmlSubtreeTest: @"<cba:abc xmlns:cba=\"someurl1\" />"];
}

- (void) testSubtreeHasAValue {
	[self runXmlSubtreeTest: @"<abc>def</abc>"];
}

- (void) testDocumentCreatesErrorWhenBlankXml {
	NSString *corruptXml = @"";
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: corruptXml] autorelease];
	NSError *error = nil;
	DCXmlDocument *root = [parser parse:&error];
	GHAssertNotNil(error, @"Error not returned.");
	GHAssertNil(root, @"Blank xml should not have passed.");
	GHAssertEquals(error.code, 5, @"Error code does not match");
	GHAssertEqualStrings(error.domain, @"NSXMLParserErrorDomain", @"Error domain does not match");
}

- (void) testDocumentIgnoresErrorWhenBlankXmlAndErrorNull {
	NSString *corruptXml = @"";
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: corruptXml] autorelease];
	DCXmlDocument *root = [parser parse:NULL];
	GHAssertNil(root, @"Blank xml should not have passed.");
}

- (void) testSubtreeCreatesErrorOnInvalidDefaultNamespace {
	NSString *corruptXml = @"<abc xmlns=\"default\" />";
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: corruptXml] autorelease];
	NSError *error = nil;
	DCXmlNode *root = [parser parseSubtree:&error];
	GHAssertNotNil(error, @"Error not returned.");
	GHAssertNil(root, @"Blank xml should not have passed.");
	GHAssertEquals(error.code, 100, @"Error code does not match");
	GHAssertEqualStrings(error.domain, @"NSXMLParserErrorDomain", @"Error domain does not match");
}

- (void) testSubtreeWithCorruptNamespace {
	NSString *corruptXml = @"<x:abc xmlns:x=\"http://noEndingQuote  />";
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: corruptXml] autorelease];
	NSError *error = nil;
	DCXmlNode *root = [parser parseSubtree:&error];
	GHAssertNotNil(error, @"Error not returned.");
	GHAssertNil(root, @"Blank xml should not have passed.");
	GHAssertEquals(error.code, 40, @"Error code does not match");
	GHAssertEqualStrings(error.domain, @"NSXMLParserErrorDomain", @"Error domain does not match");
}

- (void) testComplexMultiLineXml {
	NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
						 @"\n<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
						 @"\n\t<soap:body>"
						 @"\n\t\t<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
						 @"\n\t\t\t<symbol>MOT</symbol>"
						 @"\n\t\t</m:GetLastTradePrice>"
						 @"\n\t</soap:body>"
						 @"\n</soap:envelope>";
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: xml] autorelease];
	NSError *error = nil;
	DCXmlDocument *xmlDoc = [parser parse:&error];
	GHAssertNil(error, @"Error object not nil");
	GHAssertNotNil(xmlDoc, @"Nil returned when XmlDocument * expected.");

	// Test pretty string.
	NSString *resultXml = [xmlDoc asPrettyXmlString];
	GHAssertEqualStrings(resultXml, DHC_TRIM(xml), @"Processing XML did not result in identical xml when reconstituted.");
}

- (void) testComplexNamespacedXmlWithDefault {
	NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
						 @"<a:abc xmlns:a=\"urla\" xmlns:d=\"urld\">"
						 @"<d:def>"
						 @"<ghi xmlns=\"http://urldefault\">"
						 @"<a:jkl />"
						 @"</ghi>"
						 @"</d:def>"
						 @"</a:abc>";
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: xml] autorelease];
	NSError *error = nil;
	DCXmlDocument *xmlDoc = [parser parse:&error];
	GHAssertNil(error, @"Error not nil");
	NSString *result = [xmlDoc asXmlString];
	DHC_LOG(@"Expected %@", xml);
	DHC_LOG(@"Got      %@", result);
	GHAssertEqualStrings(result, xml, @"Complex xml not corrected rebuilt.");
}

- (void) testStaticCreationWithXml {
	DCXmlParser *parser = [DCXmlParser parserWithXml: nil];
	GHAssertNotNil(parser, @"Parser not created");
}

- (void) testStaticCreationWithData {
	DCXmlParser *parser = [DCXmlParser parserWithData: nil];
	GHAssertNotNil(parser, @"Parser not created");
}

- (void) testStaticCreationWithUrl {
	//Need a valid url with this test or it leaks memory.
	NSURL *url = [NSURL URLWithString: @"file:///."];
	DCXmlParser *parser = [DCXmlParser parserWithUrl: url];
	GHAssertNotNil(parser, @"Parser not created");
}


// ***** HELPERS ******

- (void) runXmlDocumentTest: (NSString *) expectedXml {
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: expectedXml] autorelease];
	NSError *error = nil;
	DCXmlDocument *xmlDoc = [parser parse:&error];
	GHAssertNil(error, @"Error not nil");
	GHAssertNotNil(xmlDoc, @"Nil returned when XmlDocument * expected.");
	NSString *resultXml = [xmlDoc asXmlString];
	GHAssertEqualStrings(resultXml, DHC_TRIM(expectedXml), @"Processing XML did not result in identical xml when reconstituted.");
}

- (void) runXmlSubtreeTest: (NSString *) expectedXml {
	DCXmlParser *parser = [[[DCXmlParser alloc] initWithXml: expectedXml] autorelease];
	NSError *error = nil;
	DCXmlNode *xmlDoc = [parser parseSubtree:&error];
	GHAssertNil(error, @"Error not nil");
	GHAssertNotNil(xmlDoc, @"Nil returned when DCXmlNode * expected.");
	NSString *resultXml = [xmlDoc asXmlString];
	GHAssertEqualStrings(resultXml, DHC_TRIM(expectedXml), @"Processing XML did not result in identical xml when reconstituted.");
}

@end