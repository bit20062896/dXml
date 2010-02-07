//
//  DummyImplementations.m
//  dXml
//
//  Created by Derek Clarkson on 31/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "DummyImplementations.h"
#import "DCXmlNode.h"
#import "dXml.h"

@implementation DummySelector

@synthesize nodes;

- (NSArray *) selectNodesFromNode:(DCXmlNode * )node index:(int)anIndex {
	DHC_LOG(@"Returning nodes");
	return nodes;
}

@end

@implementation ErrorFilter
- (BOOL) acceptNode:(DCDMNode *)node index:(int)anIndex errorVar:(NSError **)aErrorVar {
	if (aErrorVar != NULL ) {
		*aErrorVar = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
	}
	return NO;
}
@end
