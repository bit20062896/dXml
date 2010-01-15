//
//  XmlNode.m
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "XmlNode.h"
#import "TextNode.h"
#import "DMNode.h"
#import "XmlDocument.h"
#import "XmlAttribute.h"
#import "XmlNamespace.h"
#import "dXml.h"

@interface XmlNode ()
- (void) allocSubElementDictionary;
- (void) allocNamespaceDictionary;
- (void) allocAttributeDictionary;
- (void) appendNodeDetails:(NSMutableString *)xml;
- (BOOL) hasSingleTextNode;
@end

@implementation XmlNode

@synthesize name;
@synthesize prefix;
@synthesize defaultSchema;

- (XmlNode *) initWithName:(NSString *)aName {
	return [self initWithName:aName prefix:nil];
}

- (XmlNode *) initWithName:(NSString *)aName prefix:(NSString *)aPrefix {
	self = [super init];

	if (self) {
		name = [aName retain];
		self.prefix = aPrefix;
	}

	return self;
}

+ (XmlNode *) createWithName:(NSString *)aName {
	XmlNode * node = [[[XmlNode alloc] initWithName:aName] autorelease];

	return node;
}

+ (XmlNode *) createWithName:(NSString *)aName prefix:(NSString *)aPrefix {
	XmlNode * node = [[[XmlNode alloc] initWithName:aName prefix:aPrefix] autorelease];

	return node;
}

+ (XmlNode *) createWithName:(NSString *)aName value:(NSString *)aValue {
	XmlNode * node = [[[XmlNode alloc] initWithName:aName] autorelease];

	[node setValue:aValue];
	return node;
}

+ (XmlNode *) createWithName:(NSString *)aName prefix:(NSString *)aPrefix value:(NSString *)aValue {
	XmlNode * node = [[[XmlNode alloc] initWithName:aName prefix:aPrefix] autorelease];

	[node setValue:aValue];
	return node;
}


- (BOOL) isEqualToName:(NSString *)aName {
	return [self.name isEqualToString:aName];
}

- (XmlNode *) addXmlNodeWithName:(NSString *)aName {
	return [self addXmlNodeWithName:aName prefix:nil value:nil];
}

- (XmlNode *) addXmlNodeWithName:(NSString *)aName prefix:(NSString *)aPrefix {
	return [self addXmlNodeWithName:aName prefix:aPrefix value:nil];
}

- (XmlNode *) addXmlNodeWithName:(NSString *)aName value:(NSString *)aValue {
	return [self addXmlNodeWithName:aName prefix:nil value:aValue];
}

- (XmlNode *) addXmlNodeWithName:(NSString *)aName prefix:(NSString *)aPrefix value:(NSString *)aValue {

	// First create the node.
	DHC_LOG(@"Creating autorelease XmlNode for %@", aName);
	XmlNode * node = [[[XmlNode alloc] initWithName:aName prefix:aPrefix] autorelease];
	[self addNode:node];

	// Create a text child node if it needs one.
	if (aValue != nil) {
		[node addTextNodeWithValue:aValue];
	}

	return node;
}

- (void) addNode:(DMNode *)node {

	// Create the node dictionaries.
	[self allocSubElementDictionary];

	if ([node isKindOfClass:[TextNode class]]) {
#ifdef DHC_DEBUG
		TextNode * textNode = (TextNode *)node;
		DHC_LOG(@"Adding text node for %@ to parent %@", textNode.value, self.name);
#endif
		// Nothing to do at this stage.
	} else {

		XmlNode * xmlNode = (XmlNode *)node;
		DHC_LOG(@"Adding xml node %@ to parent %@", xmlNode.name, self.name);
		// Only add to the dictionary if there
		// is not already an entry. That way the dictionary always points to the first.
		if (![self hasXmlNodeWithName:xmlNode.name]) {
			[nodesByName setValue:node forKey:xmlNode.name];
		}
	}

	// Add the node to the ordered list and set it's parent.
	[nodesInOrder addObject:node];
	node.parentNode = self;
}

- (XmlNode *) xmlNodeWithName:(NSString *)aName {
	return [nodesByName valueForKey:aName];
}

- (XmlNode *) nodeAtIndex:(int)aIndex {
	return [nodesInOrder objectAtIndex:aIndex];
}

- (NSEnumerator *) nodes {
	return [nodesInOrder objectEnumerator];
}

- (NSEnumerator *) xmlNodesWithName:(NSString *)aName {
	NSMutableArray * results = [[[NSMutableArray alloc] init] autorelease];
	NSString * findname = aName;

	for (XmlNode * element in nodesInOrder) {
		if ([element.name isEqualToString:findname]) {
			DHC_LOG(@"Adding %@ to found elements array.", element.name);
			[results addObject:element];
		}
	}
	return [results objectEnumerator];
}

- (BOOL) hasXmlNodeWithName:(NSString *)aName {
	return [self xmlNodeWithName:aName] != nil;
}

/*
 * Private helper method. Base this off the presence of the node array as this will always be present if there are child nodes.
 */
- (void) allocSubElementDictionary {
	if (nodesInOrder == nil) {
		nodesByName = [[NSMutableDictionary alloc] init];
		nodesInOrder = [[NSMutableArray alloc] init];
	}
}

- (void) allocNamespaceDictionary {
	if (namespaces == nil) {
		namespaces = [[NSMutableDictionary alloc] init];
	}
}

- (void) allocAttributeDictionary {
	if (attributes == nil) {
		attributes = [[NSMutableDictionary alloc] init];
	}
}

- (void) addNamespace:(NSString *)aUrl prefix:(NSString *)aPrefix {
	[self allocNamespaceDictionary];
	XmlNamespace * namespace = [[XmlNamespace alloc] initWithUrl:aUrl prefix:aPrefix];
	[namespaces setValue:namespace forKey:aPrefix];
	[namespace release];
}

- (NSEnumerator *) namespaces {
	return [namespaces objectEnumerator];
}

- (void) setAttribute:(NSString *)aName value:(NSString *)aValue {
	// Create the array if needed. Attrs are not common so we don't create in the constructor.
	[self allocAttributeDictionary];

	// Now set the value.
	XmlAttribute * attr = [attributes valueForKey:aName];
	if (attr == nil) {
		attr = [[XmlAttribute alloc] initWithName:aName value:aValue];
		[attributes setValue:attr forKey:aName];
		[attr release];
	} else {
		[attr setValue:aValue];
	}
}

- (NSString *) attributeValue:(NSString *)aName {
	return [[attributes valueForKey:aName] value];
}

- (NSEnumerator *) attributes {
	return [attributes objectEnumerator];
}

- (NSString *) value {
	for (DMNode * node in nodesInOrder) {
		if ([node isKindOfClass:[TextNode class]]) {
			return ((TextNode *)node).value;
		}
	}
	return nil;
}

- (TextNode *) addTextNodeWithValue:(NSString *)aValue {
	TextNode * node = [[[TextNode alloc] initWithText:aValue] autorelease];

	[self addNode:node];
	return node;
}

- (void) setValue:(NSString *)value {
	[nodesInOrder removeAllObjects];
	[nodesByName removeAllObjects];
	[self addTextNodeWithValue:value];
}

- (void) appendToXmlString:(NSMutableString *)xml prettyPrint:(bool)prettyPrint indentDepth:(int)indentDepth {

	// New line and tab the element across if pretty printing.
	[self newLineAndIndent:xml prettyPrint:prettyPrint indentDepth:indentDepth];

	// Start the element.
	NSString * nodeName = prefix == nil ? name : [NSString stringWithFormat:@"%@:%@", prefix, name];
	[xml appendFormat:@"<%@", nodeName];
	[self appendNodeDetails:xml];

	if ([nodesInOrder count] == 0) {
		// Empty element.
		[xml appendString:@" />"];
		return;
	}

	// End the current node.
	[xml appendString:@">"];

	// If there is only one child node and it's a text node under 80 chars then do this as a single line.
	// Otherwise tell all child nodes to append themselves.
	if ([self hasSingleTextNode]) {
		TextNode * textNode = (TextNode *)[nodesInOrder objectAtIndex:0];
		if ([textNode.value length] < 81) {
			[textNode appendToXmlString:xml prettyPrint:prettyPrint indentDepth:indentDepth];
			[xml appendFormat:@"</%@>", nodeName];
			return;
		} else {
			// Put the text on the next line.
			[self newLineAndIndent:xml prettyPrint:prettyPrint indentDepth:indentDepth];
		}
	}

	// Add the child nodes.
	for (DMNode * node in[self nodes]) {
		[node appendToXmlString:xml prettyPrint:prettyPrint indentDepth:indentDepth + 1];
	}

	// Add an end node.
	[self newLineAndIndent:xml prettyPrint:prettyPrint indentDepth:indentDepth];
	[xml appendFormat:@"</%@>", nodeName];

}

/**
 * Indicates if the child nodes of the current node can be condensed into a single line during pretty printing.
 */
- (BOOL) hasSingleTextNode {
	return [nodesInOrder count] == 1
	       && [[nodesInOrder objectAtIndex:0] isKindOfClass:[TextNode class]];
}

/**
 * When printing, concatinates the nodes details to the initial declaration.
 */
- (void) appendNodeDetails:(NSMutableString *)xml {
	// add in declared namespaces.
	for (XmlNamespace * namespace in[self namespaces]) {
		[namespace appendToXmlString:xml];
	}

	// Add the root schema from the document.
	if (self.defaultSchema != nil) {
		[xml appendFormat:@" xmlns=\"%@\"", self.defaultSchema];
	}

	// Append attributes to the element.
	for (XmlAttribute * attribute in[self attributes]) {
		[attribute appendToXmlString:xml];
	}

}


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

- (int) countNodes {
	return [nodesInOrder count];
}


- (void) dealloc {
	self.prefix = nil;

	DHC_DEALLOC(nodesInOrder);
	DHC_DEALLOC(nodesByName);
	DHC_DEALLOC(attributes);
	DHC_DEALLOC(namespaces);
	DHC_DEALLOC(name);
	[super dealloc];
}

@end