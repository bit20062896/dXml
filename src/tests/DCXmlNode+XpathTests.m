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
#import "DCXmlParser.h";
#import "DCXmlNode+XPath.h"
#import "dXml.h"

@interface DCXmlNode_XpathTests : GHTestCase {
	@private
	DCXmlDocument *document;
	DCXmlNode *def1;
}
@end

@implementation DCXmlNode_XpathTests

- (void) setUpClass {
	NSString *testXml = @"<abc>"
	   @"<def>"
	   @"<ghi>lmn</ghi>"
	   @"</def>"
	   @"<def>"
	   @"<ghi>xyz</ghi>"
	   @"</def>"
	   @"</abc>";
	DCXmlParser *parser = [[DCXmlParser alloc] initWithXml:testXml];
	document = [parser parse:NULL];
	[parser release];
	def1 = [document xmlNodeWithName:@"def"];
}

- (void) tearDownClass {
	DHC_DEALLOC(document);
	DHC_DEALLOC(def1);
}

- (void) testRootReference {
	NSString *xpath = @"/";
	id results = [def1 xpath:xpath];
	GHAssertTrue([results isKindOfClass:[DCXmlDocument class]], @"Document not returned");
	DCXmlDocument * returnedObj = (DCXmlDocument *) results;
	GHAssertEqualStrings(returnedObj.name, @"abc", @"Incorrect node returned");
}

@end
