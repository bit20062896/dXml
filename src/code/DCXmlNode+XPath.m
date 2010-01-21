//
//  DCXmlNode+XPath.m
//  dXml
//
//  Created by Derek Clarkson on 20/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DCXmlNode+XPath.h"
#import "dXml.h"
#import "DCTextNode.h"

typedef enum {
	START =0,
	ROOT=1,
	ELEMENT=2,
	OPEN_BRACKET=3,
	CLOSE_BRACKET=4,
	NUMBER=5,
	SLASH=6,
	PARENT = 7,
	DOT = 8,
	END = 9
} TokenTypes;

// This array defines the valid syntax for our xpath expressions. This is a standard paser matrix.
// The token types enum defines the tokens. Therefore XPATH_TOKEN_RULES[TokenTypes from][TokenTypes to] returns if
// the particular combination of tokens is allowed.
BOOL const XPATH_TOKEN_RULES [10][10] = {
	{ NO, YES, YES, YES, NO,  NO,	 YES, YES, YES, NO  },
	{ NO, NO,  YES, NO,	NO,  NO,	 NO,	NO,  NO,	 NO  },
	{ NO, NO,  NO,	 YES, NO,  NO,	 YES, NO,  NO,	 YES },
	{ NO, NO,  NO,	 NO,	NO,  YES, NO,	NO,  NO,	 NO  },
	{ NO, NO,  NO,	 NO,	NO,  NO,	 YES, NO,  NO,	 YES },
	{ NO, NO,  NO,	 NO,	YES, NO,	 NO,	NO,  NO,	 NO  },
	{ NO, NO,  YES, YES, NO,  NO,	 NO,	YES, NO,	 YES },
	{ NO, NO,  NO,	 NO,	NO,  NO,	 YES, NO,  NO,	 YES },
	{ NO, NO,  NO,	 NO,	NO,  NO,	 YES, NO,  NO,	 NO  },
	{ NO, NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  NO,	 NO  }
};


@interface DCXmlNode ()
- (DCDMNode *) nodeFromXPath:(NSString *)aXpath;
@end


@implementation DCXmlNode (XPath)

- (DCXmlNode *) xmlNodeFromXPath:(NSString *)aXpath {
	return (DCXmlNode *)[self nodeFromXPath:aXpath];
}

- (NSString *) valueFromXPath:(NSString *)aXpath {
	DCDMNode * node = [self nodeFromXPath:aXpath];

	if (node == nil) {
		return nil;
	}
	if ([node isKindOfClass:[DCXmlNode class]]) {
		return ((DCXmlNode *)node).value;
	}
	return ((DCTextNode *)node).value;
}

- (DCDMNode *) nodeFromXPath:(NSString *)aXpath {

	DHC_LOG(@"Processing xpath: %@", aXpath);
	NSScanner * scanner = [NSScanner scannerWithString:aXpath];

	// scanable strings.
	NSMutableCharacterSet * validElementnameCharacters = [[[NSCharacterSet alphanumericCharacterSet] mutableCopy] autorelease];
	[validElementnameCharacters addCharactersInString:@"_"];

	// Now parse, validate and process the xpath.
	DCDMNode * currentNode = self;
	int arrayIndex;
	NSString * nextElementName;
	TokenTypes fromToken = START;
	TokenTypes toToken;
	int scanStartIndex;
	BOOL validateName = NO;

	while ([scanner isAtEnd] == NO) {

		// check for nil current node.
		if (currentNode == nil) {
			DHC_LOG(@"Current node is nil, therefore result is nil, returning");
			return nil;
		}

		// We should not arrive here with a text node as the current node.
		if ([currentNode isKindOfClass:[DCTextNode class]]) {
			if (![scanner isAtEnd]) {
				DHC_LOG(@"Arrived at a text node with more xpath to process.");
				@throw [NSException exceptionWithName : @"TextNodeInPathException" reason :[NSString stringWithFormat:@"Found a text node in the xPath when there is still remaining path at index %i", [scanner scanLocation]] userInfo : nil];
			}
		}

		scanStartIndex = [scanner scanLocation];

		// Read and identify the next token.
		if ([scanner scanString:@"//" intoString:NULL]) {
			DHC_LOG(@"Found root (//)");
			toToken = ROOT;
		} else if ([scanner scanString:@"[" intoString:NULL]) {
			DHC_LOG(@"Found start bracket ([)");
			toToken = OPEN_BRACKET;
		} else if ([scanner scanString:@"]" intoString:NULL]) {
			DHC_LOG(@"Found closing bracket (])");
			toToken = CLOSE_BRACKET;
		} else if ([scanner scanString:@"/" intoString:NULL]) {
			DHC_LOG(@"Found slash (/)");
			toToken = SLASH;
		} else if ([scanner scanString:@".." intoString:NULL]) {
			DHC_LOG(@"Found parent reference (..)");
			toToken = PARENT;
		} else if ([scanner scanString:@"." intoString:NULL]) {
			DHC_LOG(@"Found self reference (.)");
			toToken = DOT;
		} else if ([scanner scanInt:&arrayIndex]) {
			DHC_LOG(@"Found arrray index");
			toToken = NUMBER;
		} else if ([scanner scanCharactersFromSet:validElementnameCharacters intoString:&nextElementName]) {
			DHC_LOG(@"Found element name");
			toToken = ELEMENT;
		} else {
			// Nothing scanned so throw an error.
			DHC_LOG(@"Unknown token in xpath, throwing exception.");
			@throw [NSException exceptionWithName : @"UnknownTokenInXpathException" reason :[NSString stringWithFormat:@"Not at end of xpath and could figure out next token at char index %i", scanStartIndex] userInfo : nil];
		}

		// Now check that the token combination is valid.
		if (!XPATH_TOKEN_RULES[fromToken][toToken]) {
			DHC_LOG(@"Invalid xpath, throwing exception.");
			@throw [NSException exceptionWithName : @"InvalidXpathException" reason :[NSString stringWithFormat:@"Invalid xpath at index %i", scanStartIndex] userInfo : nil];
		}

		// Store to as from.
		fromToken = toToken;

		// All is good so lets process.
		switch (toToken) {
			case ROOT:
				DHC_LOG(@"Climbing tree to top and validating name.");
				while (currentNode.parentNode != nil)
					currentNode = currentNode.parentNode;
				validateName = YES;
				continue;
			case ELEMENT:
				if (validateName) {
					validateName = NO;
					DHC_LOG(@"Validating current element name.");
					if (![[(DCXmlNode *)currentNode name] isEqualToString:nextElementName]) {
						DHC_LOG(@"Invalid root node name, throwing exception.");
						@throw [NSException exceptionWithName : @"InvalidRootElementNameException" reason :[NSString stringWithFormat:@"Root element name does not match."] userInfo : nil];
					}
				} else {
					DHC_LOG(@"Changing current node to element %@", nextElementName);
					currentNode = [(DCXmlNode *)currentNode xmlNodeWithName:nextElementName];
				}
				continue;
			case OPEN_BRACKET:
				continue;
			case CLOSE_BRACKET:
				continue;
			case NUMBER:
				DHC_LOG(@"Getting %i", arrayIndex);
				currentNode = [(DCXmlNode *)currentNode nodeAtIndex:arrayIndex];
				continue;
			case PARENT:
				DHC_LOG(@"Switching to parent node.");
				currentNode = currentNode.parentNode;
				continue;
			case SLASH:
				continue;
			case DOT:
				continue;
			default:
				break;
		}
	}

	// Now check the xpath is complete.
	if (!XPATH_TOKEN_RULES[fromToken][END]) {
		DHC_LOG(@"XPath not complete, throwing exception.");
		@throw [NSException exceptionWithName : @"IncompleteXpathException" reason :[NSString stringWithFormat:@"Found end of xpath when expression not complete."] userInfo : nil];
	}

	return currentNode;

}

@end
