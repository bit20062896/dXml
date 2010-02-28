---
layout: default
---
	  
# Messaging URLs

The most simple way to send a message to a Url and retrieve a responses is with the **DCUrlConnection** class. It provides the ability to handle self signed certificates from servers (which is great for developers), userids and passwords, headers and posting requests to servers and returning the response as a NSData object. For SOAP messaging refer to the section on [SOAP messaging](messagingWebServices.html) and the **DCSoapWebServiceConnection** class which provides more facilities.

First here's some sample code which uses this class:

{% highlight objc linenos %}
// Setup a simple request.
NSString * request = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
   @"<SOAP-ENV:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
   @" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
   @" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\""
   @" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\""
   @" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">"
   @"<SOAP-ENV:Body>"
   @"<Hello xmlns=\"http://viium.com/\">"
   @"<name xsi:type=\"xsd:string\">Test</name>"
   @"</Hello>"
   @"</SOAP-ENV:Body>"
   @"</SOAP-ENV:Envelope>";

// Create the connection object.
DCUrlConnection * connection = [DCUrlConnection 
   createWithUrl:@"http://viium.com/WebService/HelloWorld.asmx"];
[connection setHeaderValue:@"http://viium.com/Hello" forKey:@"SOAPAction"];

// Call the service.
NSError * error = nil;
NSData * data = [connection post:request errorVar:&error];

// Error 
if (data == nil){
   NSLog(@"Error %@", error);
   return;
}

// Parse result into a document model.
DCXmlDocument * resultDoc = [[DCXmlParser parserWithData:data] parse:&error];

// Error
if (resultDoc == nil){
   NSLog(@"Error %@", error);
   return;
}

// Output
NSLog(@"Results: %@", [resultDoc asPrettyXmlString]);
{% endhighlight %}

This is not a really practical example. It's just to give you an idea of whats involved. Here the code follows these steps:

1. Setup a SOAP message.
1. Create a connection to a server.
1. Call the service and retrieve a NSData object containing the response.
1. Parse the response into xml.
1. Output to the log.

Also notice the error handling incase the connection or xml parsing has a problem.

