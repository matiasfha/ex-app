(function(){$(document).ready(function(){var e,t,n;window.loading=!1,$("#header").addClass("perfil"),$("#header #show").is(":visible")&&$("#header #show").hide(),$("#nuevo_recurso").live("click",function(e){return $("#modal-form").modal({keyboard:!1},"show")}),$("input:file").change(function(){return $("#resource_url").attr("disabled","disabled").val(""),$("#resource_type").val("imagen")}),$("#resource_url").focusout(function(){if($(this).val()!=="")return $("input:file").attr("disabled","disabled").val(""),$("#resource_type").val("video")}),$("#new_resource").on("ajax:beforeSend",function(e,t,n){var r;e.stopPropagation(),r=$("#new_resource").serializeObject();if(r.resource.titulo===""||r.resource.descripcion==="")e.preventDefault(),$.pnotify({title:"Dandoo.tv",text:"Debes completar los campos requeridos",opacity:.8,type:"error"}),r.resource.titulo===""&&$("#resource_titulo").parent().parent().addClass("error"),r.resource.descripcion===""&&$("#resource_descripcion").parent().parent().addClass("error"),!1;return $("body").toggleClass("wait"),$("#subir_recurso").attr("disabled","disabled"),$("#cancelar").attr("disabled","disabled")}).on("ajax:afterSend",function(e){return $("#resource_descripcion").attr("disabled","disabled"),$("#resource_titulo").attr("disabled","disabled"),$("#resource_url").attr("disabled","disabled"),$("#resource_imagen").attr("disabled","disabled")}).on("ajax:complete",function(e,t){return t.result===!0?$.get("/metadata/last_resource",function(e){var t;return $("#new_resource").reset(),$("#new_resource input").removeAttr("disabled"),$("#cancelar, #subir_recurso").removeAttr("disabled"),$("body").toggleClass("wait"),$("#modal-form").modal("hide"),t=$("#listado_subidas"),e=$(e),e.show().css({opacity:0}),t.prepend(e).imagesLoaded(function(){return e.animate({opacity:1}),t.masonry("reload")})}):console.log(t)}).on("ajax:aborted:required",function(){return $.pnotify({title:"Dandoo.tv",text:"Debes completar todos los campos del formulario",opacity:.8,type:"error"})}),t=function(e){var t,n,r;return $("#perfil-data").fadeOut("fast"),t=$("#listado_container"),t.empty().removeClass("disabled"),n=$("div.imagenes"),r=$("div.videos"),n.hasClass("active")&&!r.hasClass("active")?e="imagenes_"+e:!n.hasClass("active")&&r.hasClass("active")&&(e="videos_"+e),e==="index"&&(e="todos_index"),$.get("/metadata/"+e,function(n){return $("#page-nav a").attr("href","/metadata/"+e+"/2"),n=$(n),n.hide(),t.append(n),t.imagesLoaded(function(){return t.fadeIn("fast",function(){return t.masonry("reload"),n.fadeIn()})})})},$("#secciones2 div").click(function(e){var n,r,i;$(this).siblings().removeClass("active"),$(this).addClass("active"),i=$(this).attr("data-url"),window.loading=!1;if(i!=null)$("#upload").hide(),t(i);else{n=$(this).attr("id");switch(n){case"perfil":$("#upload").show(),$("#listado_container").fadeOut("fast").addClass("disabled"),$("#perfil-data").fadeIn("fast"),r=window.location.href.split("#"),r.length>1&&(window.location.href=r[0]);break;case"logout":$("#salir").trigger("click")}}return!1}),n=window.location.href.split("#")[1];switch(n){case"valorados":$("#secciones2 div#valorados").trigger("click");break;case"favoritos":$("#secciones2 #favoritos").trigger("click")}return e=$("#listado_subidas"),e.imagesLoaded(function(){return e.masonry({itemSelector:".item",isAnimated:!0,gutterWidth:11})}),$('a[data-method="delete"]').live("ajax:success",function(e,t,n){return t.result===!0?($.pnotify({title:"Dandoo.tv",text:"Recurso eliminado exitosamente",opacity:.8,type:"success"}),$("#"+t.id).fadeOut("slow",function(){return $("#"+t.id).remove(),$("#listado_subidas").masonry("reload")})):$.pnotify({title:"Dandoo.tv",text:"El recurso seleccionado no se puede eliminar",opacity:.8,type:"error"})})})}).call(this);