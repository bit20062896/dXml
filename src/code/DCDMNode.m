//
//  DMNode.m
//  dXml
//
//  Created by Derek Clarkson on 14/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import "DCDMNode.h"

@interface DCDMNode ()
- (void) newLineAndIndent:(NSMutableString *)xml prettyPrint:(bool)prettyPrint indentDepth:(int)indentDepth;
@end

@implementation DCDMNode

@synthesize parentNode;

/*
 * Used during pretty printing. Adds a new line and the necessary number of tabs for the next element.
 */
- (void) newLineAndIndent:(NSMutableString *)xml prettyPrint:(bool)prettyPrint indentDepth:(int)indentDepth {
	if (prettyPrint) {
		if ([xml length] > 0) {
			[xml appendString:@"\n"];
		}
		for (int i = 0; i < indentDepth; i++) {
			[xml appendString:@"\t"];
		}
	}
}

- (void) appendToXmlString:(NSMutableString *)xml prettyPrint:(bool)prettyPrint indentDepth:(int)indentDepth {
	// Nothing to do at this level.
}

- (void) dealloc {
	self.parentNode = nil;
	[super dealloc];
}

@end
