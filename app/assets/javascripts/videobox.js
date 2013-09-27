var Videobox = {

	init: function (options) {
		// init default options
		this.options = Object.extend({
			resizeDuration: 400,	// Duration of height and width resizing (ms)
			initialWidth: 250,		// Initial width of the box (px)
			initialHeight: 250,		// Initial height of the box (px)
			defaultWidth: 425,		// Default width of the box (px)
			defaultHeight: 350,	// Default height of the box (px)
			animateCaption: true,	// Enable/Disable caption animation
			flvplayer: 'swf/flvplayer.swf'
		}, options || {});

		this.anchors = [];
		$A($$('a')).each(function(el){
			if(el.rel && el.href && el.rel.test('^vidbox', 'i')) {
				el.addEvent('click', function (e) {
          e = new Event(e);
          e.stop();
          this.click(el);
				}.bind(this));
				this.anchors.push(el);
			}
    }, this);

		this.overlay = new Element('div').setProperty('id', 'lbOverlay').injectInside(document.body);
		this.center = new Element('div').setProperty('id', 'lbCenter').setStyles({width: this.options.initialWidth+'px', height: this.options.initialHeight+'px', marginLeft: '-'+(this.options.initialWidth/2)+'px', display: 'none'}).injectInside(document.body);

		this.bottomContainer = new Element('div').setProperty('id', 'lbBottomContainer').setStyle('display', 'none').injectInside(document.body);
		this.bottom = new Element('div').setProperty('id', 'lbBottom').injectInside(this.bottomContainer);
		new Element('a').setProperties({id: 'lbCloseLink', href: '#'}).injectInside(this.bottom).onclick = this.overlay.onclick = this.close.bind(this);
		this.caption = new Element('div').setProperty('id', 'lbCaption').injectInside(this.bottom);
		this.number = new Element('div').setProperty('id', 'lbNumber').injectInside(this.bottom);
		new Element('div').setStyle('clear', 'both').injectInside(this.bottom);

		var nextEffect = this.nextEffect.bind(this);
		this.fx = {
			overlay: this.overlay.effect('opacity', {duration: 500}).hide(),
			center: this.center.effects({duration: 500, transition: Fx.Transitions.sineInOut, onComplete: nextEffect}),
			bottom: this.bottom.effect('margin-top', {duration: 400})
		};

	},

	click: function(link) {
	
     		return this.open (link.href, link.title, link.rel);

	},
	open: function(sLinkHref, sLinkTitle, sLinkRel) {
		this.href = sLinkHref;
		this.title = sLinkTitle;
		this.rel = sLinkRel;
		this.position();
		this.setup();
		this.video(this.href);
		this.top = Window.getScrollTop() + (Window.getHeight() / 15);
		this.center.setStyles({top: this.top+'px', display: ''});
		this.fx.overlay.start(0.8);
		this.step = 1;
		this.center.setStyle('background','#fff url(loading.gif) no-repeat center');
		this.caption.innerHTML = this.title;
		this.fx.center.start({'height': [this.options.contentsHeight]});
	},

	setup: function(){
		var aDim = this.rel.match(/[0-9]+/g);
		this.options.contentsWidth = (aDim && (aDim[0] > 0)) ? aDim[0] : this.options.defaultWidth;
		this.options.contentsHeight = (aDim && (aDim[1] > 0)) ? aDim[1] : this.options.defaultHeight;

	},

	position: function(){
    this.overlay.setStyles({'top': window.getScrollTop()+'px', 'height': window.getHeight()+'px'});
	},

	video: function(sLinkHref){
		if (sLinkHref.match(/youtube\.com\/watch/i)) {
      this.flash = true;
			var hRef = sLinkHref;
			var videoId = hRef.split('=');
			this.videoID = videoId[1];
			this.so = new SWFObject("http://www.youtube.com/v/"+this.videoID, "flvvideo", this.options.contentsWidth, this.options.contentsHeight, "0");
			this.so.addParam("wmode", "transparent");
		}
		else if (sLinkHref.match(/metacafe\.com\/watch/i)) {
      this.flash = true;
			var hRef = sLinkHref;
			var videoId = hRef.split('/');
			this.videoID = videoId[4];
			this.so = new SWFObject("http://www.metacafe.com/fplayer/"+this.videoID+"/.swf", "flvvideo", this.options.contentsWidth, this.options.contentsHeight, "0");
			this.so.addParam("wmode", "transparent");
		}
		else if (sLinkHref.match(/google\.com\/videoplay/i)) {
      this.flash = true;
			var hRef = sLinkHref;
			var videoId = hRef.split('=');
			this.videoID = videoId[1];
			this.so = new SWFObject("http://video.google.com/googleplayer.swf?docId="+this.videoID+"&hl=en", "flvvideo", this.options.contentsWidth, this.options.contentsHeight, "0");
			this.so.addParam("wmode", "transparent");
		}
		else if (sLinkHref.match(/ifilm\.com\/video/i)) {
		  this.flash = true;
			var hRef = sLinkHref;
			var videoId = hRef.split('video/');
			this.videoID = videoId[1];
			this.so = new SWFObject("http://www.ifilm.com/efp", "flvvideo", this.options.contentsWidth, this.options.contentsHeight, "0", "#000");
			this.so.addVariable("flvbaseclip", this.videoID+"&");
			this.so.addParam("wmode", "transparent");
		}
		else if (sLinkHref.match(/\.mov/i)) {
		  this.flash = false;
			if (navigator.plugins && navigator.plugins.length) {
          this.other ='<object id="qtboxMovie" type="video/quicktime" codebase="http://www.apple.com/qtactivex/qtplugin.cab" data="'+sLinkHref+'" width="'+this.options.contentsWidth+'" height="'+this.options.contentsHeight+'"><param name="src" value="'+sLinkHref+'" /><param name="scale" value="aspect" /><param name="controller" value="true" /><param name="autoplay" value="true" /><param name="bgcolor" value="#000000" /><param name="enablejavascript" value="true" /></object>';
      } else {
        this.other = '<object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab" width="'+this.options.contentsWidth+'" height="'+this.options.contentsHeight+'" id="qtboxMovie"><param name="src" value="'+sLinkHref+'" /><param name="scale" value="aspect" /><param name="controller" value="true" /><param name="autoplay" value="true" /><param name="bgcolor" value="#000000" /><param name="enablejavascript" value="true" /></object>';
      }
		}
		else if (sLinkHref.match(/\.wmv/i) || sLinkHref.match(/\.asx/i)) {
		this.flash = false;
		 this.other = '<object NAME="Player" WIDTH="'+this.options.contentsWidth+'" HEIGHT="'+this.options.contentsHeight+'" align="left" hspace="0" type="application/x-oleobject" CLASSID="CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6"><param NAME="URL" VALUE="'+sLinkHref+'"><param><param NAME="AUTOSTART" VALUE="false"></param><param name="showControls" value="true"></param><embed WIDTH="'+this.options.contentsWidth+'" HEIGHT="'+this.options.contentsHeight+'" align="left" hspace="0" SRC="'+sLinkHref+'" TYPE="application/x-oleobject" AUTOSTART="false"></embed></object>'
		}
		else if (sLinkHref.match(/\.flv/i)) {
		 this.flash = true;
		 this.so = new SWFObject(this.options.flvplayer+"?file="+sLinkHref, "flvvideo", this.options.contentsWidth, this.options.contentsHeight, "0", "#000");
		}
		else {
		  this.flash = true;
			this.videoID = sLinkHref;
			this.so = new SWFObject(this.videoID, "flvvideo", this.options.contentsWidth, this.options.contentsHeight, "0");
		}
	},

	nextEffect: function(){
		switch (this.step++){
		case 1:
			this.fx.center.start({'width': [this.options.contentsWidth], 'marginLeft': [this.options.contentsWidth/-2]});
			break;
			this.step++;
		case 2:
			this.center.setStyle('background','#fff');
			this.flash ? this.so.write(this.center) : this.center.setHTML(this.other) ;
			this.bottomContainer.setStyles({top: (this.top + this.center.clientHeight)+'px', height: '0px', marginLeft: this.center.style.marginLeft, width: this.options.contentsWidth+'px',display: ''});
			if (this.options.animateCaption){
				this.fx.bottom.set(-this.bottom.offsetHeight);
				this.bottomContainer.style.height = '';
				this.fx.bottom.start(0);
				break;
			}
			this.bottomContainer.style.height = '';
			this.step++;
		}
	},

	close: function(){
		this.fx.overlay.start(0);
		this.center.style.display = this.bottomContainer.style.display = 'none';
		this.center.innerHTML = '';
		return false;
	}

};


window.addEvent('domready', Videobox.init.bind(Videobox));