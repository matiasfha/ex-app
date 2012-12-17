class (namespace 'Dandoo').Modal extends Backbone.View
	el: $('#contenedor-modal')
	events:
		'click ul.idTabs li'			:	'showTab'
		'mouseenter #rating .star':	'onStar'
		'mouseleave #rating .star':	'offStar'
		'click #rating .star'			:	'Vote'
	initialize: ->
		$('#modal #dos').hide()
		@ratingStar()
		@removeEvents()
		@cerrarModal()
		@compartir()


	showTab: =>
		$('ul.idTabs  li').removeClass('onTab')
		$('#uno,#dos').hide()
		activeTab = $(this).attr('data-tab')
		$(activeTab).show()
		$(e.currentTarget).addClass('onTab')
		.addClass('onWord')
		.removeClass('offWord')

	ratingStar: =>
		$('#rating .star').on 'mouseenter', (e) ->
			target = $(this)
			lis = target.prevAll().andSelf().children()
			lis.addClass('starOn').removeClass('starOff')
			lis = target.nextAll().children()
			lis.removeClass('starOn').addClass('starOff')
			e.stopPropagation()
		.on 'mouseleave', (e) ->
			lis = $(e.currentTarget).prevAll().andSelf().children(':not(.voted)')
			lis.removeClass('starOn').addClass('starOff')
			e.stopPropagation()
		.on 'click',(e) ->
			target = $(e.currentTarget)
			target.siblings('.voted').andSelf().removeClass 'voted'
			elems = target.siblings().andSelf()
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

	removeEvents: =>
		postman.receive 'destroyModal-events', () ->
			$('ul.idTabs li').off 'click'

	cerrarModal: =>
		$('#contenedor-modal .paddr10').on 'click', (e) ->
			e.preventDefault()
			$('#contenedor-modal').fadeOut().empty();
			postman.deonr('destroyModal-events')
			false
		$('#theMask').on 'click',(e) ->
			e.preventDefault()
			$('#contenedor-modal').fadeOut().empty();
			postman.deonr('destroyModal-events')
			false

	compartir: =>
		$('a.ctwitter,a.cfacebook').on 'click',(e) ->
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