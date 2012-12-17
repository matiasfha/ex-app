class (namespace 'Dandoo').Grilla extends Backbone.View
	el: $('#entry-listing')
	events: 
		'mouseenter .entry-content': 'showOverlay'
		'mouseleave .entry-content':'hideOverlay'
		'click article .entry-content':'showElement'
	initialize: ->
		@responsive()
		@cargaGrilla()
		@infinitescroll()

	showOverlay: (e )->
		$(e.currentTarget).find('.zoomOverlay').fadeIn()

	hideOverlay: (e) ->
		$(e.currentTarget).find('.zoomOverlay').fadeOut();

	responsive: =>
		box = $(".box")
		setContainerWidth =  ->
			columnNumber = parseInt(($(window).width() + 15) / box.outerWidth(true))
			containerWidth = (columnNumber * box.outerWidth(true)) - 15

			if  columnNumber > 1
		    		$("#box-container").css("width",containerWidth+'px')
			else
				$("#box-container").css("width", "90%")
		setContainerWidth();
		$(window).resize(setContainerWidth)
		
	cargaGrilla: =>
		$(@el).imagesLoaded () =>
			$(@el).isotope
				animationOptions:
					duration:	550
					easing:		'linear'
					queue:		false
				itemSelector:	'article.entry'
				transformsEnabled: false
				layoutMode:	'masonry'
				resizeContainer:	true

			items	= $('#entry-listing article.entry')
			$(@el).empty().fadeIn()
			.isotope 'insert',items,() =>
				$(@el).isotope 'reLayout'
				$('#loader').hide()

	infinitescroll: =>
		$(@el).infinitescroll
			navSelector:'#navSelector'
			nextSelector:'#nextpage'
			itemSelector:'article.entry'
			loading:
				img:"/assets/ajax-loader.gif"
				finishedMsg:"Ya no quedan más elementos..."
				msgText:"<em>Cargando recursos..</em>"
			
		, (data) =>
			$(data).imagesLoaded () =>
				$(@el).isotope('appended',$(data)).isotope('reLayout')

	showElement: (e) ->
		id = $(e.currentTarget).closest('article').attr('id')
		
		$.get  "/resources/#{id}.json", (data) ->
			html = HandlebarsTemplates['show'](data)
			h = $(document).height()+'30'
			w = $(document).width()
			$('#theMask').css 
				'height':h
				'width':w
			
			$('#contenedor-modal').css 
				'height':h
				'width':w
			.html(html).fadeIn()

			$('body').animate({scrollTop: 0}, 500);
			postmain.deliver('modal-activo')
	