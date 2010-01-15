//
//  XmlDocument.m
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "XmlDocument.h"

@implementation XmlDocument

/**
 * Overridden to add the standard XML header before calling the standard XmlNode#appendToXmlString:prettyPrint:indentDepth:
 * method.
 */
- (void) appendToXmlString: (NSMutableString *) xml prettyPrint: (bool) prettyPrint indentDepth: (int) indentDepth {
	[xml appendString:XML_HEADER];
	[super appendToXmlString:xml prettyPrint:prettyPrint indentDepth:indentDepth];
}

@end
