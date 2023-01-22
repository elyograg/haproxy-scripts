# Haproxy Build and Install Scripts

These are scripts for installing haproxy from source with HTTP/3 support.

See instructions at this blog post:

https://purg.atory.org/2022/09/20/installing-and-updating-haproxy-from-source/

CI info:

It is best to put gitlab-runner on a dedicated VM.  If it is run on your
machine that actually runs your production haproxy, it will clobber that
install's haproxy config.  The gitlab-runner machine must have a webserver
installed, configured to bind port 81, no ssl.  If the webserver's document
root is not /var/www/html then the CI config must be updated.  CI will copy
the repo to /usr/local/src, prep the system using the included prep-source
script, and then proceed with the build/install of quictls and haproxy.
It will then start haproxy, write a test string to the webroot, and retrieve
that string.  The CI script pushes a test string that includes the git commit
hash, and checks that it pulls the same string, and displays both strings.
If they don't match, the CI job fails.
