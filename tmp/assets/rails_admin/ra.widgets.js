(function(){$(document).live("rails_admin.dom_ready",function(){var e,t,n,r,i,s=this;if($("form").length){$("form [data-color]").each(function(){var e;return e=this,$(this).ColorPicker({color:$(e).val(),onShow:function(e){return $(e).fadeIn(500),!1},onHide:function(e){return $(e).fadeOut(500),!1},onChange:function(t,n,r){return $(e).val(n),$(e).css("backgroundColor","#"+n)}})}),$("form [data-datetimepicker]").each(function(){return $(this).datetimepicker($(this).data("options"))}),$("form [data-enumeration]").each(function(){return $(this).is("[multiple]")?$(this).filteringMultiselect($(this).data("options")):$(this).filteringSelect($(this).data("options"))}),$("form [data-fileupload]").each(function(){var e;return e=this,$(this).find(".delete input[type='checkbox']").live("click",function(){return $(e).children(".toggle").toggle("slow")})}),$("form [data-fileupload]").change(function(){var e,t,n,r;return n=this,t=$("#"+n.id).parent().children(".preview"),t.length||(t=$("#"+n.id).parent().prepend($("<img />").addClass("preview")).find("img.preview"),t.parent().find("img:not(.preview)").hide()),e=$("#"+n.id).val().split(".").pop().toLowerCase(),n.files&&n.files[0]&&$.inArray(e,["gif","png","jpg","jpeg","bmp"])!==-1?(r=new FileReader,r.onload=function(e){return t.attr("src",e.target.result)},r.readAsDataURL(n.files[0]),t.show()):t.hide()}),$("form [data-filteringmultiselect]").each(function(){return $(this).filteringMultiselect($(this).data("options")),$(this).parents("#modal").length?$(this).parents(".control-group").find(".btn").remove():$(this).parents(".control-group").first().remoteForm()}),$("form [data-filteringselect]").each(function(){return $(this).filteringSelect($(this).data("options")),$(this).parents("#modal").length?$(this).parents(".control-group").find(".btn").remove():$(this).parents(".control-group").first().remoteForm()}),$("form [data-nestedmany]").each(function(){var e,t,n,r;return t=$(this).parents(".control-group").first(),n=t.find("> .controls > .nav"),e=t.find("> .tab-content"),r=t.find("> .controls > .btn-group > .toggler"),e.children(".fields:not(.tab-pane)").addClass("tab-pane").each(function(){return $(this).attr("id","unique-id-"+(new Date).getTime()+Math.floor(Math.random()*1e5)),n.append('<li><a data-toggle="tab" href="#'+this.id+'">'+$(this).children(".object-infos").data("object-label")+"</a></li>")}),n.find("> li.active").length===0&&n.find("> li > a[data-toggle='tab']:first").tab("show"),n.children().length===0?(n.hide(),e.hide(),r.addClass("disabled").removeClass("active").children("i").addClass("icon-chevron-right")):r.hasClass("active")?(n.show(),e.show(),r.children("i").addClass("icon-chevron-down")):(n.hide(),e.hide(),r.children("i").addClass("icon-chevron-right"))}),$("form [data-nestedone]").each(function(){var e,t,n,r,i;return t=$(this).parents(".control-group").first(),r=t.find("> .controls > .nav"),e=t.find("> .tab-content"),i=t.find("> .controls > .toggler"),e.children(".fields:not(.tab-pane)").addClass("tab-pane active").each(function(){return r.append('<li><a data-toggle="tab" href="#'+this.id+'">'+$(this).children(".object-infos").data("object-label")+"</a></li>")}),n=r.find("> li > a[data-toggle='tab']:first"),n.tab("show"),t.find("> .controls > [data-target]:first").html('<i class="icon-white"></i> '+n.html()),i.hasClass("active")?(i.children("i").addClass("icon-chevron-down"),e.show()):(i.children("i").addClass("icon-chevron-right"),e.hide())}),$("form [data-polymorphic]").each(function(){var e,t,n,r;return n=$(this),e=n.parents(".control-group").first(),t=e.find("select").last(),r=n.data("urls"),n.on("change",function(e){return $(this).val()===""?t.html('<option value=""></option>'):$.ajax({url:r[n.val()],data:{compact:!0,all:!0},beforeSend:function(e){return e.setRequestHeader("Accept","application/json")},success:function(e,n,r){var i;return i="<option></option>",$(e).each(function(e,t){return i+='<option value="'+t.id+'">'+t.label+"</option>"}),t.html(i)}})})}),n=function(e){return e.each(function(e,t){var n,r;return r=$(this).data,(n=window.CKEDITOR.instances[this.id])&&n.destroy(!0),window.CKEDITOR.replace(this,r.options),$(this).addClass("ckeditored")})},e=$("form [data-richtext=ckeditor]").not(".ckeditored"),e.length&&(this.array=e,window.CKEDITOR?n(this.array):(i=$(e[0]).data("options"),window.CKEDITOR_BASEPATH=i.base_location,$.getScript(i.jspath,function(e,t,r){return n(s.array)}))),r=function(e){return e.each(function(e,t){var n;return i=$(this).data("options"),n=this,$.getScript(i.locations.mode,function(e,t,r){return $("head").append('<link href="'+i.locations.theme+'" rel="stylesheet" media="all" type="text/css">'),CodeMirror.fromTextArea(n,{mode:i.options.mode,theme:i.options.theme}),$(n).addClass("codemirrored")})})},e=$("form [data-richtext=codemirror]").not(".codemirrored"),e.length&&(this.array=e,window.CodeMirror?r(this.array):(i=$(e[0]).data("options"),$("head").append('<link href="'+i.csspath+'" rel="stylesheet" media="all" type="text/css">'),$.getScript(i.jspath,function(e,t,n){return r(s.array)}))),t=function(e){return e.each(function(){return $(this).addClass("bootstrap-wysihtml5ed"),$(this).closest(".controls").addClass("well"),$(this).wysihtml5()})},e=$("form [data-richtext=bootstrap-wysihtml5]").not(".bootstrap-wysihtml5ed");if(e.length)return this.array=e,window.wysihtml5?t(this.array):(i=$(e[0]).data("options"),$("head").append('<link href="'+i.csspath+'" rel="stylesheet" media="all" type="text/css">'),$.getScript(i.jspath,function(e,n,r){return t(s.array)}))}})}).call(this);