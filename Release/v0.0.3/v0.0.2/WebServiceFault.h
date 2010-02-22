//
//  SoapWebServiceFault.h
//  dXml
//
//  Created by Derek Clarkson on 30/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceResponse.h"
#import "XmlNode.h"

/**
 * Returned from a call to a web service when a soap fault occurs at the server end. 
 * \see SoapWebServiceConnection
 */
@interface WebServiceFault : WebServiceResponse {
}

/**
 * Gives direct access to the value of the soap fault code.
 */
- (NSString *) faultCode;

/**
 * Gives direct access to the value of the soap fault message.
 */
- (NSString *) message;

/**
 * If present, will return the XmlNode containing a server generated Java exception.
 * If this is not present this will return a nil value.
 */
- (XmlNode *) javaException;

@end