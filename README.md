# runoff
## About

A few years ago I had enough of loosing my Skype chat history every time I reinstalled the operating system, so I decided to write a small application that could export it as plain text files. The application is called [SDBR](https://github.com/arvislacis/SDBR) and it is an open source project that I do not  maintain anymore. Why? I could say that I lost my interest in it, but the real reason probably is the implementation.

SDBR is written in C# using WPF, therefore it runs only on Windows. Moreover, it is a GUI application. Yeah, that's a problem, because you don't need the GUI for this kind of functionality. runoff is a command-line tool, that automates the process of exporting your chat history.

## Install

    gem install runoff

## Usage

To export all the chat history.

    # save a Zip archive in your home directory
    runoff all skype_username

    # save a Zip archive in a specific directory
    runoff all skype_username -d ~/backups

    # export database that isn't located in the default path
    runoff all -f ~/main.db -d ~/backups

To export specific chats.

    runoff some skype_username

If you don't want to put files into an archive, use `--no-archive` option

    runoff all skype_username --no-archive

    runoff some skype_username --no-archive

## What else?

Things to do in the future versions:

Nothing. For now.

If you have something to say about this gem or anything else, you can find me on Twitter as [@aigarsdz](http://twitter.com/aigarsdz "@aigarsdz").
