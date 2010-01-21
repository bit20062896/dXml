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
 * This category adds xpath capability to the DCXmlNode. The Xpath capability is not a complete implementation. However it proves the basic set of instructions needed to be able to locate DCXmlNodes and the text values from DCTextNodes. Xpaths are always executed starting from the DCXmlNode they are passed to. The only exception to this being if the expression starts with a root node reference. So if you pass the xpath "/abc" to the Body node of a standard soap message, it will look for an abc element under the Body element. The equivalent using a full path expressions is "//Envelope/Body/abc" .
 * 
 * Here is a list of the elements you can use in the xpaths:
 * - <b>//<i>element-name</i></b> - refers to the root node of the document mode. element-name must match the root element name. If used, this must be the first element in the xpath.
 * - <b>/</b> - delimits the elements of an xpath. ie. Envelope/Body/Request/
 * - <b>..</b> - refers back up to the parent of the current element. ie. When given to the Body element, the xpath "../Header" will return the header node.
 * - <b>.</b> - refers to the current node so doesn't really do anything as such, but is here for completeness. Allows xpaths like "./abc"
 * - <b>element-name</b> - looks in the list of sub elements of the current element, and returns the first which has the specified element-name.
 * - <b>[nn]</b> - Finds a sub node of the current node base on a zero based index. ie. [2] returns the second element under the current element. This is most useful when dealing with a list of items being returned.
 * 
 * And some examples of xpaths:
 * 
 * <b>//Envelope/Body/abc</b> - locates the 1st abc element in the Body of a soap message.
 * 
 * <b>../abc/def</b> - from the current node, locate the abc sub element, then it's def sub element.
 */

@interface DCXmlNode (XPath)

/** \name XPath */

/**
 * Returns the DCXmlNode specified by the supplied Xpath. If there is no node at any point in the xpath a nil is returned.
 */
- (DCXmlNode *) xmlNodeFromXPath:(NSString *)aXpath;

/**
 * Returns NSString specified by the supplied Xpath. If there is no node at any point in the xpath, or the end of the xpath is not a DCTextNode, then a nil is returned. Once the target node of the path is located, the DCXmlNode:value method is called to return the nodes text value.
 */
- (NSString *) valueFromXPath:(NSString *)aXpath;

@end
