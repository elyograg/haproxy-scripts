# Haproxy Build and Install Scripts

These are scripts for installing haproxy from source with HTTP/3 support.

See instructions at this blog post:

https://purg.atory.org/2023/05/19/installing-and-updating-haproxy-from-source/

The included file named `ci-haproxy.cfg` is an extremely barebones config
example that is used in the CI/CD pipeline.  It is almost certainly missing
things you would want in a production configuration.

## CI info:

It is best to put gitlab-runner on a dedicated VM.  If it is run on your
machine that actually runs your production haproxy, it will clobber that
install's haproxy config.  The gitlab-runner machine must have a webserver
installed, configured to bind port 81, no ssl.  If the webserver's document
root is not /var/www/html then the CI config must be updated.  CI will copy
the repo to /usr/local/src/haproxy-scripts, prep the system using the included
prep-source script, and then proceed with the build/install of quictls and
haproxy.  It will then start haproxy, write a test string to the webroot, and
retrieve that string with http3 forced.  The test string includes the git
commit hash.  If the pushed string and retrieved string don't match, the CI
job will fail.

To skip the CI job for a push:

git push -o ci.skip

# Issues

Can't guarantee that any github issue opened will get resolved, but I'm not
going to completely ignore them.  This is a personal project made available
because others might find it useful.  It is not meant to address everything
that the world can think of.  Think of it as a starting point for your own
tinkering.
