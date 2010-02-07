//
//  NSError+SoapFault.m
//  dXml
//
//  Created by Derek Clarkson on 18/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "NSError+SoapFault.h"
#import "dXml.h"


@implementation NSError (SoapFault)

- (BOOL) isSoapFault {
	return self.code == SoapFault && [self.domain isEqualToString:DXML_DOMAIN];
}

- (NSString *) soapFaultMessage {
	return [self.userInfo valueForKey:SOAP_FAULT_MESSAGE_KEY];
}

- (NSString *) soapFaultCode {
	return [self.userInfo valueForKey:SOAP_FAULT_CODE_KEY];
}

+ (NSError *) errorWithSoapResponse:(DCWebServiceResponse *)response {
	return [self errorWithSoapFault:[response bodyContent]];
}

+ (NSError *) errorWithSoapFault:(DCXmlNode *)fault {

	// Extract the message parts we want.
	NSString * message = [fault xmlNodeWithName:@"faultstring"].value;
	NSString * code = [fault xmlNodeWithName:@"faultcode"].value;

	DHC_LOG(@"Storing soap fault code   : %@", code);
	DHC_LOG(@"Storing soap fault message: %@", message);
	
	// Create the userinfo.
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];

	[dic setValue:code forKey:SOAP_FAULT_CODE_KEY];
	[dic setValue:message forKey:SOAP_FAULT_MESSAGE_KEY];

	// Return an error.
	return [NSError errorWithDomain:DXML_DOMAIN code:SoapFault userInfo:dic];
}


@end
