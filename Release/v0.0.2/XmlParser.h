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
 * \p
 * Here's an example of using this class.
 * \code
 * NSString *xml = @"lt;?xml version=\"1.0\" encoding=\"UTF-8\"&gt;"
 *	@"&lt;soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"&gt;"
 *	@"&lt;soap:Body&gt;"
 *	@"&lt;dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\"&gt;"
 *	@"&lt;forAccountNumber&gt;1234&lt;/forAccountNumber&gt;"
 *	@"&lt;/dhc:balance&gt;"
 *	@"\n\t&lt;/soap:Body&gt;"
 *	@"\n&lt;/soap:Envelope&gt;";
 * &nbsp;
 * XmlParser * parser = [XmlParser parserWithXml: xml];
 * NSError *error = nil;
 * XmlDocument *doc = [parser parse:&error];
 * if (error != nil) {
 *		// Deal with the error.
 * }
 * &nbsp;
 * // Otherwise process the results.
 * \endcode
 * This class requires you to instantiate it with the data and then call parse: or parseSubtree: as a seperate command so that in the future various settings can be added to the class. Then the sequence would become init - setup - parse.
 */
@interface XmlParser : NSObject {
	@private
	NSXMLParser * parser;
}

/** \name Constructors and factory methods */
/* @{ */
/**
 * Creates an autorelease instance of XmlParser ready to read the supplied data.
 * \param xml the data to read.
 */
+ (XmlParser *) parserWithXml:(NSString *)xml;

/**
 * Creates an autorelease instance of XmlParser ready to read the supplied data.
 * \param data the data to read.
 */
+ (XmlParser *) parserWithData:(NSData *)data;

/**
 * Creates an autorelease instance of XmlParser ready to read the supplied data.
 * \param url the url that will be called to access the data.
 */
+ (XmlParser *) parserWithUrl:(NSURL *)url;

/**
 * Default constructor which takes xml stored in a string.
 */
- (XmlParser *) initWithXml:(NSString *)xml;

/**
 * Default constructor which takes xml stored in a NSData object.
 */
- (XmlParser *) initWithData:(NSData *)data;

/**
 * Default constructor which reads an xml stream from a NSURL.
 */
- (XmlParser *) initWithUrl:(NSURL *)url;
/* @} */

/** \name Parsing */

/**
 * Initiates the parsing of the supplied source and returns a XmlDocument containing the data graph of the results.
 * \param aErrorVar Reference to an error variable where the parser can store an error that occurs. Must be passed as `&aErrorVar`.
 */
- (XmlDocument *) parse:(NSError **)aErrorVar;

/**
 * Initiates the parsing of the supplied source and returns a XmlNode containing the data graph of the results.
 * \param aErrorVar Reference to an error variable where the parser can store an error that occurs. Must be passed as `&aErrorVar`.
 */
- (XmlNode *) parseSubtree:(NSError **)aErrorVar;

@end