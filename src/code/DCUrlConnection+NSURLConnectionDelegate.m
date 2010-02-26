//
//  UrlConnection+NSURLConnectionDelegate.m
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCUrlConnection+NSURLConnectionDelegate.h"
#import "dXml.h"

@implementation DCUrlConnection (NSURLConnectionDelegate)
- (NSURLRequest *) connection: (NSURLConnection *) connection willSendRequest: (NSURLRequest *) request redirectResponse: (NSURLResponse *) response {
	DHC_LOG(@"Event-willSendRequest, Url: %@", [request URL]);
	DHC_LOG( @"Request body:\n%@", DHC_DATA_TO_STRING([request HTTPBody]) );
	return request;
}

- (BOOL) connection: (NSURLConnection *) connection canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *) protectionSpace {
	DHC_LOG(@"Event-canAuthenticateAgainstProtectionSpace");
	DHC_LOG(@"Authentication method        : %@", protectionSpace.authenticationMethod);
	DHC_LOG(@"Host                         : %@", protectionSpace.host);
	DHC_LOG(@"Port                         : %i", protectionSpace.port);
	DHC_LOG(@"Protocol                     : %@", protectionSpace.protocol);
	DHC_LOG(@"realm                        : %@", protectionSpace.realm);
	DHC_LOG(@"Receives credentials securely: %@", DHC_PRETTY_BOOL(protectionSpace.receivesCredentialSecurely));
	DHC_LOG(@"Server trust                 : %@", protectionSpace.serverTrust);
	DHC_LOG(@"Authentication method: %@", protectionSpace.authenticationMethod);
	DHC_LOG( @"Allowing self signed certificates: %@", DHC_PRETTY_BOOL(self.allowSelfSignedCertificates) );
	return self.allowSelfSignedCertificates;
}

- (NSInputStream *) connection: (NSURLConnection *) connection needNewBodyStream: (NSURLRequest *) request {
	DHC_LOG(@"Event-needNewBodyStream");
	return nil;
}

- (void) connection: (NSURLConnection *) connection didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge {
	DHC_LOG(@"Event-didReceiveAuthenticationChallenge");
	DHC_LOG(@"Challenger previous failure count: %i", challenge.previousFailureCount);
	DHC_LOG(@"Challenger proposed credential   : %@", challenge.proposedCredential);
	
	//If never been challenged, create a new set of credentials and submit them.
	if ([challenge previousFailureCount] == 0) {
		DHC_LOG(@"Telling sender to use new credentials with our userid and password.");
		NSURLCredential *newCredentials = [NSURLCredential credentialWithUser: userid password: password persistence: NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential: newCredentials forAuthenticationChallenge: challenge];
	}
	else {
		//Otherwise fail the access attempt.
		DHC_LOG(@"Telling sender to cancel the challenge.");
		[[challenge sender] cancelAuthenticationChallenge: challenge];
	}
}

- (void) connection: (NSURLConnection *) connection didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge {
	DHC_LOG(@"Event-didCancelAuthenticationChallenge");
}

- (BOOL) connectionShouldUseCredentialStorage: (NSURLConnection *) connection {
	DHC_LOG(@"Event-connectionShouldUseCredentialStorage: %@", DHC_PRETTY_BOOL(self.storeCredentials) );
	return self.storeCredentials;
}

- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response {
	DHC_LOG(@"Event-didReceiveResponse");
}

- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data {
	DHC_LOG(@"Event-didReceiveData: %@", DHC_DATA_TO_STRING(data));
	[responseData appendData: data];
	responseDataReceived = YES;
}

- (void) connection: (NSURLConnection *) connection didSendBodyData: (NSInteger) bytesWritten totalBytesWritten: (NSInteger) totalBytesWritten totalBytesExpectedToWrite: (NSInteger) totalBytesExpectedToWrite {
	DHC_LOG(@"Event-didSendBodyData");
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection {
	DHC_LOG(@"Event-connectionDidFinishLoading");
	responseReceived = YES;
}

- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) aError {
	DHC_LOG(@"Event-didFailWithError, error: %@", aError);
	delegateError = [aError retain];
	responseReceived = YES;
}

- (NSCachedURLResponse *) connection: (NSURLConnection *) connection willCacheResponse: (NSCachedURLResponse *) cachedResponse {
	DHC_LOG(@"Event-willCacheResponse");
	return nil;
}

@end