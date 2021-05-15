# Zendesk Ticket Viewer

This is a CLI app made for an application for a Graduate Developer position at Zendesk.
Below are some information about the app, installation and usage instructions.

* [1.Info](#1-info)<br>
   * [dependencies](#dependencies)
* [2.Installation](#2-installation)<br>
* [3.Usage](#3-usage)<br>
   * [launching the app](#launching-the-app)
   * [features](#features)
   * [testing](#testing)

## 1. Info

Ticket Viewer is built in vanilla Ruby, version 2.7.1p83. It uses Bundler version 2.2.14 for gem handling and Rspec 3.10 for automated testing.

### Dependencies:

Gem | Version
---------|----------
 rspec | 3.10
 httparty | 0.18.1
 terminal-table | 3.0
 tty-prompt | 0.23.1
 dotenv | 2.7


## 2. Installation

1. To get started, run this in your terminal to *clone this repo* onto your local machine:

```
$ git clone https://github.com/chivoi/zendesk-ticket-viewer.git
```

2. Navigate into the *root directory* of the app:

```
$ cd zendesk-ticket-viewer
```

4. If you haven't already, *install Ruby*. To run this programme, you will need Ruby version 2.7.1 or higer. Follow [this guide](https://www.ruby-lang.org/en/documentation/installation/) to install it on your machine.

5. Install *Bundler* to take care of the gem dependencies:

```
$ gem install bundler
```

6. Install the dependencies:

```
$ bundle install
```

7. If you are marking this challenge, you have been emailed the `env` file for this project. Save the file into the *root directory* of the project. Rename the file to add the dot in front of the file name (`.env`) to make sure dotenv library can load it properly.

After this, you should be all set ready to go!

## 3. Usage
### Launching the app

Still in the root directory of the app, run this to launch the Viewer:

```
$ ruby bin/index.rb
```

Hit `enter` to start the programme, navigate menu with up/down arrows.
### Features

#### **View all tickets**

The Viewer requests tickets from Zendesk Support API and displays them onto the screen.

#### **Pagination**

The tickets are displayed in pages, 25 per page. "Next Page" and "Prev Page" menu options will take you to the next and previous pages respectively.

#### **View a single ticket**

Choose this option in the main menu at any point, type the ID of the ticket and the Viewer will display it.

### Testing

If you would like to run automated test suite for the app, run this from the root directory:

```
$ rspec
```
___

Made with love by Ana Lastoviria in 2021.
