/**
 * almond 0.1.1 Copyright (c) 2011, The Dojo Foundation All Rights Reserved.
 * Available via the MIT or new BSD license.
 * see: http://github.com/jrburke/almond for details
 */
//Going sloppy to avoid 'use strict' string cost, but strict practices should
//be followed.
/*jslint sloppy: true */
/*global setTimeout: false */
var requirejs,require,define;(function(e){function a(e,t){var n=t&&t.split("/"),i=r.map,s=i&&i["*"]||{},o,u,a,f,l,c,h;if(e&&e.charAt(0)==="."&&t){n=n.slice(0,n.length-1),e=n.concat(e.split("/"));for(l=0;h=e[l];l++)if(h===".")e.splice(l,1),l-=1;else if(h===".."){if(l===1&&(e[2]===".."||e[0]===".."))return!0;l>0&&(e.splice(l-1,2),l-=2)}e=e.join("/")}if((n||s)&&i){o=e.split("/");for(l=o.length;l>0;l-=1){u=o.slice(0,l).join("/");if(n)for(c=n.length;c>0;c-=1){a=i[n.slice(0,c).join("/")];if(a){a=a[u];if(a){f=a;break}}}f=f||s[u];if(f){o.splice(0,l,f),e=o.join("/");break}}}return e}function f(t,n){return function(){return u.apply(e,s.call(arguments,0).concat([t,n]))}}function l(e){return function(t){return a(t,e)}}function c(e){return function(n){t[e]=n}}function h(r){if(n.hasOwnProperty(r)){var s=n[r];delete n[r],i[r]=!0,o.apply(e,s)}if(!t.hasOwnProperty(r))throw new Error("No "+r);return t[r]}function p(e,t){var n,r,i=e.indexOf("!");return i!==-1?(n=a(e.slice(0,i),t),e=e.slice(i+1),r=h(n),r&&r.normalize?e=r.normalize(e,l(t)):e=a(e,t)):e=a(e,t),{f:n?n+"!"+e:e,n:e,p:r}}function d(e){return function(){return r&&r.config&&r.config[e]||{}}}var t={},n={},r={},i={},s=[].slice,o,u;o=function(r,s,o,u){var a=[],l,v,m,g,y,b;u=u||r;if(typeof o=="function"){s=!s.length&&o.length?["require","exports","module"]:s;for(b=0;b<s.length;b++){y=p(s[b],u),m=y.f;if(m==="require")a[b]=f(r);else if(m==="exports")a[b]=t[r]={},l=!0;else if(m==="module")v=a[b]={id:r,uri:"",exports:t[r],config:d(r)};else if(t.hasOwnProperty(m)||n.hasOwnProperty(m))a[b]=h(m);else if(y.p)y.p.load(y.n,f(u,!0),c(m),{}),a[b]=t[m];else if(!i[m])throw new Error(r+" missing "+m)}g=o.apply(t[r],a);if(r)if(v&&v.exports!==e&&v.exports!==t[r])t[r]=v.exports;else if(g!==e||!l)t[r]=g}else r&&(t[r]=o)},requirejs=require=u=function(t,n,i,s){return typeof t=="string"?h(p(t,n).f):(t.splice||(r=t,n.splice?(t=n,n=i,i=null):t=e),n=n||function(){},s?o(e,t,n,i):setTimeout(function(){o(e,t,n,i)},15),u)},u.config=function(e){return r=e,u},define=function(e,t,r){t.splice||(r=t,t=[]),n[e]=[e,t,r]},define.amd={jQuery:!0}})();