//
//  XmlParser.m
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "XmlParser.h"
#import "dXml.h"
#import "XmlNode.h"

//Private method category used to hide methods (almost).
@interface XmlParser ()
-(XmlNode *) parseWithDelegate:(XmlSubtreeParserDelegate *) delegate returnNodeSelector:(SEL) message errorVar:(NSError * *) aErrorVar;
@end

@implementation XmlParser
+ (XmlParser *) parserWithXml:(NSString *) xml {
	DHC_LOG(@"Being asked to parse: %@", xml);
	return [[[XmlParser alloc] initWithXml: xml] autorelease];
}

+ (XmlParser *) parserWithData: (NSData *) data {
	return [[[XmlParser alloc] initWithData: data] autorelease];
}

+ (XmlParser *) parserWithUrl: (NSURL *) url {
	return [[[XmlParser alloc] initWithUrl: url] autorelease];
}

- (XmlParser *) initWithXml: (NSString *) xml {
	return [self initWithData:DHC_STRING_TO_DATA(xml)];
}

- (XmlParser *) initWithData: (NSData *) data {
	self = [super init];
	if (self) {
		parser = [[NSXMLParser alloc] initWithData: data];
	}
	return self;
}

- (XmlParser *) initWithUrl: (NSURL *) url {
	self = [super init];
	if (self) {
		parser = [[NSXMLParser alloc] initWithContentsOfURL: url];
	}
	return self;
}

- (XmlDocument *) parse:(NSError * *) aErrorVar {
	DHC_LOG(@"parsing a Document, error handing %@", DHC_PRETTY_BOOL(aErrorVar != NULL));
	XmlSubtreeParserDelegate *delegate = [[[XmlDocumentParserDelegate alloc] init] autorelease];
	return (XmlDocument *)[self parseWithDelegate:delegate returnNodeSelector:@selector(document) errorVar:aErrorVar];
}

- (XmlNode *) parseSubtree:(NSError * *) aErrorVar {
	DHC_LOG(@"parsing a Subtree, error handing %@", DHC_PRETTY_BOOL(aErrorVar != NULL));
	XmlSubtreeParserDelegate *delegate = [[[XmlSubtreeParserDelegate alloc] init] autorelease];
	return [self parseWithDelegate:delegate returnNodeSelector:@selector(rootNode) errorVar:aErrorVar];
}

-(XmlNode *) parseWithDelegate:(XmlSubtreeParserDelegate *) delegate returnNodeSelector:(SEL) message errorVar:(NSError * *) aErrorVar {

	DHC_LOG(@"Parsing, error handing %@", DHC_PRETTY_BOOL(aErrorVar != NULL));

	//Not worth processing xml if cannot understand selector.
	assert([delegate respondsToSelector:message]);

	//Now parse.
	parser.shouldProcessNamespaces = YES;
	parser.shouldReportNamespacePrefixes = YES;
	[parser setDelegate: delegate];
	[parser parse];
	if (delegate.error != nil) {
		DHC_LOG(@"Delegate has an error");
		if (aErrorVar != NULL) {
			DHC_LOG(@"Returning error from delegate");
			*aErrorVar = delegate.error;
		}
		else{
			DHC_LOG(@"Ignoring it");
		}
		return nil;
	}

	DHC_LOG(@"Returning value from delegate");
	return (XmlNode *)[delegate performSelector:message];
}

- (void) dealloc {
	DHC_DEALLOC(parser);
	[super dealloc];
}

@end