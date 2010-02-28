---
layout: default
---

# Manipulating documents
	  
Lets go into some details about using the API to create and change document models. dXml's core document model class is **DCXmlNode**. 90% of the work you will do with dXml is done using DCXmlNode instances. 

You may notice from the dXml API that it is not especially strong on editing xml documents. It is mostly assumed that you will be either reading the xml from a source such as a web service or creating xml to be sent to one. So I have concentrated on the "C" and "R" parts of the CRUD acronym. Update and delete are not as often required and therefore there are not as many methods for them.

# Creating instances

As per most Cocoa APIs you have two choices in how you create instances of a class. Init methods for self managed memory handling, and factory methods for autoreleased instances. 

## Manually

Again like Cocoa, dXml uses initWith* constructors for self managed memory handling. Here's the list from DCXmlNode:

\- (DCXmlNode \*) initWithName:(NSString \*)aName;

\- (DCXmlNode \*) initWithName:(NSString \*)aName prefix:(NSString \*)aPrefix;

Because they are the init methods they only handle the basic requirements of creating instances of DCXmlNode. Namely that of creating an instance with a name for the xml element, and also creating one with a name and namespace prefix. So for example, creating a single node like this:

{% highlight objc linenos %}
DCXmlNode *element = [[DCXmlNode alloc] initWithName:@"abc" prefix:@"def"];
{% endhighlight %}

Would produce the following xml:

{% highlight xml linenos %}
<def:abc />
{% endhighlight %}

## Factory methods

The factory methods provide autorelease instances, which makes life easier. They also have a wider range of parameters and do more work. The ones that take values, for example, add DCTextNode sub nodes and set the values. A real time saver.

Here's the factory methods and the xml that the created DCXmlNode produces.

<table class="table examples">
   <tr class="header">
      <td class="headerCell">Factory method</td>
      <td class="headerCell">Xml</td>
   </tr>
   <tr class="row">
      <td class="cell">
{% highlight objc linenos %}
createWithName:@"abc"
{% endhighlight %}
   </td>
   <td class="cell">
{% highlight xml linenos %}
<abc />
{% endhighlight %}
		</td>
	</tr>
	<tr class="row">
		<td class="cell">
{% highlight objc linenos %}
createWithName:@"abc" prefix:@"def"
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<def:abc />
{% endhighlight %}
		</td>
	</tr>
	<tr class="row">
		<td class="cell">
{% highlight objc linenos %}
createWithName:@"abc" value:@"ghi"
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<abc>ghi</abc>
{% endhighlight %}
		</td>
	</tr>
	<tr class="row">
		<td class="cell">
{% highlight objc linenos %}
createWithName:@"abc" prefix:@"def" value:@"ghi"
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<def:abc>ghi</def:abc>
{% endhighlight %}
		</td>
	</tr>
</table>

As you would expect these return a autorelease instance of a DCXmlNode.

# Working with sub-nodes

## Creating
 
You have two choices when adding sub nodes, you can add either **DCXmlNode**s or **DCTextNode**s. The methods for doing this are almost the same as the factory methods, with the addition of one for creating DCTextNode sub nodes. Here's the list, I think you can figure this out yourself :-)

<table class="table examples">
	<tr class="header">
		<td class="headerCell">Sub node factory method</td>
		<td class="headerCell">xml produced when called on a <code>&lt;abc /&gt;</code> element.</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">
{% highlight objc linenos %}
[abcNode addXmlNodeWithName: @"def"];
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<abc>
	<def />
</abc>
{% endhighlight %}
		</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">
{% highlight objc linenos %}
[abcNode addXmlNodeWithName: @"def" prefix: @"ghi"];
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<abc>
	<ghi:def />
</abc>
{% endhighlight %}
		</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">
{% highlight objc linenos %}
[abcNode addXmlNodeWithName: @"def" value: @"lmn"];
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<abc>
	<def>lmn</def>
</abc>
{% endhighlight %}
		</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">
{% highlight objc linenos %}
[abcNode addXmlNodeWithName: @"def" prefix: @"ghi" value: @"lmn"];
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<abc>
   <ghi:def>lmn</ghi:def>
</abc>
{% endhighlight %}
		</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">
{% highlight objc linenos %}
[abcNode addTextNodeWithValue: @"lmn"];
{% endhighlight %}
		</td>
		<td class="cell">
{% highlight xml linenos %}
<abc>lmn</abc>
{% endhighlight %}
		</td>
	</tr>
</table>

Again like the factory methods they return a DCXmlNode or DCTextNode. Although in this case, it's a reference to the sub node that was created and added to the current node. Also note that because they are factory methods, you are not expected to manage memory for them, unless you intend to retain the references for other purposes.

## Finding nodes

I have added a variety of methods for finding and querying nodes. Note we will look at [XPath queries](xpathQueries.html) in another page.

<table class="table">
	<tr class="header">
		<td class="headerCell">Method</td>
		<td class="headerCell">Description</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">- (DCXmlNode *) xmlNodeWithName:(NSString *)aName;</td>
		<td class="cell">From the node you call this method on, locates the DCXmlNode with the passed name and returns it.</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">- (DCDMNode *) nodeAtIndex:(int)aIndex;</td>
		<td class="cell">Returns the sub node at the specific index. Indexes start at <strong>0</strong>. Notice that a <strong>DCDMNode</strong> instance is returned. Because the returned object could be either a DCXmlNode or DCTextNode, this returns the abstract parent class of both. To then use specific features of the returned class you will need to use <code>isKindOfClass:</code> to identify it and then case appropriately.</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">- (BOOL) hasXmlNodeWithName:(NSString *)aName;</td>
		<td class="cell">Returns YES if the current node has DCXmlNode sub node with the passed name.</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">- (NSArray *) nodes;</td>
		<td class="cell">Literally returns the array of sub nodes. At this stage it's a direct reference, but in future this may in fact clone the data.</td>
	</tr>
</table>

# Working with text values

Text values present some interesting challenges because of they way the can appear in the xml. With most xml used in soap and other data structures, a xml element will contain either one more sub xml elements, or a single text value. However it is possible for a xml element to have a mixed bunch of text and xml sub elements. Think html as a good source of examples. Html was the driver for the way in which I represented text by adding **DCTextNode**s and if you go on over to the [WC3School DOM pages](http://www.w3schools.com/htmldom/default.asp) you will see the same thing there as well. 

With dXml though, the emphasis was on working with xml data structures where typically a you see either xml sub nodes or a single text value. Like this:

{% highlight xml linenos %}
<abc>
   <def>ghi</def>
</abc>
{% endhighlight %}

So this presented some opportunities for creating some getters and setters. Although they follow the standard getter/setter method signatures, they operate slightly differently depending on how the model is currently setup. Particularly when there are multiple sub nodes. 

<table class="table">
	<tr class="header">
		<td class="headerCell">Method</td>
		<td class="headerCell">Description</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">- (NSString *) value;</td>
		<td class="cell">Returns the current text value of the DCXmlNode. This means it looks at the sub nodes and returns the text value of the first DCTextNode. This is based on the assumption that the most likely use of this is when dealing with xml data structures where any given xml node will only have a single text value. Any other DCTextNode nodes are ignored as are any DCXmlNode nodes.</td>
	</tr>
	<tr class="row">
		<td class="cell nowrap">- (void) setValue:(NSString *)value;</td>
		<td class="cell">Making the same assumptions as the getter, this sets the text value of the node. It does this by clearing the list of sub nodes and then adding a new DCTextNode with the passed value. If there is mode that one sub node, all nodes will be cleared before the new node is added.</td>
	</tr>
</table>

# Setting namespaces and attributes

In order to create correct xml with namespaces you need a way to define the namespaces. Mostly you would do this on the root elements of a document, but you can add it on any node. We also need a way to add attributes to xml declarations. Here's an example illustrating the setting of namespaces and attributes.


{% highlight objc linenos %}
DCXmlDocument *document = [DCXmlDocument createWithName: @"envelope" prefix: @"soap"];
[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
DCXmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
DCXmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
{% endhighlight %}

Here we have two namespace declarations being added. The first on the root element of the document and the second on the content element of the soap message. Then we also have an attribute being set on the root element. Here's what it produces.

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<soap:envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
   <soap:body>
      <m:GetLastTradePrice xmlns:m="http://trading-site.com.au" />
   </soap:body>
</soap:envelope>
{% endhighlight %}

Further to this is also the **defaultSchema** property which can be set like this.

{% highlight objc linenos %}
pre. DCXmlNode *element = [DCXmlNode createWithName:@"abc"];
element.defaultSchema = @"http://schema.com";
{% endhighlight %}

Which produces:

{% highlight xml linenos %}
<abc xmlns="http://schema.com" />
{% endhighlight %}

# Other methods

dXml has a range of other methods and properties which are available on the DCXmlNode class. Those listed here are the ones you are most likely to regularly use. Refer to the API documentation for details on the others.
