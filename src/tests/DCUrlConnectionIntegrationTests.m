//
//  UrlConnectionTests.m
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import "GHUnit.h"
#import "DCUrlConnection.h"
#import "IntegrationTestDefaults.h"
#import "dXml.h"

@interface DCUrlConnectionIntegrationTests:GHTestCase {
}
@end

@implementation DCUrlConnectionIntegrationTests

- (void) tearDown {
	DHC_LOG(@"TearDown executing");
	[super tearDown];
}

- (void) testErrorHandling {
	NSString *request = @"";

	DCUrlConnection *connection = [DCUrlConnection createWithUrl: INVALID_SERVER];
	[connection setHeaderValue: BALANCE_ACTION forKey: @"SOAPAction"];
	NSError *error = nil;
	NSData *data = [connection post: request errorVar:&error];
	GHAssertNotNil(error, @"An error was not returned");
	GHAssertEquals(error.code, -1004, @"Incorrect code");
	GHAssertEqualStrings(error.domain, @"NSURLErrorDomain", @"Incorrect code");
	GHAssertNil(data, @"Data should not have been returned");
}

- (void) testErrorHandlingIgnoresErrors {
	NSString *request = @"";
	
	DCUrlConnection *connection = [DCUrlConnection createWithUrl: INVALID_SERVER];
	[connection setHeaderValue: BALANCE_ACTION forKey: @"SOAPAction"];
	NSData *data = [connection post: request errorVar:NULL];
	GHAssertNil(data, @"Data should not have been returned");
}

- (void) testNoSecurity {
	NSString *request = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							  @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
							  @"<soap:Body>"
							  @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\">"
							  @"<forAccountNumber>1234</forAccountNumber>"
							  @"</dhc:balance>"
							  @"\n\t</soap:Body>"
							  @"\n</soap:Envelope>";
	NSString *expectedResponse =
		@"<?xml version='1.0' encoding='UTF-8'?>"
		@"<S:Envelope xmlns:S=\"http://schemas.xmlsoap.org/soap/envelope/\">"
		@"<S:Body>"
		@"<ns2:balanceResponse xmlns:ns2=\"http://www.dhcbank.com/banking/model\">"
		@"<balance>3904.63</balance>"
		@"</ns2:balanceResponse>"
		@"</S:Body>"
		@"</S:Envelope>";

	DCUrlConnection *connection = [DCUrlConnection createWithUrl: BANKING];
	[connection setHeaderValue: BALANCE_ACTION forKey: @"SOAPAction"];
	NSError *error = nil;
	NSData *data = [connection post: request errorVar:&error];

	//Validate.
	GHAssertNotNil(data, @"Nil data returned");
	GHAssertNil(error, @"Error returned");
	int dataLength = [data length];
	GHAssertGreaterThan(dataLength, 0, @"No data in data");
	GHAssertEqualStrings(DHC_DATA_TO_STRING(data), expectedResponse, @"Response not correct");
}

- (void) testWithSecurityAcceptsSSCs {
	NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
						 @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
						 @"<soap:Header>"
						 @"<wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">"
						 @"<wsse:UsernameToken xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"UsernameToken\">"
						 @"<wsse:Username>fred</wsse:Username>"
						 @"<wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">fred</wsse:Password>"
						 @"</wsse:UsernameToken>"
						 @"</wsse:Security>"
						 @"</soap:Header>"
						 @"<soap:Body>"
						 @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\">"
						 @"<forAccountNumber>1234</forAccountNumber>"
						 @"</dhc:balance>"
						 @"\n\t</soap:Body>"
						 @"\n</soap:Envelope>";
	DCUrlConnection *connection = [DCUrlConnection createWithUrl: BANKING_SECURE];
	connection.allowSelfSignedCertificates = YES;
	[connection setHeaderValue: BALANCE_ACTION forKey: @"SOAPAction"];
	NSError *error = nil;
	NSData *data = [connection post: xml errorVar:&error];

	//Validate.
	GHAssertNotNil(data, @"Nil data returned");
	GHAssertNil(error, @"Error returned");
	int dataLength = [data length];
	GHAssertGreaterThan(dataLength, 0, @"No data in data");
}
/*
- (void) testWithSecurityNotSSCs {
	NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
	@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
	@"<soap:Header>"
	@"<wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">"
	@"<wsse:UsernameToken xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"UsernameToken\">"
	@"<wsse:Username>fred</wsse:Username>"
	@"<wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">fred</wsse:Password>"
	@"</wsse:UsernameToken>"
	@"</wsse:Security>"
	@"</soap:Header>"
	@"<soap:Body>"
	@"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\">"
	@"<forAccountNumber>1234</forAccountNumber>"
	@"</dhc:balance>"
	@"\n\t</soap:Body>"
	@"\n</soap:Envelope>";
	DCUrlConnection *connection = [DCUrlConnection createWithUrl: BANKING_SECURE];
	[connection setHeaderValue: BALANCE_ACTION forKey: @"SOAPAction"];
	NSError *error = nil;
	NSData *data = [connection post: xml errorVar:&error];
	
	//Validate.
	GHAssertNotNil(data, @"Nil data returned");
	GHAssertNil(error, @"Error returned");
	int dataLength = [data length];
	GHAssertGreaterThan(dataLength, 0, @"No data in data");
}
*/
@end