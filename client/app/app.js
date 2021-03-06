// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
// import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

//import stateSync from "./socket"
//var stateSync = Socket;

class SlideSync {
	constructor(stateSync, slideshow){
		this.slideshow = slideshow;

		stateSync.start(this.page);
		stateSync.listen((p) => {this.setPage(p)});

		this.monkeyPatchReplaceState();

		window.addEventListener('replaceState', e => {
			if (this.fromStateSync)
				this.fromStateSync = false;
			else
		    	stateSync.push(this.page);
		});
	}

	get page(){
		return window.location.hash.replace(/#p?/,'')
	}

	get presenter(){
		return window.location.hash.indexOf('#p') == 0;
	}

	setPage(p){
		p = parseInt(p);
		if (this.slideshow.getCurrentSlideIndex() != p-1){
			this.fromStateSync = true;
			this.slideshow.gotoSlide(p);
		}
	}

	monkeyPatchReplaceState(){
		let _wr = function(type) {
		    let orig = history[type];
		    return function() {
		        let rv = orig.apply(this, arguments);
		        let e = new Event(type);
		        e.arguments = arguments;
		        window.dispatchEvent(e);
		        return rv;
		    };
		};
		history.pushState = _wr('pushState'), history.replaceState = _wr('replaceState');
	}
}

window.slidesync = new SlideSync(stateSync, window.slideshow);