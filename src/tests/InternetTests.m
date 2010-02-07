//
//  InternetTests.m
//  dXml
//
//  Created by Derek Clarkson on 22/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import "GHUnit.h"
#import "DCUrlConnection.h"
#import "dXml.h"
#import "DCXmlParser.h"
#import "DCXmlDocument.h"
#import "DCXmlNode+AsString.h"

@interface InternetTests : GHTestCase
{}

@end


@implementation InternetTests

- (void) testViiumCom {
	NSString *validRequest = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	   @"<SOAP-ENV:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
	   @" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
	   @" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\""
	   @" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\""
	   @" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">"
	   @"<SOAP-ENV:Body>"
	   @"<Hello xmlns=\"http://viium.com/\">"
	   @"<name xsi:type=\"xsd:string\">dXml</name>"
	   @"</Hello>"
	   @"</SOAP-ENV:Body>"
	   @"</SOAP-ENV:Envelope>";

	DCUrlConnection *connection = [DCUrlConnection createWithUrl:@"http://viium.com/WebService/HelloWorld.asmx"];

	[connection setHeaderValue:@"http://viium.com/Hello" forKey:@"SOAPAction"];
	NSError *error = nil;
	NSData *data = [connection post:validRequest errorVar:&error];
	GHAssertNil(error, @"An error should not have been generated");

	DCXmlDocument *resultDoc = [[DCXmlParser parserWithData:data] parse:&error];
	GHAssertNil(error, @"An error should not have been generated");
	GHAssertEqualStrings([[[resultDoc xmlNodeWithName:@"Body"] xmlNodeWithName:@"HelloResponse"] xmlNodeWithName:@"HelloResult"].value, @"Hello dXml", @"Incorrect response received");

}

- (void) testViiumComBlankFromInvalidREquestCausesError {
	
	//Viium will generate an empty response if there are no spaces between the namespace declarations. This hould be
	// turned into a NSError.
	NSString *validRequest = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	@"<SOAP-ENV:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
	@"xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
	@"xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\""
	@"SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\""
	@"xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">"
	@"<SOAP-ENV:Body>"
	@"<Hello xmlns=\"http://viium.com/\">"
	@"<name xsi:type=\"xsd:string\">dXml</name>"
	@"</Hello>"
	@"</SOAP-ENV:Body>"
	@"</SOAP-ENV:Envelope>";
	
	DCUrlConnection *connection = [DCUrlConnection createWithUrl:@"http://viium.com/WebService/HelloWorld.asmx"];
	
	[connection setHeaderValue:@"http://viium.com/Hello" forKey:@"SOAPAction"];
	NSError *error = nil;
	NSData *data = [connection post:validRequest errorVar:&error];
	GHAssertNil(data, @"Data should be nil");
	GHAssertNotNil(error, @"An error should not have been generated");
	GHAssertEqualStrings(error.domain, @"dXml:Errors", @"Incorrect error returned");
	GHAssertEquals(error.code, EmptyResponse, @"Incorrect error returned");
	
}

@end
