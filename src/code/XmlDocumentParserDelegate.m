//
//  XmlDocumentParserDelegate.m
//  dXml
//
//  Created by Derek Clarkson on 25/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "XmlDocumentParserDelegate.h"
#import "dXml.h"

@implementation XmlDocumentParserDelegate

- (void) createNodeWithName: (NSString *) elementName {

	//If this is the first time in, then we want to create a XmlDocument as a top level element
	//instead of a XmlNode.
	if (self.document == nil) {
		DHC_LOG(@"self.document == nil, so creating a XmlDocument as the current document.");
		currentNode = (XmlDocument *)[[XmlDocument alloc] initWithName: elementName];
		return;
	}
	
	//Otherwise call the super to create the element.
	[super createNodeWithName:elementName];
}

-(XmlDocument *) document {
	return (XmlDocument *) rootNode;
}

@end