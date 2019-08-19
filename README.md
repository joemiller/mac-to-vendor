mac-to-vendor lookup service
============================

Simple web service for looking up MAC addresses to vendors. (Ruby Sinatra app)

The goal is to provide the most complete MAC vendor database possible, including
the official registrations managed by IEEE but also to include common but
unofficial prefixes such as those used by hypervisors.

Example:

```
$ curl https://mac-to-vendor-yps2oxobta-uc.a.run.app/f8:27:93:0c:aa:bb
Apple, Inc.
```

MAC database
------------

The goal is to provide the most complete MAC database possible. The format of the
database files in the `db` sub-directory is borrowed from the `arp-scan` project.
Additionally some unregistered MAC prefixes were taken from `nmap` as well.

### Updating IEEE database

To update the official database `ieee-oui.txt` file, use the `get-oui`
script from the arp-scan package and place it in the current directory. https://github.com/royhills/arp-scan/blob/master/get-oui

```shell
$ bundle exec rake update
```

Commit the updated `./db/*` files to git.

### Manual / Unofficial MAC database

For manual entries, add to the `./db/mac-vendors.txt` file.

Usage
-----

- Use the hosted service: `curl https://mac-to-vendor-yps2oxobta-uc.a.run.app/`
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

Deployment
----------

- CI/CD: Google Cloud Build (`./cloudbuild.yaml`)
- Runtime/Hosting: Google Cloud Run (https://mac-to-vendor-yps2oxobta-uc.a.run.app)

TODO
----

- [x] move to google cloud build + cloud run, retire heroku app (notes from this effort in `./CLOUD-RUN-NOTES.md`)
- [ ] move the fetching and process of the mac db's in `./db/` to the CI process
- [ ] Pick a more efficient way to store and load the MAC database. Current cold startup on google cloud-run is only about 5-7seconds though.

Author
------

Joe Miller, @miller_joe, joemiller(github)
