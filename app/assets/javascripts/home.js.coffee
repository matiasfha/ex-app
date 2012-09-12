$(document).ready () ->
	$('.comments').click (e) ->
		target = $(e.currentTarget)
		picture_id = target.attr('data-id')
		lista      = $("##{picture_id} .comment-list")
		$('.comment-list').removeClass('active')
		lista.toggleClass('active').slideToggle()
		$('.comment-list:not(.active)').slideUp()
		e.preventDefault()
		e.stopPropagation()
		false

	$('.ver-comentarios').live 'ajax:success', (e,data) ->
		target = $(e.currentTarget)
		picture_id = target.attr('data-id')
		# $.get '/comments',{picture_id:picture_id},(data) ->
		$("##{picture_id} .listado").html(data)
		target.remove()

	$('.imagen .well').hover (e) ->
		target = $(e.currentTarget)
		picture_id = target.attr('id')
		$("##{picture_id} .titulo").toggle();
	
	$('textarea').keydown (e) ->
		if e.which == 13
			e.preventDefault()
			e.stopPropagation()
			$(e.currentTarget).submit()
	.autoGrow()

	$('form[data-remote]').live 'ajax:success', (e,data) ->
		form = $(e.currentTarget).serializeObject()
		picture_id = form.comment.picture_id
		html = $(data)
		$("##{picture_id} .comment-list .comment-container").append(html)
		$("##{picture_id} textarea").val("")

		total = Number($("##{picture_id} .comments").attr('data-total'))+1
		html = """<icon class="icon-comment"></icon>#{total}"""
		$("##{picture_id} .comments").attr('data-total',total).html(html)
		




	$('.likes').click (e) ->
		e.preventDefault()
		e.stopPropagation()
		picture_id = $(e.currentTarget).attr('data-id')

		$.post '/picture/add_like',{id:picture_id},(data) -> 
			html = """<i class="icon-heart" ></i>#{data}"""
			$(e.currentTarget).html(html)
		false