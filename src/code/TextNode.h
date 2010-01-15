//
//  TextNode.h
//  dXml
//
//  Created by Derek Clarkson on 13/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DMNode.h"

/**
 * Simple node which represents a string of text inside a XmlNode. The only things this class contains is the text string.
 */
@interface TextNode : DMNode {
	@private
	NSString * value;
}

/** \name Constructors */
/**
 * Default constructor. 
 */
-(TextNode *) initWithText:(NSString *) text;

/** \name Properties */
/** 
 * The string value.
 * For example in the xml
 * \code
 * &lt;abc&gt;<b>def</b>&lt;/abc&gt;
 * \endcode def is the value.  */
@property (nonatomic,retain) NSString * value;

@end
