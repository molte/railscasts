require File.dirname(__FILE__) + '/../spec_helper'

describe Textilizer do
  def textilize(text, options = {})
    Textilizer.new(text, options = {}).to_html
  end
  
  it "should do basic textile" do
    textilize("hello *world*").should == "<p>hello <strong>world</strong></p>"
  end
  
  it "should wrap @@@ in a code block" do
    textilize("@@@\nfoo\n@@@", :allow_code => true).strip.should == CodeRay.scan('foo', nil).div(:css => :class).strip
  end
  
  it "should not process textile in code block" do
    textilize("@@@\nfoo *bar*\n@@@", :allow_code => true).strip.should == CodeRay.scan('foo *bar*', nil).div(:css => :class).strip
  end
  
  it "allow language for code block" do
    textilize("@@@ ruby\n@foo\n@@@", :allow_code => true).strip.should == CodeRay.scan('@foo', 'ruby').div(:css => :class).strip
  end
  
  it "allow code block in the middle" do
    textilize("foo\n@@@\ntest\n@@@\nbar", :allow_code => true).should include(CodeRay.scan('test', 'ruby').div(:css => :class).strip)
  end
  
  it "should handle \r in code block" do
    textilize("\r\n@@@\r\nfoo\r\n@@@\r\n", :allow_code => true).strip.should == CodeRay.scan('foo', nil).div(:css => :class).strip
  end
  
  it "should escape html tags if option is set" do
    textilize("*hello* <em>world</em>", :filter_markup => true).should = "<p><strong>hello</strong> &lt;em&gt;world&lt;/em&gt;</p>"
  end
  
  it "should leave html tags unless option is set" do
    textilize("*hello* <em>world</em>").should = "<p><strong>hello</strong> <em>world</em></p>"
  end
  
  it "should not allow code embed unless options is set" do
    textilize("@@@\nfoo\n@@@").strip.should == "<p>@@@<br />foo<br />@@@</p>"
  end
  
  it "should convert urls to html ancher tags" do
    textilize("This is a link: http://railscasts.com.").should == '<p>This is a link: <a href="http://railscasts.com">http://railscasts.com</a>.</p>'
  end
end
