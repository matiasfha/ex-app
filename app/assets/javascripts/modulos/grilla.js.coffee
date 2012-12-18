class (namespace 'Dandoo').Grilla extends Backbone.View
	el: $('#entry-listing')
	events: 
		'mouseenter .entry-content'	: 'showOverlay'
		'mouseleave .entry-content'	: 'hideOverlay'
		'click article .entry-content'	: 'showElement'
		
	initialize: ->
		@responsive()
		@cargaGrilla()
		$('#ver_mas').off('click').live 'click', @loadMore
		$('article .entry-content').off('click').live 'click',@showElement
		#@infinitescroll()


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
				transformsEnabled: true
				# layoutMode:	'masonry'
				resizeContainer:	true
				animationEngine: 'best-available'

			items	= $('#entry-listing article.entry')
			$(@el).empty().fadeIn()
			.isotope 'insert',items,() =>
				$(@el).isotope 'reLayout'
				$('#loader').hide()

	loadMore: (e) =>
		$("#infscr-loading label").text('Cargando contenido...')
		$("#infscr-loading").show()
		boton = $('#ver_mas')
		url = boton.attr('data-seccion').split('/')
		num = parseInt(url[3]) + 1
		url = "/#{url[1]}/#{url[2]}/#{num}"
		$.get url, (data) ->
			if data.length > 0
				$(data).imagesLoaded () ->
					$('#entry-listing').isotope('insert',$(data)).isotope('reLayout')
					$("html, body").animate({ scrollTop: $(document).height() });
					# $('#ver_mas_container').css('bottom','0px')

					$("#infscr-loading").hide()	

			else
				$("#infscr-loading label").text('No hay mas contenido')
				$("#infscr-loading").delay(4000).hide()
			boton.attr('data-seccion',url)	
		false

	infinitescroll: =>
		$(@el).infinitescroll
			navSelector:'#navSelector'
			nextSelector:'#nextpage'
			itemSelector:'article.entry'
			loading:
				img:"/assets/ajax-loader.gif"
				finishedMsg:"Ya no quedan más elementos..."
				msgText:"<em>Cargando recursos..</em>"
			path:(pageNumber) ->
				url = $('#navSeccion').attr('data-seccion').split '/'
				url = "/#{url[1]}/#{url[2]}/#{pageNumber}"
				$('#navSeccion').attr 'data-seccion',url
				console.log 'Scroll ' + url
				url
			
		, (data) =>
			$(data).imagesLoaded () =>
				$(@el).isotope('appended',$(data)).isotope('reLayout')


	showElement: (e) ->
		id = $(e.currentTarget).closest('article').attr('id')
		
		$.get  "/resources/#{id}.json", (data) ->
			postman.deliver('modal-activo',[data])
	