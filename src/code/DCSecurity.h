//
//  SecurityImplementations.h
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlDocument.h"

//Common strings and values.
#define WSSECURITY_PREFIX @"wsse"
#define WSSECURITY_URL @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
#define WSSECURITY_UTILITY_PREFIX @"wsu"
#define WSSECURITY_UTILITY_URL @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
#define WSSECURITY_USERNAME_TOKEN_PROFILE_PASSWORDTEXT @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"

/**
 * Enum which specifies the type of security to be implemented.
 */
enum DCSecurityTypeEnum {

	/** No security is applied */
	NONE,
	/** basic userid and password security.*/
	BASIC_USERID_PASSWORD
};
typedef enum DCSecurityTypeEnum SECURITYTYPE;

/**
 * Any class that is used to setup security must implement this interface. This alls the connection classes to be agnostic about what security is being applied.
 */
@protocol DCSecurityModel

/**
 * Secures the passed soap message. Each security class will do this in a different way.
 */
- (void) secureSoapMessage: (DCXmlDocument *) soapMessage;

@end

/**
 * Security is the main factory class for applying security. Essentially you set it up with the security information you have then ask it to provide a security handler back. This handler can then be used to implement that style of security on the soap messages. Here is an example of how to use it:
 * \code
 * DCSecurity *security = [DCSecurity createSecurityWithUserid: userid password: password];
 * NSObject &lt;SecurityModel&ht; *securer = [security createSecurityModelOfType: securityType];
 * [securer secureSoapMessage: soapMsg];
 * \endcode
 * Security seperated into two parts to make it easy to use. The act of constructing an instance if Security also gives it the necessary data it needs to work with. ie.userid and password. The second part of getting the model and applying it to the message provides the flexibility of being able to aply different models as needed.
 */
@interface DCSecurity:NSObject {
	@private
	NSString *userid;
	NSString *password;
}

/** Constructors and factory methods */
/**
 * Default constructor. At this stage it simple takes a userid and password. As time goes on there will need to be other constructors which take other types of security information.
 */
- (DCSecurity *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword;

/**
 * Creates an autorelease instance of DCSecurity with the passed userid and password.
 */
+ (DCSecurity *) createSecurityWithUserid: (NSString *) aUserid password: (NSString *) aPassword;

/**
 * Called to obtain an instance of DCSecurityModel which implements the required security.
 */
- (NSObject <DCSecurityModel> *) createSecurityModelOfType: (SECURITYTYPE) securityType;

@end