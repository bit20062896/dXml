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
 * and to manage security. Here is a basic example of using this class
 * \code
 * NSString *request = @"&lt;?xml version=\"1.0\" encoding=\"UTF-8\"&gt;"
 *	@"&lt;soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"&gt;"
 *	@"&lt;soap:Body&gt;"
 *	@"&lt;dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\"&gt;"
 *	@"&lt;forAccountNumber&gt;1234&lt;/forAccountNumber&gt;"
 *	@"&lt;/dhc:balance&gt;"
 *	@"\n\t&lt;/soap:Body&gt;"
 *	@"\n&lt;/soap:Envelope&gt;";
 *
 * UrlConnection *connection = [UrlConnection createWithUrl: BANKING];
 * [connection setHeaderValue: BALANCE_ACTION forKey: @"SOAPAction"];
 * NSData *data = [connection post: request];
 * \endcode
 */
@interface UrlConnection:NSObject {
	@protected
	NSString *serverUrl;
	NSMutableDictionary *headers;
	NSMutableData *responseData;
	BOOL responseReceived;
	BOOL allowSelfSignedCertificates;
	BOOL storeCredentials;
	NSString *userid;
	NSString *password;
	NSError *error;
}

/**
 * This is the url that refers to the server.
 */
@property (nonatomic, readonly) NSString *serverUrl;

/**
 * If an error is detected during operations, it is stored in this property or accessing by the calling program.
 */
@property (nonatomic, readonly) NSError *error;

/**
 * If set to true, the UrlConnection will accept self signed cerificates from the server. This is most useful when
 * developing code
 * as the server can be on the developer's machine. This setting allows the developer to work without having to obtain
 * formal certifcates.
 */
@property (nonatomic) BOOL allowSelfSignedCertificates;

/**
 * If set to true, credentials are stored and reused.
 */
@property (nonatomic) BOOL storeCredentials;

/**
 * Default constructor.
 */
- (UrlConnection *) initWithUrl: (NSString *) aUrl;

/**
 * Factory method which generates a autorelease instance.
 */
+ (UrlConnection *) createWithUrl: (NSString *) aUrl;

/**
 * Call this to post a message to the destination server. The bodyContent data will be set as the httpBodyContent
 * in the post message. The response is the raw stream returned by the server.
 * \see NSURLConnectionDelegate for details of how the response is assembled.
 * \throws UrlConnectioNException if an error occurs.
 */
- (NSData *) post: (NSString *) bodyContent;

/**
 * Adds a header element to the message. Call before posting a message.
 */
- (void) setHeaderValue: (NSString *) value forKey: (NSString *) key;

/**
 * Sets the username and password to be used for encrypted connections.
 */
- (void) setUsername: (NSString *) aUsername password: (NSString *) aPassword;

@end