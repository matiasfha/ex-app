/*
 * cond - v0.1 - 6/10/2009
 * http://benalman.com/projects/jquery-cond-plugin/
 * 
 * Copyright (c) 2009 "Cowboy" Ben Alman
 * Licensed under the MIT license
 * http://benalman.com/about/license/
 * 
 * Based on suggestions and sample code by Stephen Band and DBJDBJ in the
 * jquery-dev Google group: http://bit.ly/jqba1
 */
(function(e){e.fn.cond=function(){var t,n=arguments,r=0,i,s,o;while(!i&&r<n.length)i=n[r++],s=n[r++],i=e.isFunction(i)?i.call(this):i,o=s?i?s.call(this,i):t:i;return o!==t?o:this}})(jQuery);