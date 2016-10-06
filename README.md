# How to Parse HTML on iOS

from : https://www.raywenderlich.com/14172/how-to-parse-html-on-ios

*This is a blog post by iOS Tutorial Team member Matt Galloway, founder of SwipeStack, a mobile development team based in London, UK. You can also find me on Google+.*

I refer to the above code, and made some modifications

#### modify：

Change HTTP for HTTPS  

Set the imageView's UITableViewCell to the relevant author's Avatar, Also need to optimize performance 



更改HTTP链接为HTTPS

设置UITableViewCell的imageView为相关作者头像，但是还需要优化性能，因为每一次调用cell都需要转换，应该在ViewDidLoad中完成

