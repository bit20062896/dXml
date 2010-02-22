//
//  XmlParser.h
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "XmlDocument.h"
#import "XmlNode.h"
#import "XmlDocumentParserDelegate.h"

/**
 * XmlParser is the raw parser for detailing with xml streams. In addition to the default NSURL and NSData that
 * the apis support, this class can also deal with xml inside NSStrings which makes testing and other options easy.
 * Once the data has been parsed, it can be returned on one of two ways, either as a XmlDocument or as a XmlNode. The
 * parserSubTree: method is exposed but ideally designed for parsing sections of a xml tree rather than a whole document.
 * Use parse: for that.
 */
@interface XmlParser : NSObject {
	@private
	NSXMLParser *parser;
}

/**
 * Creates an autorelease instance of XmlParser ready to read the supplied data.
 * \param xml the data to read.
 */
+ (XmlParser *) parserWithXml: (NSString *) xml;

/**
 * Creates an autorelease instance of XmlParser ready to read the supplied data.
 * \param data the data to read.
 */
+ (XmlParser *) parserWithData: (NSData *) data;

/**
 * Creates an autorelease instance of XmlParser ready to read the supplied data.
 * \param url the url that will be called to access the data.
 */
+ (XmlParser *) parserWithUrl: (NSURL *) url;

- (XmlParser *) initWithXml: (NSString *) xml;
- (XmlParser *) initWithData: (NSData *) data;
- (XmlParser *) initWithUrl: (NSURL *) url;

/**
 * Initiates the parsing of the supplied source and returns a XmlDocument containing the data graph of the results.
 */
- (XmlDocument *) parse;

/**
 * Initiates the parsing of the supplied source and returns a XmlNode containing the data graph of the results.
 */
- (XmlNode *) parseSubtree;

@end