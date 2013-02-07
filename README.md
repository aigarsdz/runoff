# runoff

I just don't know how to write a README before the project is finished, but I can give you some ideas, what this is all about.

Two years ago I had enough of loosing my Skype chat history every time I reinstalled the operating system, so I decided to write a small application that could export it as plain text files. The application is called [SDBR](https://github.com/arvislacis/SDBR) and it is an open source project that I do not  maintain anymore. Why? I could say that I lost my interest in it, but the real reason probably is the implementation.

SDBR is written in C# using WPF, therefore it runs only on Windows. Moreover, it is a GUI application. Yeah, that's a problem, because you don't need the GUI for this kind of functionality. runoff is going to be a commandline tool, that will automate the process of exporting your chat history. That's it. For now.