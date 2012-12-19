#=require jquery
#=require jquery.isotope
#=require froogaloop2.min
#=require jquery.infinitescroll.min
#=require dropdown
#=require jquery.serializeObject
#=require underscore-min
#=require backbone-min
#=require namespace.min
#=require postman.min
#=require jquery.pjax

#Templates
#=require handlebars.runtime
#=require helpers/handlebars
#=require templates/show.hbs
#=require templates/comentario.hbs

#Carga de modulos
#=require helpers/setup
#=require modulos/grilla
#=require modulos/feedback
#=require modulos/modal

(namespace 'Dandoo').VERSION = 1.0

(namespace 'Dandoo').urlForScroll = $('#navSeccion').attr('data-seccion')





$(document).ready () ->
	app = (namespace 'Dandoo')
	new app.Setup()
	grilla = new app.Grilla()
	new app.Feedback()
	
	loader = $('#loader')
	$(document).pjax('.menu a', '[data-pjax-container]')
	.on 'pjax:start', () ->
	  	loader.show()
	.on 'pjax:end', (e,d) ->
		container = $('#entry-listing')
		container.imagesLoaded () ->
			container.isotope
				animationOptions:
					duration:	550
					easing:		'linear'
					queue:		false
				itemSelector:	'article.entry'
				transformsEnabled: false
				layoutMode:	'masonry'
				resizeContainer:	true

			items	= $('#entry-listing article.entry')
			container.empty().fadeIn().css('margin-left','76px')
			container.isotope 'insert',items, () ->
				container.isotope 'reLayout'
				loader.hide()
				


	part = window.location.href.split('/')[3]
	if part == "resources"
		h = $(document).height()+'30'
		w = $(document).width()
		$('#theMask').css 
			'height':h
			'width':w
		postmain.deliver 'modal-activo',null
		#new app.Modal({el:$('#modal'),model:null})

	postman.receive 'modal-activo',(data) ->
		new app.Modal({el:$('#contenedor-modal'),model:data})
		