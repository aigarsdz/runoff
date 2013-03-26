# runoff
## About

A few years ago I had enough of loosing my Skype chat history every time I reinstalled the operating system, so I decided to write a small application that could export it as plain text files. The application is called [SDBR](https://github.com/arvislacis/SDBR) and it is an open source project that I do not  maintain anymore. Why? I could say that I lost my interest in it, but the real reason probably is the implementation.

SDBR is written in C# using WPF, therefore it runs only on Windows. Moreover, it is a GUI application. Yeah, that's a problem, because you don't need the GUI for this kind of functionality. runoff is a commandline tool, that automates the process of exporting your chat history.

## Install

    gem install runoff

## Usage

To export all the chat history.

    # save all the files in your home directory
    runoff all skype_username

    # save the files in a specific directory
    runoff all skype_username -t ~/skype_backup

    # export database that isn't located in the default path
    runoff all -f ~/main.db -t ~/skype_backup

To export specific chats.

    runoff chat skype_username -t ~/skype_backup

If you're confused, you can get some help.

    runoff help all

## Problems

The current version (0.1.1) doesn't support Windows, but it will be fixed soon.

## What else?

Things to do in the future versions:

- Fix sqlite path bug in Windows.
- Append only new messages to the previously genetrated files instead of appending everything or create different versions for the files.
- Add some colors.

If you have something to say about this gem or anything else, you can find me on Twitter as [@AigarsDz](http://twitter.com/AigarsDz "@AigarsDz").