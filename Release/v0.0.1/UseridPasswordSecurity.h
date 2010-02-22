//
//  UseridPasswordSecurity.h
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Security.h"

@interface UseridPasswordSecurity : NSObject <SecurityModel>{
	@private
	NSString *userid;
	NSString *password;
}
- (UseridPasswordSecurity *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword;

@end