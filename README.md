# runoff
## About

A few years ago I had enough of loosing my Skype chat history every time I reinstalled the operating system, so I decided to write a small application that could export it as plain text files. The application was called SDBR and it was an open source project that I do not  maintain anymore. Why? I could say that I lost my interest in it, but the real reason probably is the implementation.

SDBR was written in C# using WPF, therefore it ran only on Windows. Moreover, it was a GUI application. Yeah, that's a problem, because you don't need the GUI for this kind of functionality. runoff is a command-line tool, that automates the process of exporting your chat history.

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

If you don't want to put files into an archive, use `--no-archive` option.

    runoff all skype_username --no-archive

    runoff some skype_username --no-archive

Sometimes you might want to use the exported data in a different app, therefore runoff has an option to export in JSON instead of TXT. You just need to specify an adapter using `-A` option.

    runoff all skype_username -A json

The resulting JSON file contains an array of objects with 3 keys: `date`, `user` and `message`. Each object represents a single chat record.

## What else?

Things to do in the future versions:

- Parse all of XML specific things in the message.
- Output how many files have been exported.

If you have something to say about this gem or anything else, you can find me on Twitter as [@aigarsdz](http://twitter.com/aigarsdz "@aigarsdz").
