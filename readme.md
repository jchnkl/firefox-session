# Separate Firefox profiles with unionfs and copy on write

## Intention

Firefox allows the use of multiple profiles with different processes. This is
useful to separate concerns or work contexts. For example one might have
a profile for web surfing, and another for doing work related task and yet
another for private projects, etc.

However, setting up a new profile can be tedious, especially if one likes to
use multiple extensions and customizations. A solution would be to set up
a basic profile and copy it for each new profile. This is wasteful though. The
approach presented here uses copy-on-write to share the major portion of the
profiles and still allow for individual customizations on each new profile.

## Why not Docker?

There are several issues with running Firefox in a Docker container. While it's
easy to run an X11 program in Docker container by exposing `/tmp/.X11-unix`, it
is more difficult to get sound to work. This can be solved by using pulseaudio,
but then the pulseaudio server is required. Another issue is the default image
size. Even a small base image is likely to be larger than a Firefox profile.

Most importantly though, the intention of Docker is quite different. Docker's
main goal is isolation of processes, not sharing a common base image.

## Setting up the base profile

Close all running Firefox instances. Run `firefox -P` and create a new basic
profile. Remember or write down the profile path. Customize your new profile,
install extensions, etc.

Alternatively, just use your current profile. It is most likely located in
`~/.mozilla/firefox`. Also we'll use it in read-only mode, you might want to
make backup copy.

## Run the bash script

Copy the `firefox-session.sh` script to your `bin` folder, e.g. in your home
directory or globally. Just make sure that it's somewhere in `$PATH`.

Open the script and make sure to set all required variables:

```
# Path to the base profile
# PROFILE_BASE=~/.mozilla/firefox/base

# Path where new profiles should be stored
# PROFILE_DIRECTORY=~/.mozilla/firefox
```

Set the executable flag (`chmod +x firefox-session.sh`) and try it out!

## Caveat

* Use an alias for `firefox`: `alias firefox 'firefox-session <default-session>'`
* Make sure to close all Firefox instances before updating the base profile
* ???
