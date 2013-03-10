# runoff
## About

A few years ago I had enough of loosing my Skype chat history every time I reinstalled the operating system, so I decided to write a small application that could export it as plain text files. The application is called [SDBR](https://github.com/arvislacis/SDBR) and it is an open source project that I do not  maintain anymore. Why? I could say that I lost my interest in it, but the real reason probably is the implementation.

SDBR is written in C# using WPF, therefore it runs only on Windows. Moreover, it is a GUI application. Yeah, that's a problem, because you don't need the GUI for this kind of functionality. runoff is a commandline tool, that automates the process of exporting your chat history.

## Install

Sorry, this gem is still in development, therefore I haven't published it to RubyGems yet, but you can build it locally and install it that way.

## Usage

The current version only works with the default Skype location.

<pre><code>runoff all skype_username # this will save all the files in your home directory
</code></pre>

To export files to a specific directory you can use <code>--to</code> or <code>-t</code> option.

<pre><code>runoff all skype_username --to ~/skype_backup
</code></pre>

If you're confused, you can get some help.

<pre><code>runoff help all
</code></pre>

If you don't want to install the development version, clone down the repository and call the executable file directly!

<pre><code>ruby -Ilib ./bin/runoff.rb
</code></pre>

## What else?

Things to do before runoff is ready to be published:
- Add tests for the executable file.
- Use <code>--from</code>/<code>-f</code> option to specify the location of main.db file.
- Add comments to the code.

Things to do in the future versions:
- Add additional methods to export only specific conversations.
- Append only new messages to the previously genetrated files instead of appending everything.