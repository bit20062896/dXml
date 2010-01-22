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
 * This category adds xpath capability to the DCXmlNode. The Xpath capability is not a complete implementation. However it proves the basic set of instructions needed to be able to locate DCDMNode instances. 
 * 
 * The processing follows the w3school standard (Although I found it a bit hard to follow!) as near as I can. The reference I used 
 * can be found at http://www.w3schools.com/XPath/xpath_syntax.asp Basically what happens is that unless there is a starting slash in the 
 * path, navigation starts with the xml element that you send the request to. If there is a starting slash then the processing of the path
 * starts from the root of the document model.
 *
 * Xpath processing is designed to return multiple nodes if they exist. So specifying something like abc/[2] will bring back the secod sub element from all occurances of the abc element. Not just the first. 
 * 
 * Here is a list of the elements you can use in the xpaths and how they are processed.
 * 
 * - <b>//<i>element-name</i></b> - returns all occurances of <i>element-name</i> from the current point in the document model and below. This 
 * is regardless of where they occur.
 * - <b>/</b> - delimiter between nodes of the xpath. <b>Note:</b> If this occurs at the start of the xpath then it causes the path to be regarded as an absolute path which starts from the root of the document.
 * - <b>..</b> - refers back up to the parent of each of the current set of nodes. 
 * - <b>.</b> - refers to the current node so doesn't really do anything as such, but is here for completeness. Allows xpaths like "./abc"
 * - <b>[nn]</b> - Finds a sub node of the current node base on a 1 based index. ie. [2] returns the second element under each of the current elements. This is most useful when dealing with a list of items being returned.
 * 
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
