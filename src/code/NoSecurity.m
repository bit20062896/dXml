//
//  NoSecurity.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "NoSecurity.h"
#import "dXml.h"

@implementation NoSecurity

-(void) secureSoapMessage:(XmlDocument *) soapMessage {
	DHC_LOG (@"NO security - leaving soap message untouched.");
}

@end
