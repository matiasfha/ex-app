(function(e){e.widget("ui.combobox",{_create:function(){function u(n){var i=e(n).val(),s=new RegExp("^"+e.ui.autocomplete.escapeRegex(i)+"$","i"),o=!1;r.children("option").each(function(){if(e(this).text().match(s))return this.selected=o=!0,!1});if(!o)return e(n).val("").attr("title",i+" didn't match any item").tooltip("open"),r.val(""),setTimeout(function(){t.tooltip("close").attr("title","")},2500),t.data("autocomplete").term="",!1}var t,n=this,r=this.element.hide(),i=r.children(":selected"),s=i.val()?i.text():"",o=this.wrapper=e("<span>").addClass("ui-combobox").insertAfter(r);t=e("<input>").appendTo(o).val(s).attr("title","").addClass("ui-state-default ui-combobox-input").autocomplete({delay:0,minLength:0,source:function(t,n){var i=new RegExp(e.ui.autocomplete.escapeRegex(t.term),"i");n(r.children("option").map(function(){var n=e(this).text();if(this.value&&(!t.term||i.test(n)))return{label:n.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)("+e.ui.autocomplete.escapeRegex(t.term)+")(?![^<>]*>)(?![^&;]+;)","gi"),"<strong>$1</strong>"),value:n,option:this}}))},select:function(e,t){t.item.option.selected=!0,n._trigger("selected",e,{item:t.item.option}),r.trigger("change")},change:function(e,t){if(!t.item)return u(this)}}).addClass("ui-widget ui-widget-content ui-corner-left"),t.data("autocomplete")._renderItem=function(t,n){return e("<li>").data("item.autocomplete",n).append("<a>"+n.label+"</a>").appendTo(t)},e("<a>").attr("tabIndex",-1).attr("title","Show All Items").tooltip().appendTo(o).button({icons:{primary:"ui-icon-triangle-1-s"},text:!1}).removeClass("ui-corner-all").addClass("ui-corner-right ui-combobox-toggle").click(function(){if(t.autocomplete("widget").is(":visible")){t.autocomplete("close"),u(t);return}e(this).blur(),t.autocomplete("search",""),t.focus()}),t.tooltip({position:{of:this.button},tooltipClass:"ui-state-highlight"})},destroy:function(){this.wrapper.remove(),this.element.show(),e.Widget.prototype.destroy.call(this)}})})(jQuery);