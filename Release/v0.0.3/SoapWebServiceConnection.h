//
//  SoapWebservice.h
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"
#import "WebServiceResponse.h"
#import "dXml.h"
#import "XmlParser.h"
#import "NSObject+SoapTemplates.h"
#import "Security.h"
#import "UrlConnection.h"

/**
 * Enum which specifies error codes.
 */
typedef enum {
	SoapWebServiceConnectionNilResponse=1
}
SoapWebServiceConnectionErrorCode;

/**
 * Extension of the UrlConnection class which is specially designed to handle soap web service calls to servers.
 * This class is the main class of the dXml API.
 * Here's an example of using it
 * \code
 * // Simple request for data with no security.
 * NSString *xml = @"&lt;dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\"&gt;"
 *                 @"&lt;forAccountNumber&gt;1234&lt;/forAccountNumber&gt;"
 *                 @"&lt;/dhc:balance&gt;";
 * 
 * // Create the service.
 * NSString *url = @"http://localhost:8080/services/Banking";
 * NSString *action = @"\"http://www.dhcbank.com/banking/balance\"";
 * SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: url soapAction: action];
 * 
 * // And call it.
 * NSError *error = nil;
 * WebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];
 * 
 * if (error != nil) {
 *		// Handle the error.
 * }
 * 
 * // And do something with the response.
 * \endcode
 */
@interface SoapWebServiceConnection : UrlConnection {
	@private
	NSString * soapAction;
	SECURITYTYPE securityType;
}

/** \name Properties */

/**
 * The specific soap action to call
 */
@property (nonatomic,retain) NSString * soapAction;

/**
 * Indicates the security tpe to apply to the connection.
 */
@property (nonatomic) SECURITYTYPE securityType;

/** \name Factory methods */

/**
 * Constructor which accepts just a url.
 * \param aServerUrl the url of the destination server.
 */
+(SoapWebServiceConnection *) createWithUrl:(NSString *) aServerUrl;

/**
 * Constructor which accepts a url and action.
 * \param aServerUrl the url of the destination server.
 * \param aSoapAction the soap action to call.
 */
+(SoapWebServiceConnection *) createWithUrl:(NSString *) aServerUrl soapAction:(NSString *) aSoapAction;

/** \name Interactions */

/**
 * Uses http POST to send the soap message to the server and returns the response.
 * \param aBody The payload/Body content to be sent, represented by XmlNode datagraph.
 * \param aErrorVar a reference to the a NSError that can be populated if there is an error. This must be passed by reference using `&aErrorVar`. 
 */
-(WebServiceResponse *) postXmlNodePayload:(XmlNode *) aBody errorVar:(NSError **) aErrorVar;

/**
 * Uses http POST to send the soap message to the server and returns the response.
 * \param aBody The payload/Body content to be sent, represented by NSString.
 * \param aErrorVar a reference to the a NSError that can be populated if there is an error. This must be passed by reference using `&aErrorVar`. 
 * \see SoapWebServiceConnection
 */
-(WebServiceResponse *) postXmlStringPayload:(NSString *) aBody errorVar:(NSError **) aErrorVar;
@end