//
//  SoapWebserviceTests.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "dXml.h"
#import <GHUnitIOS/GHUnitIOS.h>
#import <GHUnitIOS/GHUnitIOS.h>
#import <GHUnitIOS/GHUnitIOS.h>
#import <GHUnitIOS/GHUnitIOS.h>
#import <GHUnitIOS/GHUnitIOS.h>
#import <GHUnitIOS/GHUnitIOS.h>
#import "DCSoapWebServiceConnection.h"
#import "DCXmlDocument.h"
#import "IntegrationTestDefaults.h"
#import "NSError+SoapFault.h"

@interface DCSoapWebserviceIntegrationTests:GHTestCase
{
}
- (DCXmlNode *) createBalancePayload;
- (void) assertBalanceResponse: (DCWebServiceResponse *) response;
@end

@implementation DCSoapWebserviceIntegrationTests

- (void) testMsgUsingXmlString {
	NSString *xml = @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\">"
						 @"<forAccountNumber>1234</forAccountNumber>"
						 @"</dhc:balance>";

	DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];

	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];
	GHAssertNil(error, @"An error should not have been returned");
	[self assertBalanceResponse: response];
}

- (void) testMsgUsingXmlNodes {
	DCXmlNode *accountBalance = [self createBalancePayload];

	DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlNodePayload: accountBalance errorVar:&error];
	GHAssertNil(error, @"An error should not have been returned");
	[self assertBalanceResponse: response];
}

- (void) testSecureMsgUsingXmlNodes {
	DCXmlNode *accountBalance = [self createBalancePayload];

	DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlNodePayload: accountBalance errorVar:&error];
	GHAssertNil(error, @"An error should not have been returned");
	[self assertBalanceResponse: response];
}

- (void) testSoapFaultGeneral {
	//THis is an old format payload which no longer works. Now generates a soap fault.
	NSString *xml = @"<dhc:AccountBalance xmlns:dhc=\"" BASE_SCHEMA "\" />";

	DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];

	GHAssertNotNil(error, @"Nil error returned");
	GHAssertNil(response, @"Response returned when it should not be.");
	GHAssertEqualStrings(error.soapFaultCode, @"ns2:Client", @"Incorrect soap fault code returned"); 
	GHAssertEqualStrings(error.soapFaultMessage, @"Cannot find dispatch method for {http://www.dhcbank.com/banking/schema}AccountBalance", @"Incorrect soap fault code returned"); 
	
}

- (void) testSoapWithFaultCustomException {
	NSString *xml = @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\" />";

	DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];

	GHAssertNotNil(error, @"Nil error returned");
	GHAssertNil(response, @"Response returned when it should not be.");
	GHAssertEqualStrings(error.soapFaultCode, @"ns2:Server", @"Incorrect soap fault code returned"); 
	GHAssertEqualStrings(error.soapFaultMessage, @"No account number passed to service.", @"Incorrect soap fault code returned"); 
}

- (void) assertBalanceResponse: (DCWebServiceResponse *) response {
	GHAssertEqualStrings([response bodyContent].name, @"balanceResponse", @"Body content incorrect");
	GHAssertNotNil([[response bodyContent] xmlNodeWithName: @"balance"], @"Response not correct.");
	GHAssertNotNil([[response bodyContent] xmlNodeWithName: @"balance"].value, @"No balance amount");
}

- (DCXmlNode *) createBalancePayload {
	DCXmlNode *accountBalance = [[[DCXmlNode alloc] initWithName: @"balance" prefix: @"dhc"] autorelease];
	[accountBalance addNamespace: MODEL_SCHEMA prefix: @"dhc"];
	[accountBalance addXmlNodeWithName: @"forAccountNumber" prefix: nil value: @"1234"];
	return accountBalance;
}

@end