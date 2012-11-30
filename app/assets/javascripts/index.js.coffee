require.config
	shim:
		'modernizr':
			exports:'Modernizr'
		'jquery.isotope':['jquery']
		'jquery.fitvids':['jquery']
		'jquery.flexislider-min':['jquery']
		'underscore-min':
			exports:'_'
		'backbone-min':
			deps:['underscore-min']
			exports:'Backbone'

require [
	'jquery'
	'underscore-min'
	'backbone-min'
	'jquery.isotope'
	'domReady'
	'modernizr'
],($,_,Backbone,Isotope,domReady,M,T) ->
	domReady () ->
		$.fn.reset = ->
			$(this).each () ->
				this.reset()

		token = $('meta[name="csrf-token"]').attr('content')
		param = $('meta[name="csrf-param"]').attr('content')
		$.ajaxSetup
			beforeSend: (xhr) ->
				xhr.setRequestHeader('X-CSRF-Token', token);
			cache: false

		$('#entry-listing').isotope(
			animationOptions: 
				duration: 750
				easing: 'linear'
				queue: false
			
			itemSelector: 'article.entry'
			transformsEnabled: false
			layoutMode: 'masonry'
			resizesContainer: true
		)

		$(window).resize(setContainerWidth)
		box = $(".box")
		
		setContainerWidth =  ->
			columnNumber = parseInt(($(window).width() + 15) / box.outerWidth(true))
			containerWidth = (columnNumber * box.outerWidth(true)) - 15

			if  columnNumber > 1
		    		$("#box-container").css("width",containerWidth+'px')
			else
				$("#box-container").css("width", "90%")

		setContainerWidth();

		#Tabs 
		setTabs = () ->
			$('#modal #dos').hide()
			$('ul.idTabs li').live 'click', (e) ->
				$('ul.idTabs  li').removeClass('onTab')
				console.log $('#uno')
				$('#uno,#dos').hide()
				activeTab = $(this).attr('data-tab')
				$(activeTab).show()
				$(e.currentTarget).addClass('onTab')
				.addClass('onWord')
				.removeClass('offWord')
		setTabs()

		#OnClick en un element
		$('article').live 'click', (e) ->
			id = $(e.currentTarget).attr('id')
			$.get  "/resources/#{id}", (data) ->
				h = $(document).height()+'30'
				$('#contenedor-modal').css({'height':h}).html(data).fadeIn()
				setTabs()
			

		$('#contenedor-modal .paddr10').live 'click', (e) ->
			e.preventDefault()
			$('#contenedor-modal').fadeOut().empty();
			false

		$('#mas_votados').click (e) ->
			$.get "/recursos/mas_votados",(data) ->
				items = $('#entry-listing article')
				$('#entry-listing').isotope 'insert',$(data), () ->
					$('#entry-listing').isotope 'remove', items	
					$('#entry-listing') .isotope('reLayout')

		$('#mas_comentados').click (e) ->
			$.get "/recursos/mas_comentados",(data) ->
				items = $('#entry-listing article')
				$('#entry-listing').isotope 'insert',$(data), () ->
					$('#entry-listing').isotope 'remove', items	
					$('#entry-listing') .isotope('reLayout')

		$('#nuevos').click (e) ->
			$.get "/recursos/nuevos",(data) ->
				items = $('#entry-listing article')
				$('#entry-listing').isotope 'insert',$(data), () ->
					$('#entry-listing').isotope 'remove', items	
					$('#entry-listing') .isotope('reLayout')

				
				
					




