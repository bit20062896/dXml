---
layout: default
---
	  
# [dXml](http://github.com/drekka/dXml) 
by [Derek Clarkson](http://github.com/drekka) (d4rkf1br3 \[at\] gmail.com)

iPhone static library providing xml parsing into document models, XPath expressions, xml messaging to/from servers SOAP messaging to/from web service providers, SOAP fault handling.

It was written because I wanted to be able to talk to some SOAP based web services and found no support within the Apple SDK apart from the NSXMLParser class. 

## Dependencies

If you just want to use the static library then there are now dependencies.

If you wish to compile the code then you will need the following APIs:

[appledoc](http://github.com/tomaz/appledoc)

Appledoc runs and reads the output from doxygen, then reprocesses it to give it a more "Apple like" apperance before installing your api documentation as a docset in xcode.

[GH-Unit](http://github.com/gabriel/gh-unit)

GH-Unit is a JUnit style unit testing framework for iPhone applications. The advantages of it over the sen testing framework that comes with xcode is that it runs on the simulator, allows full debugging and is dead simple to use.

[OCMock](http://www.mulle-kybernetik.com/software/OCMock)

OCMock is a mocking framework very much like the java [EasyMock](http://easymock.org/) framework. It's a very useful tool for "simulating" instances of classes when testing.
    
##  Installation

Some sample code

{% highlight objc linenos %}
DCXmlNode *node = [DCXmlNode createWithName:@"abc"];
NSLog([node asPrettyXmlString]);
{% endhighlight %}

Some sample xml:

{% highlight xml linenos %}
<abc>
    <def>ghi</def>
</abc>
{% endhighlight %}

 
## License
    
## Download

You can downed the source as either

[![zip](http://github.com/images/modules/download/zip.png)](http://github.com/drekka/dXml/zipball/master)
or
[![tar](http://github.com/images/modules/download/tar.png)](http://github.com/drekka/dXml/tarball/master)

You can also clone the project with [git](http://git-scm.com)
by running:

<pre class="console">$ git clone git://github.com/drekka/dXml</pre>
      
    
