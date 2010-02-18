---
layout: default
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

You can cut and past this into a file and run it using GH-unit.

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
	if (response != nil){
		NSLog(@"Other error %@", error);
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
    
#  Installation

As this is a static library, adding it to your xcode project is quite simple. This assumes that you are working with one of the .dmg distribution files. Follow these steps:

1. Drag the contents of the .dmg distribution file into a folder on your system. For example ~/ext/api/dXml
1. Open your xcode project and navigate to Frameworks.
1. Add a new folder in Frameworks. This is not necessary but I'd recommend it because it helps keeps things organised. I'd call it dXml.
1. Open the installation folder in finder and select all the header files and the lib_dXml.a static library file and drag them to the newly created folder in xcode.
1. XCode will prompt as to whether you want to copy the files into the project. I generally say no.

Thats all that needs to be done.
 
# License

dXml is provided under a BSD License as follows:

Copyright (c) 2010, Derek Clarkson, dSoft
All rights reserved.

## Terms
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of the dSoft nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

## License

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    
# Download

You can download the source as either a zip or tar ball using these links

[![zip](http://github.com/images/modules/download/zip.png)](http://github.com/drekka/dXml/zipball/master)
or
[![tar](http://github.com/images/modules/download/tar.png)](http://github.com/drekka/dXml/tarball/master)

You can also clone the project with [git](http://git-scm.com) by running:

<pre class="console">$ git clone git://github.com/drekka/dXml</pre>
      
    
