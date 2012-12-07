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
		'jquery.easing.1.3':['jquery']
		

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
	'jquery.easing.1.3'
],($,_,Backbone,Isotope,domReady,M,T,F,S,D,Ser,E) ->
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
		#Mostrar feedback Panel
		$('#feedback-panel #tab').on 'click',(e) ->
			if $(e.currentTarget).hasClass 'active'
				left = '96%';
			else
				left = '66%';
			$('#feedback-panel').animate({left:left})

			$(e.currentTarget).toggleClass 'active'

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

		$('.entry-content').live 'mouseenter', (e) ->
			$(e.currentTarget).find('.zoomOverlay').fadeIn();
		.live 'mouseleave',(e) ->
			$(e.currentTarget).find('.zoomOverlay').fadeOut();
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
		$('article .entry-content').live 'click', (e) ->
			id = $(e.currentTarget).closest('article').attr('id')
			$.get  "/resources/#{id}", (data) ->
				h = $(document).height()+'30'
				w = $(document).width()
				$('#theMask').css 
					'height':h
					'width':w
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
		$('#theMask').live 'click',(e) ->
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
		
		commentTPL = _.template( """
		<div id="<%=user_id%>" class="<%=clase%>">
	          <span>
	            <a href="#">
	              <img src="<%=avatar%>" alt="user" width="30" height="30" border="0">
	            </a>
	          </span>
	          <div class="detail">
	            <h2><a href="#"><%user_nickname%></a></h2>
	            <p><%=contenido%></p>
	          </div>
	          <div class="dataUser"><%=fecha%></div>   
	        </div>
		""")

		$('#comment_contenido').live 'keypress', (e) ->
			if e.which == 13
				data = $('#new_comment').serializeObject()
				$.post $('#new_comment').attr('action'),data,(res) ->
					$('#comment_contenido').val('')
					html = $(commentTPL(res))
					html.addClass('highlight')
					$('#comments').append html 
					$('#comments').animate({scrollTop: $('#comments').prop("scrollHeight")}, 500);
					setTimeout () ->
						html.removeClass('highlight')
					,1200

				e.preventDefault()
				e.stopPropagation()
		$('.ver_mas').live 'click',(e) ->
			target = $(e.currentTarget)
			#target.find()  Mostrar el resto de los comentarios.. ir a buscarlos a la BD
		
		$('#new_feedback').submit (e) ->
			e.stopPropagation()
			e.preventDefault()
			data = $('#new_feedback').serializeObject()
			html = '<img src="/assets/ajax-loader.gif" class="load"/>'
			content = $('#contentForm').html() 
			$('#contentForm').empty().html html
			$.post  '/feedback',data, (resp) ->
				if resp.success == true
					htm = '<label class="load">Gracias por tus comentarios</label>'
					$('#contentForm').empty().html html
					$('#feedback-panel').delay(2000)
					.animate({left:'96%'})
					$('#feedback-panel #tab').toggleClass 'active'
				else
					$('#contentForm').html content
					$('#new_feedback').reset()
					Recaptcha.reload();
					if resp.mensaje == 'recaptcha'
						$('#recaptcha_response_field').addClass 'error'
					else if resp.mensaje == 'email'
						$('#email').addClass 'error'





