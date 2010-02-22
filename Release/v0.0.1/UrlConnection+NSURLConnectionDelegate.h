//
//  UrlConnection+NSURLConnectionDelegate.h
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlConnection.h"

/**
  * This category adds further functionality to a UrlConnection. The main purpose is to break the code base for
  * UrlConnection up into managable units. In this case we have a collection of delegate methods from NSURLConnection
  * which handle the responses from a url.
  * 
  * There is not a lot of code
  * here. Most of it is around two things: connection:didReceiveData: which is used to assemble the text contained
  * within an xml tag. And
  * connection:canAuthenticateAgainstProtectionSpace: which handles certificates and ssl security.
  */
@interface UrlConnection (NSURLConnectionDelegate)
- (NSURLRequest *) connection: (NSURLConnection *) connection willSendRequest: (NSURLRequest *) request redirectResponse: (NSURLResponse *) response;
- (BOOL) connection: (NSURLConnection *) connection canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *) protectionSpace;
- (NSInputStream *) connection: (NSURLConnection *) connection needNewBodyStream: (NSURLRequest *) request;
- (void) connection: (NSURLConnection *) connection didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge;
- (void) connection: (NSURLConnection *) connection didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge;
- (BOOL) connectionShouldUseCredentialStorage: (NSURLConnection *) connection;
- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response;
- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data;
- (void) connection: (NSURLConnection *) connection didSendBodyData: (NSInteger) bytesWritten totalBytesWritten: (NSInteger) totalBytesWritten totalBytesExpectedToWrite: (NSInteger) totalBytesExpectedToWrite;
- (void) connectionDidFinishLoading: (NSURLConnection *) connection;
- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error;
- (NSCachedURLResponse *) connection: (NSURLConnection *) connection willCacheResponse: (NSCachedURLResponse *) cachedResponse;

@end