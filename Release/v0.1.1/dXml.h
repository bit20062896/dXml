//
//  dXml.h
//  dXml
//
// Useful macros.
//
//  Created by Derek Clarkson on 23/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import "DCXmlNode.h"

#ifdef DHC_DEBUG

/**
  * DHC_LOG is controlled by the DHC_DEBUG flag. If set, all DHC_LOG calls are converted into NSLog() calls.
  * If not set they are balnked out, producing no additional code. This makes life easy for developing because we
  * can be quite verbose without worrying about slowing the code down.
  */
#define DHC_LOG(s, ...) NSLog(@"%@:(%d) %@", [[NSString stringWithUTF8String: __FILE__] lastPathComponent],	\
										__LINE__, \
										[NSString stringWithFormat: (s), ## __VA_ARGS__])
#else
// Effective remove the logging.
#define DHC_LOG(s, ...)
#endif

/**
  * Wraps up some boiler plate code to dealloc an instance of a variable.
  */
#ifdef DHC_LOG_DEALLOCS

// Note. The do - while is so that macro defined variables
// have their own scope. This stops definition errors when the macro is used several times in a row.
#define DHC_DEALLOC(vName)	\
	do { \
		if (vName == nil) { \
			break; \
		} \
		id dobj = (id) vName; \
		if ([dobj retainCount] == INT_MAX) { \
			DHC_LOG(@"DHC_DEALLOC releasing static " # vName ": %@", dobj); \
			break; \
		} \
		if ([dobj isKindOfClass: [DCXmlNode class]]) {	\
			DCXmlNode *e = dobj; \
			DHC_LOG(@"DHC_DEALLOC releasing element " # vName ": %@", e.name); \
			break; \
		} \
		if ([dobj isKindOfClass: [NSData class]]) { \
			NSData *data = dobj;	\
			DHC_LOG(@"DHC_DEALLOC releasing " # vName ": %@", DHC_DATA_TO_STRING(data));	\
			break; \
		} \
		if (![dobj isKindOfClass: [NSDictionary class]] && ![dobj isKindOfClass: [NSArray class]]) {	\
			DHC_LOG(@"DHC_DEALLOC releasing " # vName ": %@", vName); \
			break; \
		} \
	} while (FALSE); \
	if (vName != nil) { \
		[vName release]; \
		vName = nil; \
	}
#else
#define DHC_DEALLOC(vName)	\
	if (vName != nil) { \
		[vName release]; \
		vName = nil; \
	}
#endif

// Trims whitespace from a string and returns a new string.
#define DHC_TRIM(string) [string stringByTrimmingCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]]

// Converts a boolean to a YES/NO string. Used in logging.
#define DHC_PRETTY_BOOL(bool) bool ? @"YES" : @"NO"

// Convert a NSData object to a NSString.
#define DHC_DATA_TO_STRING(data) [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]

// Convert a NSString to a NSData.
#define DHC_STRING_TO_DATA(string) [string dataUsingEncoding : NSUTF8StringEncoding]

// iPhone compatible mock arg define from OCMock. Need to post this to the author.
#define DHC_MOCK_VALUE(variable) [NSValue value : &variable withObjCType : @encode(__typeof__(variable))]

/**
 * Enum containing error codes returned from dXml classes.
 */
typedef enum {
	CannotSelectFromTextNode=1,
	NilConnection=2,
	EmptyResponse=3,
	NilResponse=4,
	SoapFault=5,
	TextNodePassedToNameFitler=6
}
DXmlErrorCode;

#define DXML_DOMAIN @"dXml:Errors"
