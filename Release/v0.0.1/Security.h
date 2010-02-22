//
//  SecurityImplementations.h
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlDocument.h"

//Common strings and values.
#define WSSECURITY_PREFIX @"wsse"
#define WSSECURITY_URL @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
#define WSSECURITY_UTILITY_PREFIX @"wsu"
#define WSSECURITY_UTILITY_URL @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
#define WSSECURITY_USERNAME_TOKEN_PROFILE_PASSWORDTEXT @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"

enum SecurityTypeEnum {
	NONE,
	BASIC_USERID_PASSWORD
};
typedef enum SecurityTypeEnum SECURITYTYPE;

@protocol SecurityModel

- (void) secureSoapMessage: (XmlDocument *) soapMessage;

@end

@interface Security : NSObject {
	@private
	NSString *userid;
	NSString *password;
}
+ (Security *) createSecurityWithUserid: (NSString *) aUserid password: (NSString *) aPassword;
- (Security *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword;
- (NSObject <SecurityModel> *) createSecurityModelOfType: (SECURITYTYPE) securityType;

@end