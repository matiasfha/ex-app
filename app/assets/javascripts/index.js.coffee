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
		'jquery.infinitescroll.min':['jquery']
		'dropdown':['jquery']
		'jquery.serializeObject':['jquery']

require [
	'jquery'
	'underscore-min'
	'backbone-min'
	'jquery.isotope'
	'domReady'
	'modernizr'
	'froogaloop2.min'
	'jquery.infinitescroll.min'
	'dropdown'
	'jquery.serializeObject'
],($,_,Backbone,Isotope,domReady,M,T,F,S,D,Ser) ->
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

		$('li#negocio').click (e) ->
			$('li#negocio ul').toggle()
			$('li#negocio').toggleClass('active')

		$('#entry-listing').imagesLoaded () ->
			$('#entry-listing').isotope(
				animationOptions: 
					duration: 750
					easing: 'linear'
					queue: false
				
				itemSelector: 'article.entry'
				transformsEnabled: false
				layoutMode: 'masonry'
				resizesContainer: true
				animationEngine:'jquery'
			)
			items = $('#entry-listing article.entry')
			$('#entry-listing').empty()
			$('#entry-listing').fadeIn()
			$('#entry-listing').isotope 'insert',items, () ->
				$('#entry-listing').isotope('reLayout')

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

		#Eventos para la ventana modal
		#Tabs 
		setTabs = () ->
			$('#modal #dos').hide()
			$('ul.idTabs li').live 'click', (e) ->
				$('ul.idTabs  li').removeClass('onTab')
				$('#uno,#dos').hide()
				activeTab = $(this).attr('data-tab')
				$(activeTab).show()
				$(e.currentTarget).addClass('onTab')
				.addClass('onWord')
				.removeClass('offWord')
		setTabs()

		ratingStar =  ->
			$('#rating .star').live 'mouseenter', (e) ->
				lis = $(e.currentTarget).prevAll().andSelf().children()
				lis.addClass('starOn').removeClass('starOff')
				lis = $(e.currentTarget).nextAll().children()
				lis.removeClass('starOn').addClass('starOff')
				e.stopPropagation()
			.live 'mouseleave', (e) ->
				lis = $(e.currentTarget).prevAll().andSelf().children(':not(.voted)')
				lis.removeClass('starOn').addClass('starOff')
				e.stopPropagation()
			.live 'click',(e) ->
				$(e.currentTarget).siblings('.voted').andSelf().removeClass 'voted'
				elems = $(e.currentTarget).siblings().andSelf()
				elems = elems.children('.starOn')
				elems.addClass 'voted'
				nota = $(e.currentTarget).children().html()
				resource_id = $('#rating').attr('data-id')
				$.ajax
					url: "/votos/#{resource_id}/#{nota}"
					type:'POST'
					success: (data) ->
						total = data.total
						promedio = data.promedio

						$('div.bigStar span').text promedio
						$('#votoWord').text "#{total} votos"
					error:(d) ->
						alert 'Error'
						console.log d.responseText
				false
		ratingStar()

		#OnClick en un element
		$('article').live 'click', (e) ->
			id = $(e.currentTarget).attr('id')
			$.get  "/resources/#{id}", (data) ->
				h = $(document).height()+'30'
				w = $(document).width()
				$('#contenedor-modal').css 
					'height':h
					'width':w
				.html(data).fadeIn()
				setTabs()
				ratingStar()

		$('#contenedor-modal .paddr10').live 'click', (e) ->
			e.preventDefault()
			$('#contenedor-modal').fadeOut().empty();
			false

		
		$('#entry-listing').infinitescroll
			navSelector:'#navSelector'
			nextSelector:'#nextpage'
			itemSelector:'article.entry'
			loading:
				img:"/assets/ajax-loader.gif"
				finishedMsg:"Ya no quedan más elementos..."
				msgText:"<em>Cargando recursos..</em>"
			
		, (data) ->
			$(data).imagesLoaded () ->
				$('#entry-listing').isotope('appended',$(data)).isotope('reLayout')
		
		$('#comment_descripcion').keypress (e) ->
			if e.which == 13
				data = $('#new_comment').serializeObject
				console.log data
				e.preventDefault()
				e.stopPropagation()

		
					




