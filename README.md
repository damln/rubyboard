# Introduction

This is an example on how to use the gem `micromidi` to control your computer. The idea is to help you in your workflow as a developer and give you idea on how to use a MIDI keyboard to improve your workflow.

# Installation

Tested with Ruby 2.2, should work with Ruby 2+.

```
bundle install
```

# Run

```
bundle exec ruby ./main.rb
```

In debug mode, commands won't be executed put it can be useful to check which notes/commands are played and what will be executed:

```
RUBY_ENV=debug bundle exec ruby ./main.rb
```

# Code

- `main.rb` contains the loop used to catch MIDI events.
- `keyboard.rb` contains the code to handle the mapping between notes and commands.
- `orders.rb` contains the commands you can execute. Feel free to map new things and be creative here.

# Slides

https://speakerdeck.com/damln/re-think-your-workflow-with-a-piano
