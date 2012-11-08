/**
 * jquery.elastislide.js v1.1.0
 * http://www.codrops.com
 *
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Copyright 2012, Codrops
 * http://www.codrops.com
 */
(function(e,t,n){"use strict";var r=e.event,i,s;i=r.special.debouncedresize={setup:function(){e(this).on("resize",i.handler)},teardown:function(){e(this).off("resize",i.handler)},handler:function(e,t){var n=this,o=arguments,u=function(){e.type="debouncedresize",r.dispatch.apply(n,o)};s&&clearTimeout(s),t?u():s=setTimeout(u,i.threshold)},threshold:150};var o="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==";e.fn.imagesLoaded=function(t){function c(){var n=e(f),s=e(l);i&&(l.length?i.reject(u,n,s):i.resolve(u)),e.isFunction(t)&&t.call(r,u,n,s)}function h(t,n){if(t.src===o||e.inArray(t,a)!==-1)return;a.push(t),n?l.push(t):f.push(t),e.data(t,"imagesLoaded",{isBroken:n,src:t.src}),s&&i.notifyWith(e(t),[n,u,e(f),e(l)]),u.length===a.length&&(setTimeout(c),u.unbind(".imagesLoaded"))}var r=this,i=e.isFunction(e.Deferred)?e.Deferred():0,s=e.isFunction(i.notify),u=r.find("img").add(r.filter("img")),a=[],f=[],l=[];return e.isPlainObject(t)&&e.each(t,function(e,n){e==="callback"?t=n:i&&i[e](n)}),u.length?u.bind("load.imagesLoaded error.imagesLoaded",function(e){h(e.target,e.type==="error")}).each(function(t,r){var i=r.src,s=e.data(r,"imagesLoaded");if(s&&s.src===i){h(r,s.isBroken);return}if(r.complete&&r.naturalWidth!==n){h(r,r.naturalWidth===0||r.naturalHeight===0);return}if(r.readyState||r.complete)r.src=o,r.src=i}):c(),i?i.promise(r):r};var u=e(t),a=t.Modernizr;e.Elastislide=function(t,n){this.$el=e(n),this._init(t)},e.Elastislide.defaults={orientation:"horizontal",speed:500,easing:"ease-in-out",minItems:3,start:0,onClick:function(e,t,n){return!1},onReady:function(){return!1},onBeforeSlide:function(){return!1},onAfterSlide:function(){return!1}},e.Elastislide.prototype={_init:function(t){this.options=e.extend(!0,{},e.Elastislide.defaults,t);var n=this,r={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd",msTransition:"MSTransitionEnd",transition:"transitionend"};this.transEndEventName=r[a.prefixed("transition")],this.support=a.csstransitions&&a.csstransforms,this.current=this.options.start,this.isSliding=!1,this.$items=this.$el.children("li"),this.itemsCount=this.$items.length;if(this.itemsCount===0)return!1;this._validate(),this.$items.detach(),this.$el.empty(),this.$el.append(this.$items),this.$el.wrap('<div class="elastislide-wrapper elastislide-loading elastislide-'+this.options.orientation+'"></div>'),this.hasTransition=!1,this.hasTransitionTimeout=setTimeout(function(){n._addTransition()},100),this.$el.imagesLoaded(function(){n.$el.show(),n._layout(),n._configure(),n.hasTransition?(n._removeTransition(),n._slideToItem(n.current),n.$el.on(n.transEndEventName,function(){n.$el.off(n.transEndEventName),n._setWrapperSize(),n._addTransition(),n._initEvents()})):(clearTimeout(n.hasTransitionTimeout),n._setWrapperSize(),n._initEvents(),n._slideToItem(n.current),setTimeout(function(){n._addTransition()},25)),n.options.onReady()})},_validate:function(){this.options.minItems instanceof Function&&(this._minItemsFn=this.options.minItems,this.options.minItems=this.options.minItems(document.documentElement.clientWidth)),this.options.speed<0&&(this.options.speed=500);if(this.options.minItems<1||this.options.minItems>this.itemsCount)this.options.minItems=1;if(this.options.start<0||this.options.start>this.itemsCount-1)this.options.start=0;this.options.orientation!="horizontal"&&this.options.orientation!="vertical"&&(this.options.orientation="horizontal")},_layout:function(){this.$el.wrap('<div class="elastislide-carousel"></div>'),this.$carousel=this.$el.parent(),this.$wrapper=this.$carousel.parent().removeClass("elastislide-loading");var e=this.$items.find("img:first");this.imgSize={width:e.outerWidth(!0),height:e.outerHeight(!0)},this._setItemsSize(),this.options.orientation==="horizontal"?this.$el.css("max-height",this.imgSize.height):this.$el.css("height",this.options.minItems*this.imgSize.height),this._addControls()},_addTransition:function(){this.support&&this.$el.css("transition","all "+this.options.speed+"ms "+this.options.easing),this.hasTransition=!0},_removeTransition:function(){this.support&&this.$el.css("transition","all 0s"),this.hasTransition=!1},_addControls:function(){var t=this;this.$navigation=e('<nav><span class="elastislide-prev">Previous</span><span class="elastislide-next">Next</span></nav>').appendTo(this.$wrapper),this.$navPrev=this.$navigation.find("span.elastislide-prev").on("mousedown.elastislide",function(e){return t._slide("prev"),!1}),this.$navNext=this.$navigation.find("span.elastislide-next").on("mousedown.elastislide",function(e){return t._slide("next"),!1})},_setItemsSize:function(){var e=this.options.orientation==="horizontal"?Math.floor(this.$carousel.width()/this.options.minItems)*100/this.$carousel.width():100;this.$items.css({width:e+"%","max-width":this.imgSize.width,"max-height":this.imgSize.height}),this.options.orientation==="vertical"&&this.$wrapper.css("max-width",this.imgSize.width+parseInt(this.$wrapper.css("padding-left"))+parseInt(this.$wrapper.css("padding-right")))},_setWrapperSize:function(){this.options.orientation==="vertical"&&this.$wrapper.css({height:this.options.minItems*this.imgSize.height+parseInt(this.$wrapper.css("padding-top"))+parseInt(this.$wrapper.css("padding-bottom"))})},_configure:function(){this.fitCount=this.options.orientation==="horizontal"?this.$carousel.width()<this.options.minItems*this.imgSize.width?this.options.minItems:Math.floor(this.$carousel.width()/this.imgSize.width):this.$carousel.height()<this.options.minItems*this.imgSize.height?this.options.minItems:Math.floor(this.$carousel.height()/this.imgSize.height)},_initEvents:function(){var t=this;u.on("debouncedresize.elastislide",function(){t._minItemsFn&&(t.options.minItems=t._minItemsFn(document.documentElement.clientWidth)),t._setItemsSize(),t._configure(),t._slideToItem(t.current)}),this.$el.on(this.transEndEventName,function(){t._onEndTransition()}),this.options.orientation==="horizontal"?this.$el.on({swipeleft:function(){t._slide("next")},swiperight:function(){t._slide("prev")}}):this.$el.on({swipeup:function(){t._slide("next")},swipedown:function(){t._slide("prev")}}),this.$el.on("click.elastislide","li",function(n){var r=e(this);t.options.onClick(r,r.index(),n)})},_destroy:function(e){this.$el.off(this.transEndEventName).off("swipeleft swiperight swipeup swipedown .elastislide"),u.off(".elastislide"),this.$el.css({"max-height":"none",transition:"none"}).unwrap(this.$carousel).unwrap(this.$wrapper),this.$items.css({width:"auto","max-width":"none","max-height":"none"}),this.$navigation.remove(),this.$wrapper.remove(),e&&e.call()},_toggleControls:function(e,t){t?e==="next"?this.$navNext.show():this.$navPrev.show():e==="next"?this.$navNext.hide():this.$navPrev.hide()},_slide:function(t,r){if(this.isSliding)return!1;this.options.onBeforeSlide(),this.isSliding=!0;var i=this,s=this.translation||0,o=this.options.orientation==="horizontal"?this.$items.outerWidth(!0):this.$items.outerHeight(!0),u=this.itemsCount*o,a=this.options.orientation==="horizontal"?this.$carousel.width():this.$carousel.height();if(r===n){var f=this.fitCount*o;if(f<0)return!1;if(t==="next"&&u-(Math.abs(s)+f)<a)f=u-(Math.abs(s)+a),this._toggleControls("next",!1),this._toggleControls("prev",!0);else if(t==="prev"&&Math.abs(s)-f<0)f=Math.abs(s),this._toggleControls("next",!0),this._toggleControls("prev",!1);else{var l=t==="next"?Math.abs(s)+Math.abs(f):Math.abs(s)-Math.abs(f);l>0?this._toggleControls("prev",!0):this._toggleControls("prev",!1),l<u-a?this._toggleControls("next",!0):this._toggleControls("next",!1)}r=t==="next"?s-f:s+f}else{var f=Math.abs(r);Math.max(u,a)-f<a&&(r=-(Math.max(u,a)-a)),f>0?this._toggleControls("prev",!0):this._toggleControls("prev",!1),Math.max(u,a)-a>f?this._toggleControls("next",!0):this._toggleControls("next",!1)}this.translation=r;if(s===r)return this._onEndTransition(),!1;if(this.support)this.options.orientation==="horizontal"?this.$el.css("transform","translateX("+r+"px)"):this.$el.css("transform","translateY("+r+"px)");else{e.fn.applyStyle=this.hasTransition?e.fn.animate:e.fn.css;var c=this.options.orientation==="horizontal"?{left:r}:{top:r};this.$el.stop().applyStyle(c,e.extend(!0,[],{duration:this.options.speed,complete:function(){i._onEndTransition()}}))}this.hasTransition||this._onEndTransition()},_onEndTransition:function(){this.isSliding=!1,this.options.onAfterSlide()},_slideTo:function(e){var e=e||this.current,t=Math.abs(this.translation)||0,n=this.options.orientation==="horizontal"?this.$items.outerWidth(!0):this.$items.outerHeight(!0),r=t+this.$carousel.width(),i=Math.abs(e*n);(i+n>r||i<t)&&this._slideToItem(e)},_slideToItem:function(e){var t=this.options.orientation==="horizontal"?e*this.$items.outerWidth(!0):e*this.$items.outerHeight(!0);this._slide("",-t)},add:function(e){var t=this,n=this.current,r=this.$items.eq(this.current);this.$items=this.$el.children("li"),this.itemsCount=this.$items.length,this.current=r.index(),this._setItemsSize(),this._configure(),this._removeTransition(),n<this.current?this._slideToItem(this.current):this._slide("next",this.translation),setTimeout(function(){t._addTransition()},25),e&&e.call()},setCurrent:function(e,t){this.current=e,this._slideTo(),t&&t.call()},next:function(){self._slide("next")},previous:function(){self._slide("prev")},slideStart:function(){this._slideTo(0)},slideEnd:function(){this._slideTo(this.itemsCount-1)},destroy:function(e){this._destroy(e)}};var f=function(e){t.console&&t.console.error(e)};e.fn.elastislide=function(t){var n=e.data(this,"elastislide");if(typeof t=="string"){var r=Array.prototype.slice.call(arguments,1);this.each(function(){if(!n){f("cannot call methods on elastislide prior to initialization; attempted to call method '"+t+"'");return}if(!e.isFunction(n[t])||t.charAt(0)==="_"){f("no such method '"+t+"' for elastislide self");return}n[t].apply(n,r)})}else this.each(function(){n?n._init():n=e.data(this,"elastislide",new e.Elastislide(t,this))});return n}})(jQuery,window);