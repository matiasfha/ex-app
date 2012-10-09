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
//= require modernizr-2.6.1-respond-1.1.0.min
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require twitter/bootstrap
//= require jquery.imagesloaded.min
//= require jquery.masonry.min
//= require video.min
//= require jquery.pnotify
//= require froogaloop2.min
// require_tree .


$(document).ready(function(){



    _V_.options.flash.swf = "video-js.swf";
  
	$.fn.reset = function(){
		$(this).each (function(){ 
			this.reset(); 
			$(this).removeAttr('disabled');
		});
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

	
	//Carga el player de Youtube asincrono
	loadYoutubePlayer = function(video_id, player_id) {

  		var done, onPlayerStateChange, onYouTubeIframeAPIReady, player;
  		player = null;
  		onYouTubeIframeAPIReady = function(video_id, player_id) {
  			player = new YT.Player('ytplayer', {
      			width: '700',
				height: '525',
				videoId: video_id,
				playerVars: {
					autoplay: 1,
					controls: 1,
					enablejsapi: 1,
					showinfo: 0,
					iv_load_policy: 3,
					color: 'white',
					theme: 'light',
					origin: 'http://127.0.0.1:8080',
					autohide: 1,
					disablekb: 1,
					modestbranding: 1,
					playerpiid: player_id,
					rel: 0
				},
				events: {
					'onReady': onPlayerReady,
					'onStateChange': onPlayerStateChange
				}
			});
			return player;
		};

	onPlayerReady = function(event){
  		event.target.playVideo();
  		done = false;
  		return done;
  	};

  	onPlayerStateChange = function(event) {
  		if (event.data === YT.PlayerState.ENDED && !done) {
    		$('#ytplayer').fadeOut('slow', function() {
      			return $('#endplayer').fadeIn();
    		});
	    	done = true;
	    	return done;
  		}

		if (event.data === YT.PlayerState.CUED) {
			return false;
		}
	};

  	$('#replay').live('click', function() {
    	if (done) {
      		return $('#endplayer').fadeOut('slow', function() {
        		return $('#ytplayer').fadeIn('slow', function() {
          			player.playVideo();
          			return done = false;
        		});
      		});
    	}
  	});
  	return onYouTubeIframeAPIReady(video_id,player_id);
	};


	//Permite situar los elementos en formato pinterest

	var $image_container = $('#listado_container');
	$image_container.masonry({
		itemSelector:'.item',
		isAnimated:true,
		gutterWidth:12
	});
	$image_container.imagesLoaded(function(){
		$image_container.fadeIn();
		$image_container.masonry('reload');
	});

	


	//Permite realizar el scroll infinito

	var loader = function(fin){
		if(fin==true){
			html = '<div id="loading"><div><em>Todos los elementos han sido cargados</em></div></div>';
		}else{
			html= '<div id="loading"><img src="/assets/loader.gif" width="32" height="32" alt="Loader" /><div><em>Cargando el siguiente grupo de items</em></div></div>';	
		}
		
		$(body).append(html)
		$('#loading').fadeIn('fast');
	}
	$(window).scroll(function(){

		$container = $('#listado_container');
		if($container.length > 100){

			$loader = $('#loading');
			var wintop = $(window).scrollTop();
			var docheight = $(document).height();
			var winheight = $(window).height();
			var scrolltrigger = 0.95;

			if ((wintop/(docheight-winheight)) > scrolltrigger){
				loader(false);
				var nextPage = $('#page-nav a');
				$.get(nextPage.attr('href'), function(data){
					if($(data).length > 0 ){
						var $elems = $(data).css({opacitu:0});
						$elems.imagesLoaded(function(){
							$elems.animate({opacity:1});
							$container.append($elems).masonry('appended',$elems,true);

							$loader.delay(800).fadeOut().remove();
							
							var newHref = nextPage.attr('href').split('/')
							var page = parseInt(newHref[2]) + 1;
							newHref = "/"+newHref[1]+"/"+page;
							nextPage.attr('href',newHref);
						});	
					}else{
						$loader.delay(400).remove();
						loader(true);
						$loader.delay(1000).fadeOut().delay(400).remove();
					}
					
				})	
			}
		}

		
	});
	
});