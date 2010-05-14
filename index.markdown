---
layout: default
title:  Index
---

<div class="title">
	<a href="http://github.com/drekka/dXml">dXml</a>
</div> 

by [Derek Clarkson](http://github.com/drekka) (d4rkf1br3 \[at\] gmail.com)

dXml is an iPhone static library providing xml parsing into document models, XPath expressions, xml messaging to/from servers SOAP messaging to/from web service providers and SOAP fault handling.

It was written because I wanted to be able to talk to some SOAP based web services and found no support within the Apple SDK apart from the NSXMLParser class. 

Currently it provides the following features:

* A document model for creating and manipulating xml structures.
* Document model to xml NSString generation including pretty printing for logging purposes.
* Interrogation of the document model via xpath requests.
* Parsing of NSData, NSURL and NSString containing xml into the document model.
* Sending of xml messages via post to any url and converting the results to the document model.
* Sending soap web service messages to any web service and processing the results into a soap response.
* Conversion of soap faults to NSError objects.

# A quick example

To give you an idea of how simple dXml makes working with SOAP, here is a quick example which does the following:

1. Setup a connection to a web service.
1. Post a SOAP message to the service and retrieve the reply.
1. Check the reply for errors.
1. Pretty print the response SOAP message to the log.

You can cut and past this into a file and run it using [GH-Unit](http://github.com/gabriel/gh-unit).

{% highlight objc linenos %}
#import "GHUnit.h"
#import "DCSoapWebServiceConnection.h"
#import "dXml.h"
#import "DCXmlNode+AsString.h"

@interface InternetTests : GHTestCase
{}

@end

@implementation InternetTests

- (void) testViiumCom {

   // The request.
   NSString * request = 
      @"<Hello xmlns=\"http://viium.com/\">"
      @"<name xsi:type=\"xsd:string\">Test</name>"
      @"</Hello>";

   // Setup the connection.
   DCSoapWebServiceConnection * connection = [DCSoapWebServiceConnection 
      createWithUrl:@"http://viium.com/WebService/HelloWorld.asmx" 
      soapAction:@"http://viium.com/Hello"];

   // Make the request and get the response.
   NSError * error = nil;
   DCWebServiceResponse * response = [connection postXmlStringPayload:request errorVar:&error];

   // Error check.
   if (response == nil){
      NSLog(@"Error %@", error);
      return;
   }

   // Log output.
   NSLog(@"Results: %@", [[response bodyContent] asPrettyXmlString]);

}

@end
{% endhighlight %}

This is a very simple example. More typically you would be parsing the xml string into a document and then setting values first. Also note that whilst not obvious, dXml is parsing the response from the web service into it's own document model and storing it inside the response object. Another point of interest is the error handling. Very simple here, but usually you would use methods from a category dXml applies to the NSError class which can tell you if there is a SOAP fault and provide the data from it.

# Dependencies

If you just want to use the static library then there are no dependencies.

If you wish to compile the code then you will need the following APIs:

[appledoc](http://github.com/tomaz/appledoc)

Appledoc runs and reads the output from doxygen, then reprocesses it to give it a more "Apple like" apperance before installing your api documentation as a docset in xcode.

[GH-Unit](http://github.com/gabriel/gh-unit)

GH-Unit is a JUnit style unit testing framework for iPhone applications. The advantages of it over the sen testing framework that comes with xcode is that it runs on the simulator, allows full debugging and is dead simple to use.

[OCMock](http://www.mulle-kybernetik.com/software/OCMock)

OCMock is a mocking framework very much like the java [EasyMock](http://easymock.org/) framework. It's a very useful tool for "simulating" instances of classes when testing.

Please refer to the [Building dXml](building.html) page for details on building dXml.
    
 

