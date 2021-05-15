# Zendesk Ticket Viewer

This is a little CLI app made for an application for a graduate position at Zendesk.
Below are some information about the app, installation and usage instructions.

* [I. Info and dependencies][#I. Info and dependencies]
* [II. Installation][#II. Installation]
* [III. Usage][#III. Usage]

___
## I. Info and dependencies

This app is done in vanilla Ruby, version 2.7.1p83. It uses Bundler version 2.2.14 for the gem management and Rspec 3.10 for automated testing.

### Dependencies:

Gem | Version
---------|----------
 rspec | 3.10
 httparty | 0.18.1
 terminal-table | 3.0
 tty-prompt | 0.23.1
 dotenv | 2.7


## II. Installation

1. To get started, run this in your terminal to clone this repo onto your local machine:

```
$ git clone https://github.com/chivoi/zendesk-ticket-viewer.git
```

2. Navigate into the root directory of the app:

```
$ cd zendesk-ticket-viewer
```

3. If you haven't already, install Ruby.

To run this programme, you will need Ruby version 2.7.1 or higer. Follow [this guide](https://www.ruby-lang.org/en/documentation/installation/) to install it in your machine.

4. Install Bundler to take care of the gem dependencies:

```
$ gem install bundler
```

5. Install the dependencies:

```
$ bundle install
```

6. If you are marking this challenge, you have been emailed the `.env` file for this project. Save this file into the root directory of the project.

After this, you should be all set ready to go!

## III. Usage and features
### Launching the app

Still in the root directory of the app, run this to launch the Ticket Viewer:

```
$ ruby bin/index.rb
```

Hit `enter` to start the programme, navigate menu with up/down arrows.
### Features

#### **View all tickets**

The Viewer requests 25 tickets at the time from the Support API and displays them in pages.

#### **View a single ticket**

Choose this option in the main menu, type the ID of the ticket and the Viewer will display it.

### Testing

If you would like to run automated tests for this app, run this from the root directory:

```
$ rspec
```
___

This app was made by Ana Lastoviria in 2021. [Email me](mailto:a.lastovirya@gmail.com) for any questions or suggestions.