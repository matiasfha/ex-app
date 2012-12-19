class (namespace 'Dandoo').Modal extends Backbone.View
	events:
		'click ul.idTabs li'			:	'showTab'
		'mouseenter #rating .star':	'onStar'
		'mouseleave #rating .star':	'offStar'
		'click #rating .star'			:	'Vote'
		'click  a#close'				: 	'cerrarModal'
		'click a.ctwitter,a.cfacebook':	'compartir'
	initialize: ()->
		if @model?
			@html = HandlebarsTemplates['show'](@model[0])
			$('#contenedor-modal').off('click').on 'click',@cerrarModal
			@render()
		else
			$('#modal #dos').hide()
		
	render: =>
		@positionOriginal = $(window).scrollTop()
		h = $(document).height()+'3'
		w = $(document).width()
		$('#contenedor-modal').css
			'height':h
		.html(@html)

		$('#theMask').css 
			'height':h
			'width':w
		.slideDown 'slow', () =>
			$('#contenedor-modal').imagesLoaded () ->
				$('#contenedor-modal').show()
				$('#modal #dos').hide()
			$(window).scrollTop(0)
			
		


	showTab: (e) ->
		target = $(e.currentTarget)
		$('ul.idTabs  li').removeClass('onTab')
		$('#uno,#dos').hide()
		activeTab = target.attr('data-tab')
		$(activeTab).show()
		target.addClass('onTab')
		.addClass('onWord')
		.removeClass('offWord')

	onStar: (e) ->
		target = $(e.currentTarget)
		lis = target.prevAll().andSelf().children()
		lis.addClass('starOn').removeClass('starOff')
		lis = target.nextAll().children()
		lis.removeClass('starOn').addClass('starOff')
		e.stopPropagation()
	offStar: (e) ->
		lis = $(e.currentTarget).prevAll().andSelf().children(':not(.voted)')
		lis.removeClass('starOn').addClass('starOff')
		e.stopPropagation()
	Vote:(e) ->
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
				s = 'votos'
				if total == 1
					s = 'voto'

				$("article##{resource_id}").find('.heart-no').html(promedio+'/'+total+' '+s)
		false

	

	cerrarModal: (e) =>
		currentTarget = e.currentTarget
		target 			= e.target
		if currentTarget==target || currentTarget==$('a#close')
			e.stopPropagation()
			e.preventDefault()
			$('#contenedor-modal').hide().empty()
			$('#theMask').slideUp 'slow', () =>
				$(window).scrollTop(@positionOriginal)
			false
			
	compartir: (e) ->
		e.preventDefault()
		e.stopPropagation()
		url = $(e.currentTarget).attr('href')
		width  = 775
		height = 400
		left   = ($(window).width()  - width)  / 2
		top    = ($(window).height() - height) / 2
		opts   = "status=1,width=#{width},height=#{height},top=#{top},left=#{left}"
		window.open(url, 'Comparte con tus amigos', opts);
		false

	