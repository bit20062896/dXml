---
layout: default
---

# Creating documents
	  
Creating documents using dXmls document model is quite simply. Note though, this is not a implementation of the [W3CSchool's DOM](:http://www.w3schools.com/dom/default.asp) although there are some similarities. It has originated by simply trying to think of how a developer might like to express himself in code. Hopefully you like the way it works :-) 

# Lego blocks

Not really, but like the W3CSchool's DOM we have a set of classes that every document is built from. They are:

**DCXmlNode** - the main building block of the model. Represents a xml element and stores information such as namespaces, attributes, sub nodes, name, etc.

**DCTextNode** - used exclusively to hold blocks of text. Always has a DCXmlNode as a parent node.

**DCXmlDocument** - used only to represent the root or top node of a document model. This is an extension of the DCXmlNode and therefore has all of it's functionality.

# Creating a document from raw xml

Perhaps the simplest way to do this. The source can be a NSString \*, NSData \* or a NSURL \*. Note the inclusion of NSString which is not normally available in the iPhone sdk. here's an example of creating a document from a xml source stored in a NSString. As a developer you will quite likely being doing this in your unit testing, you do unit test - right?

{% highlight objc linenos %}
const NSString * WEB_SERVICE_XML = 
   @"<?xml version="\1.0\" encoding=\"UTF-8\"?>"
   @"<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""
   @" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
   @"<soap:body>"
   @"<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
   @"<symbol>MOT</symbol>"
   @"</m:GetLastTradePrice>"
   @"</soap:body>"
   @"</soap:envelope>";
    
DCXmlParser *parser = [DCXmlParser parserWithXml: xml];
NSError *error = nil;
DCXmlDocument *xmlDoc = [parser parse:&error];
    
if (xmlDoc == nil) {
   //Deal with the error
}
{% endhighlight %}

Ignore the funny outlines as it's the way this wiki works when it encounters blank lines in code. Although hopefully any _good_ code will be formatted into logical blocks which this will highlight anyway.

Ok, so the first block is simply a hard coded piece of xml which is a soap messages to a web service. The second block is where we create a xml parser and tell it to parse the xml. The third block is simply an error handling block. Note that we are making use of the recommended error handling methods as specified by Apple.

The advantages of creating xml documents via this method is simplicity. It's easy for you to craft up the desired xml and the parse it into the document model. From there you can send it or modify it further as you desire. The disadvantage of this method is that in order to get the document model, dXml must invoke a NSXMLParser and parse the text, creating document model objects and assembling them as it goes. This obviously has a CPU and memory cost.

# Creating a document using the API

This method is a simpler one, however it's perhaps less intuitive. Here's the same example from above done using the dXml API:

{% highlight objc linenos %}
DCXmlDocument *document = [DCXmlDocument createWithName: @"envelope" prefix: @"soap"];
[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
DCXmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
DCXmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
[getLastTradePriceElement addXmlNodeWithName: @"symbol" value: @"MOT"];
    
DCXmlParser *parser = [DCXmlParser parserWithXml: xml];
NSError *error = nil;
DCXmlDocument *xmlDoc = [parser parse:&error];
    
if (xmlDoc == nil) {
   //Deal with the error
}
{% endhighlight %}

It's not as easy to read, but once you get the hang of the API it's very easy to use. Plus there are a lot of features not shown in this example. 

Looking through this you can see that I've attempted to make the methods and parameters as English like as possible. The idea being to make it easy to remember and use. For example `[document addXmlNodeWithName: @"body" prefix: @"soap"]` is clear about the fact that it's going to create a DCXmlNode with a name of "body" and a namespace prefix of "soap". And being a factory method, you can safely assume it will be returned a autorelease instance as well.
