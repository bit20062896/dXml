//
//  Security.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "Security.h"
#import "dXml.h"
#import "NoSecurity.h"
#import "UseridPasswordSecurity.h"

@implementation Security
- (Security *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword {
	self = [super init];
	if (self) {
		userid = [aUserid retain];
		password = [aPassword retain];
	}
	return self;
}

- (NSObject <SecurityModel> *) createSecurityModelOfType: (SECURITYTYPE) securityType {
	switch (securityType) {
	case NONE:
		return [[[NoSecurity alloc] init] autorelease];

	case BASIC_USERID_PASSWORD:
		return [[[UseridPasswordSecurity alloc] initWithUserid: userid password: password] autorelease];

	default:
		return nil;
	}
}

+ (Security *) createSecurityWithUserid: (NSString *) aUserid password: (NSString *) aPassword {
	return [[[Security alloc] initWithUserid: aUserid password: aPassword] autorelease];
}

- (void) dealloc {
	DHC_DEALLOC(userid);
	DHC_DEALLOC(password);
	[super dealloc];
}

@end