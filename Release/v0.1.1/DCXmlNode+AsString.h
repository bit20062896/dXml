//
//  DCXmlNode+AsString.h
//  dXml
//
//  Created by Derek Clarkson on 21/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlNode.h"
/**
 * This category adds the ability to output xml strings in various formats.
 */
@interface DCXmlNode (AsString)
/** \name Xml output */
/* @{ */

/**
 * Generates the DCXmlNode as a NSString. This is called when the client program needs to serialise the DM for sending to servers.
 */
- (NSString *) asXmlString;

/**
 * Effectively the same as asXmlString: however this "pretty prints" it which is useful for logging purposes where readibility of the
 * xml is the primary factor.
 */
- (NSString *) asPrettyXmlString;
/* @}*/


@end
