//
//  DCXmlNode+XPath.h
//  dXml
//
//  Created by Derek Clarkson on 20/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlNode.h"

/**
 * This category adds xpath capability to the DCXmlNode. The Xpath capability is not a complete implementation. However it proves the basic set of instructions needed to be able to locate DCDMNodes. 
 * 
 * Here is a list of the elements you can use in the xpaths and how they are processed.
 * 
 * - <b>//<i>element-name</i></b> - returns all occurances of <i>element-name</i> from the current point in the document model and below.
 * - <b>/</b> - delimiter between nodes of the xpath. <b>Note:</b> If this occurs at the start of the xpath then it causes the path to be regarded as an absolute path which starts from the root of the document.
 * - <b>..</b> - refers back up to the parent of the current element. 
 * - <b>.</b> - refers to the current node so doesn't really do anything as such, but is here for completeness. Allows xpaths like "./abc"
 * - <b>element-name</b> - looks in the list of sub elements of the current element, and returns the first which has the specified element-name.
 * - <b>[nn]</b> - Finds a sub node of the current node base on a zero based index. ie. [2] returns the second element under the current element. This is most useful when dealing with a list of items being returned.
 * 
 */

@interface DCXmlNode (XPath)

/** \name XPath */

/**
 * Executes the xpath and returns the results. 
 * The results can be any of the following:
 * \li nil indicating that there was no matching xml.
 * \li A single DCTextNode or DCXmlNode.
 * \li A NSArray containing any combination of DCTextNodes and DCXmlNodes. 
 */
- (id) xpath:(NSString *)aXpath;

@end
