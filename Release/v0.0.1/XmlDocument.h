//
//  XmlDocument.h
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"

#define XML_HEADER @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

/**
 * XmlDocument classes are purely for use as the top level node representing a complete xml document. The other difference
 * is that when printing, XmlDocument will automatically insert the standard xml version header at the top of the document
 * produced.
 */
@interface XmlDocument : XmlNode {
	@private
}

@end
