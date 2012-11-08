/*
 * jQuery Foundation Clearing 1.0
 * http://foundation.zurb.com
 * Copyright 2012, ZURB
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/
/*jslint unparam: true, browser: true, indent: 2 */
(function(e,t,n){"use strict";var r={templates:{viewing:'<a href="#" class="clearing-close">&times;</a><div class="visible-img" style="display: none"><img src="#"><p class="clearing-caption"></p><a href="#" class="clearing-main-left"></a><a href="#" class="clearing-main-right"></a></div>'},locked:!1},i={},s={init:function(t,n){return this.find("ul[data-clearing]").each(function(){var t=e(document),n=e(this),i=i||{},o=o||{},u=n.data("fndtn.clearing.settings");u||(i.$parent=n.parent(),n.data("fndtn.clearing.settings",e.extend({},r,i)),s.extend(s,o),s.assemble(n.find("li")),s.events())})},events:function(){var n=e(document);n.on("click.fndtn.clearing","ul[data-clearing] li",function(t,n,r){var n=n||e(this),r=r||n;t.preventDefault(),s.open(e(t.target),n,r),s.update_paddles(r)}),e(t).on("resize.fndtn.clearing",function(){var t=e(".clearing-blackout .visible-img").find("img");t.length>0&&s.center(t)}),n.on("click.fndtn.clearing",".clearing-main-right",function(t){var n=e(".clearing-blackout").find("ul[data-clearing]");t.preventDefault(),s.go(n,"next")}),n.on("click.fndtn.clearing",".clearing-main-left",function(t){var n=e(".clearing-blackout").find("ul[data-clearing]");t.preventDefault(),s.go(n,"prev")}),n.on("click.fndtn.clearing","a.clearing-close, div.clearing-blackout",function(t){var n=function(e){return/blackout/.test(e.selector)?e:e.closest(".clearing-blackout")}(e(this)),i,s;return this===t.target&&n&&(i=n.find("div:first"),s=i.find(".visible-img"),r.prev_index=0,n.find("ul[data-clearing]").attr("style",""),n.removeClass("clearing-blackout"),i.removeClass("clearing-container"),s.hide()),!1}),n.on("keydown.fndtn.clearing",function(t){var n=e(".clearing-blackout").find("ul[data-clearing]");t.which===39&&s.go(n,"next"),t.which===37&&s.go(n,"prev")}),n.on("movestart",function(e){(e.distX>e.distY&&e.distX<-e.distY||e.distX<e.distY&&e.distX>-e.distY)&&e.preventDefault()}),n.bind("swipeleft","ul[data-clearing] li",function(){var t=e(".clearing-blackout").find("ul[data-clearing]");s.go(t,"next")}),n.bind("swiperight","ul[data-clearing] li",function(){var t=e(".clearing-blackout").find("ul[data-clearing]");s.go(t,"prev")})},assemble:function(e,t){var n=e.parent(),r=n.data("fndtn.clearing.settings"),i=n.detach(),s={grid:'<div class="carousel">'+this.outerHTML(i[0])+"</div>",viewing:r.templates.viewing},o='<div class="clearing-assembled"><div>'+s.viewing+s.grid+"</div></div>";return r.$parent.append(o)},open:function(e,t,n){var r=n.closest(".clearing-assembled"),i=r.find("div:first"),o=i.find(".visible-img"),u=o.find("img").not(e);s.locked()||(u.attr("src",this.load(e)),u.is_good(function(){r.addClass("clearing-blackout"),i.addClass("clearing-container"),s.caption(o.find(".clearing-caption"),e),o.show(),s.fix_height(n),s.center(u),s.shift(t,n,function(){n.siblings().removeClass("visible"),n.addClass("visible")})}))},fix_height:function(t){var n=t.siblings();n.each(function(){var t=e(this),n=t.find("img");t.height()>n.outerHeight()&&t.addClass("fix-height")}),n.closest("ul").width(n.length*100+"%")},update_paddles:function(e){var t=e.closest(".carousel").siblings(".visible-img");e.next().length>0?t.find(".clearing-main-right").removeClass("disabled"):t.find(".clearing-main-right").addClass("disabled"),e.prev().length>0?t.find(".clearing-main-left").removeClass("disabled"):t.find(".clearing-main-left").addClass("disabled")},load:function(e){var t=e.parent().attr("href");return this.preload(e),t?t:e.attr("src")},preload:function(e){var t=e.closest("li").next(),n=e.closest("li").prev(),r,i,s,o;t.length>0&&(s=new Image,r=t.find("a"),r.length>0?s.src=r.attr("href"):s.src=t.find("img").attr("src")),n.length>0&&(o=new Image,i=n.find("a"),i.length>0?o.src=i.attr("href"):o.src=n.find("img").attr("src"))},caption:function(e,t){var n=t.data("caption");n?e.text(n).show():e.text("").hide()},go:function(e,t){var n=e.find(".visible"),r=n[t]();r.length>0&&r.find("img").trigger("click",[n,r])},shift:function(e,t,n){var i=t.parent(),o=i.closest(".clearing-container"),u=t.position().left,a=i.position().left,f=r.prev_index,l=this.direction(i,e,t),c=parseInt(i.css("left"),10),h=t.outerWidth(),p;t.index()!==f&&!/skip/.test(l)?/left/.test(l)?(s.lock(),i.animate({left:c+h},300,s.unlock)):/right/.test(l)&&(s.lock(),i.animate({left:c-h},300,s.unlock)):/skip/.test(l)&&(p=t.index()-r.up_count,s.lock(),p>0?i.animate({left:-(p*h)},300,s.unlock):i.animate({left:0},300,s.unlock)),n()},lock:function(){r.locked=!0},unlock:function(){r.locked=!1},locked:function(){return r.locked},direction:function(t,n,i){var s=t.find("li"),o=s.outerWidth()+s.outerWidth()/4,u=e(".clearing-container"),a=Math.floor(u.outerWidth()/o)-1,f=s.length-a,l=s.index(i),c=s.index(n),h;return r.up_count=a,this.adjacent(r.prev_index,l)?l>a&&l>r.prev_index?h="right":l>a-1&&l<=r.prev_index?h="left":h=!1:h="skip",r.prev_index=l,h},adjacent:function(e,t){return t-1===e?!0:t+1===e?!0:t===e?!0:!1},center:function(e){e.css({marginLeft:-(e.outerWidth()/2),marginTop:-(e.outerHeight()/2)})},outerHTML:function(e){return e.outerHTML||(new XMLSerializer).serializeToString(e)},extend:function(t,n){e.each(t,function(e,t){n.hasOwnProperty(e)&&(i[e]=t)}),e.extend(s,n)},_super:function(e,t){return i[e].apply(this,t)}};e.fn.foundationClearing=function(t){if(s[t])return s[t].apply(this,Array.prototype.slice.call(arguments,1));if(typeof t=="object"||!t)return s.init.apply(this,arguments);e.error("Method "+t+" does not exist on jQuery.foundationClearing")},function(e){e.fn.is_good=function(t,n){function o(){s-=1,!s&&t()}function u(){this.one("load",o);if(e.browser.msie){var t=this.attr("src"),n=t.match(/\?/)?"&":"?";n+=r.cachePrefix+"="+(new Date).getTime(),this.attr("src",t+n)}}var r=e.extend({},e.fn.is_good.defaults,n),i=this.find("img").add(this.filter("img")),s=i.length;return i.each(function(){var t=e(this);if(!t.attr("src")){o();return}this.complete||this.readyState===4?o():u.call(t)})},e.fn.is_good.defaults={cachePrefix:"random"}}(jQuery)})(jQuery,this);