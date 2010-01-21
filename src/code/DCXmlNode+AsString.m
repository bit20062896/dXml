//
//  DCXmlNode+AsString.m
//  dXml
//
//  Created by Derek Clarkson on 21/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXmlNode+AsString.h"

@implementation DCXmlNode (AsString)

- (NSString *) asXmlString {
	NSMutableString * xml = [[[NSMutableString alloc] init] autorelease];

	[self appendToXmlString:xml prettyPrint:NO indentDepth:0];
	return xml;
}

- (NSString *) asPrettyXmlString {
	NSMutableString * xml = [[[NSMutableString alloc] init] autorelease];

	[self appendToXmlString:xml prettyPrint:YES indentDepth:0];
	return xml;
}


@end
