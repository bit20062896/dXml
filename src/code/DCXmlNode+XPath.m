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
	SLASH=1,
	ELEMENT=2,
	OPEN_BRACKET=3,
	CLOSE_BRACKET=4,
	NUMBER=5,
	ANYWHERE=6,
	PARENT = 7,
	DOT = 8,
	END = 9
} TokenTypes;

// This array defines the valid syntax for our xpath expressions. This is a standard paser matrix.
// The token types enum defines the tokens. Therefore XPATH_TOKEN_RULES[TokenTypes from][TokenTypes to] returns if
// the particular combination of tokens is allowed.
BOOL const XPATH_TOKEN_RULES [10][10] = {
	/*               St  Slsh Ele  Open Cls  Nbr  Any  Prnt Dot  End */
	/* Start    */ { NO, YES, YES, YES, NO,  NO,	 YES, YES, YES, NO  },
	/* Slash    */ { NO, NO,  YES, YES, NO,  NO,	 NO,	NO,  NO,	 YES },
	/* Element  */ { NO, YES, NO,	 YES, NO,  NO,	 YES, NO,  NO,	 YES },
	/* Open     */ { NO, NO,  NO,	 NO,	NO,  YES, NO,	NO,  NO,	 NO  },
	/* Close    */ { NO, YES, NO,	 NO,	NO,  NO,	 NO,	NO,  NO,	 YES },
	/* Number   */ { NO, NO,  NO,	 NO,	YES, NO,	 NO,	NO,  NO,	 NO  },
	/* Anywhere */ { NO, NO,  YES, NO,	NO,  NO,	 NO,	NO,  NO,	 NO  },
	/* Parent   */ { NO, YES, NO,	 NO,	NO,  NO,	 NO,	NO,  NO,	 NO  },
	/* Dot      */ { NO, YES, NO,	 NO,	NO,  NO,	 NO,	NO,  NO,	 NO  },
	/* End      */ { NO, NO,  NO,	 NO,	NO,  NO,	 NO,	NO,  NO,	 NO  }
};


@interface DCXmlNode ()
@end


@implementation DCXmlNode (XPath)

- (id) xpath:(NSString *)aXpath {

	DHC_LOG(@"Processing xpath: %@", aXpath);
	NSScanner *scanner = [NSScanner scannerWithString:aXpath];

	// scanable strings.
	NSMutableCharacterSet *validElementnameCharacters = [[[NSCharacterSet alphanumericCharacterSet] mutableCopy] autorelease];
	[validElementnameCharacters addCharactersInString:@"_"];

	// First locate the root of the tree. Usually the current node but may not be.
	DCXmlNode *root = self;
	while (root.parentNode != nil) {
		root = root.parentNode;
	}

	// Now parse, validate and process the xpath.
	int arrayIndex;
	NSString *nextElementName;
	TokenTypes fromToken = START;
	TokenTypes toToken;
	int scanStartIndex;
	id result = nil;

	while ([scanner isAtEnd] == NO) {

		scanStartIndex = [scanner scanLocation];

		// Read and identify the next token.
		if ([scanner scanString:@"/" intoString:NULL]) {
			DHC_LOG(@"Found slash (/)");
			toToken = SLASH;
		} else if ([scanner scanString:@"[" intoString:NULL]) {
			DHC_LOG(@"Found start bracket ([)");
			toToken = OPEN_BRACKET;
		} else if ([scanner scanString:@"]" intoString:NULL]) {
			DHC_LOG(@"Found closing bracket (])");
			toToken = CLOSE_BRACKET;
		} else if ([scanner scanString:@"//" intoString:NULL]) {
			DHC_LOG(@"Found anywhere indicator (//)");
			toToken = ANYWHERE;
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
			case SLASH:
				continue;

			case ELEMENT:
				continue;

			case OPEN_BRACKET:
				continue;

			case CLOSE_BRACKET:
				continue;

			case NUMBER:
				continue;

			case PARENT:
				continue;

			case ANYWHERE:
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

	return result;

}

@end
