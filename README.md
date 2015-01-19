mac-to-vendor lookup service
============================

Simple web service for looking up MAC addresses to vendors. (Ruby Sinatra app)

Example:

```
$ curl https://whispering-shelf-4150.herokuapp.com/f8:27:93:0c:aa:bb
Apple, Inc.
```

MAC database
------------

The goal is to provide the most complete MAC database possible. The format of the
database files in the `db` sub-directory is borrowed from the `arp-scan` project.
Additionally some unregistered MAC prefixes were taken from `nmap` as well.

To update the official/registered database `ieee-oui.txt` file, use the `get-oui`
script from the arp-scan package.

Add unregistered types to the `mac-vendors.txt` file.

Usage
-----

- Use the hosted service: `curl https://whispering-shelf-4150.herokuapp.com/`
- Run your own: `bundle install; foreman start`

CORS Headers
------------

CORS headers are provided so that this service can be incorporated into javascript
apps easily.

Testing
-------

`bundle exec rake test`

Contributing
------------

1. Fork
2. Make branch
3. Add tests.
4. Send PR

Author
------

Joe Miller, @miller_joe, joemiller(github)
