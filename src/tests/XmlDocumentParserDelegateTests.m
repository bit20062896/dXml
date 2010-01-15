//
//  XmlParserDelegateTests.m
//  dXml
//
//  Created by Derek Clarkson on 22/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "XmlDocumentParserDelegate.h"
#import "XmlNamespace.h"
#import "GHUnit.h"
#import "dXml.h"

@interface XmlDocumentParserDelegateTests : GHTestCase {
	@private
}

@end

@implementation XmlDocumentParserDelegateTests

- (void) testDidStartElementCreatesDocument {
	XmlDocumentParserDelegate *delegate = [[[XmlDocumentParserDelegate alloc]init]autorelease];
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname" attributes: nil];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname"];

	XmlDocument *document = [delegate document];

	GHAssertNotNil(document, @"document not returned.");
	GHAssertTrue([document isKindOfClass:[XmlDocument class]], @"Not an XmlDocument returned" );
	GHAssertEqualStrings([document name], @"elementname", @"Document name not what was expected.");
}

@end