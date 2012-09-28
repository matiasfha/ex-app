// modified Isotope methods for gutters in masonry
$.Isotope.prototype._getMasonryGutterColumns = function() {
	var gutter = this.options.masonry && this.options.masonry.gutterWidth || 0;
    containerWidth = this.element.width();

	this.masonry.columnWidth = this.options.masonry && this.options.masonry.columnWidth ||
              // or use the size of the first item
              this.$filteredAtoms.outerWidth(true) ||
              // if there's no items, use size of container
              containerWidth;

	this.masonry.columnWidth += gutter;

	this.masonry.cols = Math.floor( ( containerWidth + gutter ) / this.masonry.columnWidth );
	this.masonry.cols = Math.max( this.masonry.cols, 1 );
};

$.Isotope.prototype._masonryReset = function() {
	// layout-specific props
	this.masonry = {};
	// FIXME shouldn't have to call this again
	this._getMasonryGutterColumns();
	var i = this.masonry.cols;
	this.masonry.colYs = [];
	while (i--) {
	  this.masonry.colYs.push( 0 );
	}
};

$.Isotope.prototype._masonryResizeChanged = function() {
	var prevSegments = this.masonry.cols;
	// update cols/rows
	this._getMasonryGutterColumns();
	// return if updated cols/rows is not equal to previous
	return ( this.masonry.cols !== prevSegments );
};


$.fn.masonry = function(){
	this.each(function(index,holder){

		var img = $(holder).find('img.picture')[0];
		var newImg = new Image();

		newImg.onload = function(){
			var height = newImg.height;
			var item = $(holder).parent();
			var height3 = item.height()-85;
			if(height < 245){
				height+=16;
				$(holder).height(height);
				$(holder).find('.overlay').height((height-16));
				height2 = height+94;//+199;
				item.removeAttr('style');
				item.height(height3); 
			}
			item.css('margin-right','10px !important');
			$('div.imagenes').isotope({
				itemSelector:'.item',
				layoutMode:'masonry',
				masonry:{
					gutterWidth:16
				}

			});
		}
		newImg.src = img.src;
	});
}