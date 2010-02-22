//
//  XmlParserDelegate.h
//  dXml
//
//  Created by Derek Clarkson on 16/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"

/**
 * Main class for parsing xml streams. This class is capable of receiving and processing the incoming xml events and assembling
 * from them a complete DM data graph. IT responds to the standard NSXMLParser delegate methods to achieve this.
 */
@interface XmlSubtreeParserDelegate : NSObject {
	@protected
	XmlNode *currentNode;
	XmlNode *rootNode;
	@private
	NSMutableDictionary *namespaceCache;
	/**
	 * Used to cache text until an ending element or a new subelement is encounterded.
	 */
	NSMutableString *valueCache;
}

/**
 * Returns the root node of the DM as a XmlNode.
 */
@property (readonly, nonatomic) XmlNode *rootNode;

/**
 * Called during the construction of the DM each time a new node is needed. The XmlDocumentParserDelegate class overrides
 * this method to create a XmlDocument for the root node.
 * \see XmlDocumentParserDelegate
 */
- (void) createNodeWithName: (NSString *) aName;

/**
 * NSXMLParser delegate method.
 */
- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI
qualifiedName: (NSString *) qualifiedName attributes: (NSDictionary *) attributeDict;

/**
 * NSXMLParser delegate method.
 */
- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI
qualifiedName: (NSString *) qName;

/**
 * NSXMLParser delegate method.
 */
- (void) parser: (NSXMLParser *) parser didStartMappingPrefix: (NSString *) prefix toURI: (NSString *) namespaceURI;

/**
 * NSXMLParser delegate method.
 */
- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string;

/**
 * NSXMLParser delegate method.
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

/**
 * NSXMLParser delegate method.
 */
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError;


@end