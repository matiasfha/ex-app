define [
	'jquery'
	'backbone'
	'models/resource'
	'text!templates/visor.hbs'
],($,Backbone,ResourceModel,VisorTPL) ->
	class VisorView extends Backbone.View
		el:$('#templating')
		events:
			'mouseenter .rating .star':'ratingON'
			'mouseleave .rating .star':'ratingOFF'
			'click .rating .star':'ratingSet'
			'mouseenter .thi':'showOverlay'
			'mouseleave .thi':'hideOverlay'

		initialize:(@parent) ->
			@tpl = eval(VisorTPL)
			@id = parent.attr('id')
			@model = new ResourceModel
				id:@id
			@model.fetch()
			@model.on 'change',() =>
				@render()
			
		render: =>
			html = @tpl @model.toJSON()
			$(@el).append(html)
			$('#visor-modal').reveal
				animation:'fadeAndPop'
				closed: () => 
					@close()

		close: =>
			$(@el).empty()
			$(@el).undelegate()

		showOverlay:(e) =>
			$(e.currentTarget).find('.overlay').show()

		hideOverlay:(e) =>
			$(e.currentTarget).find('.overlay').hide()	


		ratingON:(e) ->
			$(e.currentTarget).prevAll().andSelf().addClass('on')
			$(e.currentTarget).nextAll().removeClass('on')

		ratingOFF:(e) ->
			$(e.currentTarget).prevAll().andSelf().removeClass('on')

		ratingSet:(e) =>
			$(e.currentTarget).siblings('.voted').andSelf().removeClass 'voted'
			elems = $(e.currentTarget).siblings('.on').andSelf()
			elems.addClass 'voted'
			count = elems.length
			
			$.post "/votos/#{@id}/#{count}",(data) =>
				if data.result == true
					html = "#{data.promedio}/#{data.total}"
					$('#visor-modal').find('.votos_count').html html
					$("##{@id}").find('.votos_count').html html
					html = ''
					for i in [1..data.promedio]
						html+='<img src="/assets/STAR_ON.gif"/>'
					for i in [data.promedio...5]
						html+='<img src="/assets/STAR_OFF.gif"/>'	
					$('#visor-modal').find('.estrellas').html html
					$("##{@id}").find('.estrellas').html html


