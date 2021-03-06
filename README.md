# Remarksync

Synchronize [remark](https://github.com/gnab/remark) slideshows between devices on the internet.

# How it works

Slideshow changes are synchronized over the internet using a [Phoenix](http://phoenixframework.org) Channel hosted on Heroku.

When a slideshow using Remarksync is opened it connects to the Channel, broadcasting slide changes and receiving slide change broadcasts from other devices/tabs/browsers accessing the same URL. 

# How to use it

Add the Remarksync script to the HTML of your remark slideshow, right after initialization:

```html
<script src="https://gnab.github.io/remark/downloads/remark-latest.min.js"></script>
<script>
  var slideshow = remark.create({..});
</script>
<script src="https://omnibs.github.io/remarksync/web/static/assets/js/remarksync.js"></script>
```

That's it!

Right now Remarksync requires you to have your slideshow on `window.slideshow` as shown above. It's smelly but it works, I'll improve it eventually.

The source-code for the library and the Phoenix Website can be found in this repository.

# How to run your own Remarksync:

If you'd like to use Remarksync on a LAN without internet, you can run it yourself and point the [remarksync.js](https://github.com/omnibs/remarksync/blob/master/web/static/assets/js/remarksync.js) file to your own Phoenix server.

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
