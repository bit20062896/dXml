//
//  SoapWebservice.h
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceResponse.h"
#import "XmlNode.h"
#import "Security.h"
#import "UrlConnection.h"
#import "WebServiceResponse.h"
#import "WebServiceFault.h"
#import "dXml.h"
#import "XmlParser.h"
#import "NSObject+SoapTemplates.h"
#import "Security.h"
#import "WebServiceException.h"
#import "UrlConnection.h"
#import "XmlException.h"


/**
 * Extension of the UrlConnection class which is specially designed to handle soap web service calls to servers.
 * This class is the main class of the dXml API.
 * Here's an example of using it
 * \code
 * // Simple request for data with no security.
 * NSString *xml = @"&lt;dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\"&gt;"
 *                 @"&lt;forAccountNumber&gt;1234&lt;/forAccountNumber&gt;"
 *                 @"&lt;/dhc:balance&gt;";
 * &nbsp;
 * // Create the service.
 * NSString *url = @"http://localhost:8080/services/Banking";
 * NSString *action = @"\"http://www.dhcbank.com/banking/balance\"";
 * SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: url soapAction: action];
 * &nbsp;
 * // And call it.
 * WebServiceResponse *response = [service postXmlStringPayload: xml];
 * &nbsp;
 * // And do something with the response.
 * \endcode
 */
@interface SoapWebServiceConnection : UrlConnection {
	@private
	NSString * soapAction;
	SECURITYTYPE securityType;
}

/**
 * The specific soap action to call
 */
@property (nonatomic,retain) NSString * soapAction;

/**
 * Indicates the security tpe to apply to the connection.
 */
@property (nonatomic) SECURITYTYPE securityType;

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

/**
 * Uses http POST to send the soap message to the server and returns the response.
 * \param aBody The payload/Body content to be sent, represented by XmlNode datagraph.
 */
-(WebServiceResponse *) postXmlNodePayload:(XmlNode *) aBody;

/**
 * Uses http POST to send the soap message to the server and returns the response.
 * \param aBody The payload/Body content to be sent, represented by NSString.
 * \see SoapWebServiceConnection
 */
-(WebServiceResponse *) postXmlStringPayload:(NSString *) aBody;
@end
