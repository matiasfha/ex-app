require.config
	shim:
		'modernizr':
			exports:'Modernizr'
		'jquery.isotope':['jquery']
		'underscore-min':
			exports:'_'
		'jquery.infinitescroll.min':['jquery']
		'dropdown':['jquery']
		'jquery.serializeObject':['jquery']
		'handlebars.runtime':
			exports:'Handlebars'
		'jquery.pjax':['jquery']
		

require [
	'jquery'
	'jquery.isotope'
	'domReady'
	'froogaloop2.min'
	'jquery.infinitescroll.min'
	'dropdown'
	'jquery.serializeObject'
	'text!templates/show.hbs'
	'text!templates/comentario.hbs'
	'jquery.pjax'
],($,Isotope,domReady,F,S,D,Ser,TPL,CTPL,pjax) ->
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
		
		#console.log $('ul.menu a').pjax('[data-pjax-container]')

		TPL = eval(TPL)
		
		    

		showMask = () ->
			part = window.location.href.split('/')[3]
			if part == "resources"
				h = $(document).height()+'30'
				w = $(document).width()
				$('#theMask').css 
					'height':h
					'width':w
		showMask()
		
		$('li#negocio').click (e) ->
			$('li#negocio ul').toggle()
			$('li#negocio').toggleClass('active')

		#Carga grilla isotope
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
			$('#entry-listing').empty().fadeIn()
			$('#entry-listing').isotope 'insert',items, () ->
				$('#entry-listing').isotope('reLayout')
				$('#loader').hide()
		
		#Cargar contenidos con scroll infinito
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
		

		#Para que el contenedor sea responsive
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

		#Muestra el overlay sobre los items al pasar el mouse
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
				nota = $('a.voted').length
				resource_id = $('#rating').attr('data-id')
				$.ajax
					url: "/votos/#{resource_id}/#{nota}"
					type:'POST'
					success: (data) ->
						total = data.total
						promedio = data.promedio

						$('div.bigStar span').text promedio
						$('#votoWord').text "#{total} votos"
						$("article##{resource_id}").find('.heart-no').html(promedio+'/'+total+' votos')
				false
		ratingStar()

		#OnClick en un element mostrar el modal
		$('article .entry-content').live 'click', (e) ->
			id = $(e.currentTarget).closest('article').attr('id')
			$.get  "/resources/#{id}.json", (data) ->
				html = TPL(data)
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
				setTabs()
				ratingStar()

		#Cerrar el modal con el recursos
		$('#contenedor-modal .paddr10').live 'click', (e) ->
			e.preventDefault()
			$('#contenedor-modal').fadeOut().empty();
			false
		$('#theMask').live 'click',(e) ->
			e.preventDefault()
			$('#contenedor-modal').fadeOut().empty();
			false
		
		$('a.ctwitter,a.cfacebook').live 'click',(e) ->
			e.preventDefault()
			e.stopPropagation()
			url = $(this).attr('href')
			width  = 775
			height = 400
			left   = ($(window).width()  - width)  / 2
			top    = ($(window).height() - height) / 2
			opts   = "status=1,width=#{width},height=#{height},top=#{top},left=#{left}"
			window.open(url, 'Comparte en Twitter', opts);
			false

		#Template para comentario nuevo
		commentTPL = eval(CTPL)
		#Enviar comentario al servidor
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
			resource_id = target.attr('data-resource')
			target.html('Cargando....')
			$.get '/comments',{resource_id:resource_id}, (e) ->
				$('#comments').fadeOut () ->
					$(this).html (e)
					$(this).fadeIn () ->
						target.remove()
		
		#Mostrar feedback Panel
		$('#feedback-panel #tab').on 'click',(e) ->
			if $(e.currentTarget).hasClass 'active'
				right = '-245px'
			else
				right = '134px';
			$('#feedback-panel').animate({right:right})

			$(e.currentTarget).toggleClass 'active'
		
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
					$('#feedback-panel').delay(3000)
					.animate({right:'-245px'})
					$('#feedback-panel #tab').toggleClass 'active'
					$('#contentForm').html content
					$('#new_feedback').reset()
				else
					$('#contentForm').html content
					$('#new_feedback').reset()
					Recaptcha.reload();
					if resp.mensaje == 'recaptcha'
						$('#recaptcha_response_field').addClass 'error'
					else if resp.mensaje == 'email'
						$('#email').addClass 'error'





