(function(){var e=function(e,t){return function(){return e.apply(t,arguments)}},t={}.hasOwnProperty,n=function(e,n){function i(){this.constructor=e}for(var r in n)t.call(n,r)&&(e[r]=n[r]);return i.prototype=n.prototype,e.prototype=new i,e.__super__=n.prototype,e};namespace("Dandoo").Modal=function(t){function r(){return this.cerrarModal=e(this.cerrarModal,this),this.render=e(this.render,this),r.__super__.constructor.apply(this,arguments)}return n(r,t),r.prototype.events={"click ul.idTabs li":"showTab","mouseenter #rating .star":"onStar","mouseleave #rating .star":"offStar","click #rating .star":"Vote","click  a#close":"cerrarModal","click a.ctwitter,a.cfacebook":"compartir"},r.prototype.initialize=function(){return this.model!=null?(this.html=HandlebarsTemplates.show(this.model[0]),$("#contenedor-modal").off("click").on("click",this.cerrarModal),this.render()):$("#modal #dos").hide()},r.prototype.render=function(){var e,t,n=this;return this.positionOriginal=$(window).scrollTop(),e=$(document).height()+"3",t=$(document).width(),$("#contenedor-modal").css({height:e}).html(this.html),$("#theMask").css({height:e,width:t}).slideDown("slow",function(){return $("#contenedor-modal").imagesLoaded(function(){return $("#contenedor-modal").show(),$("#modal #dos").hide()}),$(window).scrollTop(0)})},r.prototype.showTab=function(e){var t,n;return n=$(e.currentTarget),$("ul.idTabs  li").removeClass("onTab"),$("#uno,#dos").hide(),t=n.attr("data-tab"),$(t).show(),n.addClass("onTab").addClass("onWord").removeClass("offWord")},r.prototype.onStar=function(e){var t,n;return n=$(e.currentTarget),t=n.prevAll().andSelf().children(),t.addClass("starOn").removeClass("starOff"),t=n.nextAll().children(),t.removeClass("starOn").addClass("starOff"),e.stopPropagation()},r.prototype.offStar=function(e){var t;return t=$(e.currentTarget).prevAll().andSelf().children(":not(.voted)"),t.removeClass("starOn").addClass("starOff"),e.stopPropagation()},r.prototype.Vote=function(e){var t,n,r,i;return i=$(e.currentTarget),i.siblings(".voted").andSelf().removeClass("voted"),t=i.siblings().andSelf(),t=t.children(".starOn"),t.addClass("voted"),n=$("a.voted").length,r=$("#rating").attr("data-id"),$.ajax({url:"/votos/"+r+"/"+n,type:"POST",success:function(e){var t,n,i;return i=e.total,t=e.promedio,$("div.bigStar span").text(t),$("#votoWord").text(""+i+" votos"),n="votos",i===1&&(n="voto"),$("article#"+r).find(".heart-no").html(t+"/"+i+" "+n)}}),!1},r.prototype.cerrarModal=function(e){var t,n,r=this;t=e.currentTarget,n=e.target;if(t===n||t===$("a#close"))return e.stopPropagation(),e.preventDefault(),$("#contenedor-modal").hide().empty(),$("#theMask").slideUp("slow",function(){return $(window).scrollTop(r.positionOriginal)}),!1},r.prototype.compartir=function(e){var t,n,r,i,s,o;return e.preventDefault(),e.stopPropagation(),s=$(e.currentTarget).attr("href"),o=775,t=400,n=($(window).width()-o)/2,i=($(window).height()-t)/2,r="status=1,width="+o+",height="+t+",top="+i+",left="+n,window.open(s,"Comparte con tus amigos",r),!1},r}(Backbone.View)}).call(this);