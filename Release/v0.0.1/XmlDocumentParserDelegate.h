//
//  XmlDocumentParserDelegate.h
//  dXml
//
//  Created by Derek Clarkson on 25/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlSubtreeParserDelegate.h"
#import "XmlDocument.h"

/**
 * Simple extension of the XmlSubtreeParserDelegate that returns a XmlDocument. 
 */
@interface XmlDocumentParserDelegate : XmlSubtreeParserDelegate {
}

/**
 * Get the document parsed as a XmlDocument.
 */
-(XmlDocument *) document;

@end