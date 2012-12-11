require.config
	shim:
		'modernizr':
			exports:'Modernizr'
		'jquery.ba-cond.min':['jquery']
		'jquery.slitslider':['jquery','modernizr']
		'jquery.isotope':['jquery']

require [
	'jquery'
	'jquery.ba-cond.min'
	'jquery.slitslider'
	'domReady'
	'jquery.isotope'
],($,B,S,domReady,I) ->
	domReady () ->
		Page = (->
		  $nav = $("#nav-dots > span")
		  slitslider = $("#slider").slitslider(onBeforeChange: (slide, pos) ->
		    $nav.removeClass "nav-dot-current"
		    $nav.eq(pos).addClass "nav-dot-current"
		  )
		  init = ->
		    initEvents()

		  initEvents = ->
		    $nav.each (i) ->
		      $(this).on "click", (event) ->
		        $dot = $(this)
		        unless slitslider.isActive()
		          $nav.removeClass "nav-dot-current"
		          $dot.addClass "nav-dot-current"
		        slitslider.jump i + 1
		        false



		  init: init
		)()
		Page.init()
		$('#tw').on 'click',(e) ->
			console.log e
		$('body').imagesLoaded () ->
			$('#slider').fadeIn()
