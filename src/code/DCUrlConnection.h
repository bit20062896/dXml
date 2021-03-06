//
//  UrlConnection.h
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This is the driver class for communicating with a url. It's basic job is to send and receive data from the server
 * and to manage security. Here is a basic example of using this class:
 * \code
 * NSString *request = @"&lt;?xml version=\"1.0\" encoding=\"UTF-8\"&gt;"
 *	@"&lt;soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"&gt;"
 *	@"&lt;soap:Body&gt;"
 *	@"&lt;dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\"&gt;"
 *	@"&lt;forAccountNumber&gt;1234&lt;/forAccountNumber&gt;"
 *	@"&lt;/dhc:balance&gt;"
 *	@"\n\t&lt;/soap:Body&gt;"
 *	@"\n&lt;/soap:Envelope&gt;";
 * DCUrlConnection *connection = [DCUrlConnection createWithUrl: BANKING];
 * [connection setHeaderValue: BALANCE_ACTION forKey: @"SOAPAction"];
 * NSError *error = nil;
 * NSData *data = [connection post: request errorVar:&error];
 * if (error != nil) {
 *		// Deal with the error.
 * }
 * &nbsp 
 * // Otherwise process the results.
 * \endcode
 */
@interface DCUrlConnection:NSObject {
	@protected
	NSString *serverUrl;
	NSMutableDictionary *headers;
	NSMutableData *responseData;
	BOOL responseDataReceived;
	BOOL responseReceived;
	BOOL allowSelfSignedCertificates;
	BOOL storeCredentials;
	NSString *userid;
	NSString *password;
	NSError *delegateError;
}

/** \name Properties */

/**
 * This is the url that refers to the server.
 */
@property (nonatomic, readonly) NSString *serverUrl;

/**
 * If set to true, the DCUrlConnection will accept self signed cerificates from the server. This is most useful when
 * developing code
 * as the server can be on the developer's machine. This setting allows the developer to work without having to obtain
 * formal certifcates.
 */
@property (nonatomic) BOOL allowSelfSignedCertificates;

/**
 * If set to true, credentials are stored and reused.
 */
@property (nonatomic) BOOL storeCredentials;

/** \name Constructors and factory methods */

/**
 * Default constructor.
 */
- (DCUrlConnection *) initWithUrl: (NSString *) aUrl;

/**
 * Factory method which generates a autorelease instance.
 */
+ (DCUrlConnection *) createWithUrl: (NSString *) aUrl;

/** \name Communicaton */

/**
 * Call this to post a message to the destination server. The bodyContent data will be set as the httpBodyContent
 * in the post message. The response is the raw stream returned by the server.
 * \param bodyContent a string containing the message to send via http post.
 * \param aErrorVar reference to an error variable that will be populated if an error occurs. This must be passed as `&aErrorVar`. In other words, the address of the error variable.
 * \see NSURLConnectionDelegate for details of how the response is assembled.
 */
- (NSData *) post: (NSString *) bodyContent errorVar:(NSError **) aErrorVar;

/** \name Additonal properties */

/**
 * Adds a header element to the message. Call before posting a message.
 */
- (void) setHeaderValue: (NSString *) value forKey: (NSString *) key;

/**
 * Sets the username and password to be used for encrypted connections.
 */
- (void) setUsername: (NSString *) aUsername password: (NSString *) aPassword;

@end