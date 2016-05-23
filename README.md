# Remarksync

Synchronize [remark](https://github.com/gnab/remark) slideshows between devices on the internet.

# How it works

Slideshow changes are synchronized over the internet using a [Phoenix](http://phoenixframework.org) Channel hosted on Heroku.

When a slideshow using Remarksync is opened it connects to the Channel, broadcasting slide changes and receiving slide change broadcasts from other devices/tabs/browsers accessing the same URL. 

# How to use it

Add the Remarksync script to the HTML of your remark slideshow:

```
<script src="http://calm-caverns-50885.herokuapp.com/js/remarksync.js"></script>
```

That's it! 

The source-code for the library and the Phoenix Website can be found in this repository.

# How to run your own Remarksync:

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
