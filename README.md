<div align="center"><h1> Ah yes, another TODO program (but in Haskell!)</h1></div>

<div align="center">
That's about it. A to-do program written in Haskell. I know my code is weird, and you're welcome to
crack your head through it (otherwise I'll do it myself eventually).
</div>

# Installation

After pulling this repository,
```
$ cabal install
```

Or if you don't want cabal, just:
```
$ cd app
$ ghc --make Main.hs
```

# Usage

## Commands


Todo can be run just with
```
todo
```
This will launch the interactive mode of the program.


Todo also supports CLI parameters. Here they are:
```
todo [add/remove/view] [filename] [parameter for first argument]
```

Todo uses the file `~/.config/todo.txt` as default. The main commands are:


WARNING: Currently, TODO only supports filenames ending with `.txt`, otherwise your filename will be treated as a TODO and be added
to the default list!

```
todo add         #Adds TODOs to your list.
todo view        #Prints out your todo list.
todo remove      #Removes TODOs from your list.
todo version     #Prints out version.
todo help        #Prints out help message.
```

These commands are self-explanatory.

## Subcommands

### Add
The parameters for add are just the filename and things you want to add to your TODO list.

For example
```
todo add "Say hello to the world"
```
Will add "Say hello to the world" to your default TODO list.



To add your TODO to a different file (you guessed it):

```
todo add helloworld.txt "Say hello to the world"
```

This will create a helloworld.txt file in the current directory if it doesn't exist, otherwise add the string to your list.



You can also add multiple TODOs with a single command like this:
```
todo add "Foo" "Bar" "Baz"
```

### Remove
The parameters for remove are the filename, and the number at which the to-be-removed TODO is at, 
and/or a simple phrase that the to-be-removed TODO contains.

An example with indexes as the parameter:


<img src="/images/removeindex.png">


An example with keywords as the parameter:


<img src="/images/removekeywords.png">

You can also combine both types of parameters:
```
todo remove "Foo" 1
```


### View

View only takes filenames as the parameter.


# Contributing

Feel free to contribute anything at all, if you feel like cracking your head over
a trivial project is what you want. 

