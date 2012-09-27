// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.effects.core
//= require jquery.effects.highlight
//= require jquery.effects.slide
//= require jquery.remotipart
//= require jquery.sausage.min
//= require twitter/bootstrap
// require_tree .


$(document).ready(function(){

	$.fn.reset = function(){
		$(this).each (function(){ this.reset(); });
	};

	 $.fn.serializeObject = function() {
		if ( this.length < 1) { 
	      return false; 
	    }

	    var $el = this;
	    var data = {};
	    var lookup = data; //current reference of data

	    $el.find( ':input[type!="checkbox"][type!="radio"], input:checked' ).each( function() {
	      // data[a][b] becomes [ data, a, b ]
	      var named = this.name.replace(/\[([^\]]+)?\]/g, ',$1').split(',');
	      var cap = named.length - 1;

	      // Ensure that only elements with valid `name` properties will be serialized
	      if ( named[ 0 ] ) {
	        for ( var i = 0; i < cap; i++ ) {
	            // move down the tree - create objects or array if necessary
	            lookup = lookup[ named[i] ] = lookup[ named[i] ] ||
	                ( named[ i + 1 ] === "" ? [] : {} );
	        }

	        // at the end, push or assign the value
	        if ( lookup.length !==  undefined ) {
	             lookup.push( $( this ).val() );
	        }else {
	              lookup[ named[ cap ] ]  = $( this ).val();
	        }

	        // assign the reference back to root
	        lookup = data;
	      }
	    });

	    return data;
	  };

	if ($('.alerta').length > 0){
		$.pnotify({
			title:$('.alerta').attr('data-title'),
			text:$('.alerta').attr('data-text'),
			opacity: .8
		});	
	}

	$('#principal').imagesLoaded(function(){
		$('#loading').hide();
		$('#principal').fadeIn();
	});

	//PAGINATION
	var contenedor = $('.imagenes');
	if(contenedor.length > 0){
		var page = 1,loading = false;
		function nearBottomOfPage(){
			return $(window).scrollTop() > $(document).height() - $(window).height() - 200;
		}

		$(window).scroll(function(){
			if(loading){
				return;
			}
			if(nearBottomOfPage()){
				loading = true;
				page++;
				$.get('/pictures',{page:page},function(data){
						
						setTimeout(function(){
							div = $('<div class="pagination" style="display:none"></div>')
							div.append(data);
							div.imagesLoaded(function(){
								$('div.contenido').append(div);		
								div.fadeIn('slow');
							});
							
							$(window).sausage();
							loading = false;
							
						},250);
						
						
				},'html');
				
			}
		});

		$(window).sausage();
	}else{
		console.log('No Sausage');
	}
	

	
});