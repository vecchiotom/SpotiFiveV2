# SpotiFiveV2

hi everybody, recently decided i wanted to revamp one of my old projects, (Spotifive)[https://github.com/vecchiotom/SpotiFive]. This has been completely Re-Written from the ground up. it's now also much much easier to run it, thanks to the new packaged form, so that it will be shipped as an EXE file.

## How to run it

It's very simple:

* clone the repo
* take the fivem folder, rename it to whatever you like and put it in your server as you would a normal resource
* get a MySQL database
* run this query on it:

```
CREATE TABLE `accounts` (
  `steam` varchar(17) NOT NULL,
  `access_token` mediumtext,
  `refresh_token` mediumtext,
  PRIMARY KEY (`steam`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

```

* run buildserver.bat and wait for everything to install and build
* in the server folder you'll find your EXE, and even MacOS and Linux versions, just run them and your server will be up just like that!

check "localhost" and see if it's working.

### This is all still very much experimental, any help is appreciated!!!