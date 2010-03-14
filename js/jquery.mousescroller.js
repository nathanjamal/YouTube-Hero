
function makeScrollable(wrapper, scrollable){
	// Get jQuery elements
	var wrapper = $(wrapper), scrollable = $(scrollable);
	

	
	function enable(){
		// height of area at the top at bottom, that don't respond to mousemove
		var inactiveMargin = 5;					
		// Cache for performance
		var wrapperWidth = wrapper.width();
		var wrapperHeight = wrapper.height();
		// Using outer height to include padding too
		var scrollableHeight = scrollable.outerHeight() + 2*inactiveMargin;
		// Do not cache wrapperOffset, because it can change when user resizes window
		// We could use onresize event, but it's just not worth doing that 
		// var wrapperOffset = wrapper.offset();
		
		// Create a invisible tooltip
		var tooltip = $('<div class="sc_menu_tooltip"></div>')
			.css('opacity', 0)
			.appendTo(wrapper);
	
		// Save menu titles
		scrollable.find('a').each(function(){				
			$(this).data('tooltipText', this.title);				
		});
		
		// Remove default tooltip
		scrollable.find('a').removeAttr('title');		
		// Remove default tooltip in IE
		scrollable.find('img').removeAttr('alt');	
		
		var lastTarget;
		//When user move mouse over menu			
		wrapper.mousemove(function(e){
			// Save target
			lastTarget = e.target;
 
			var wrapperOffset = wrapper.offset();
		
			var tooltipLeft = e.pageX - wrapperOffset.left;
			// Do not let tooltip to move out of menu.
			// Because overflow is set to hidden, we will not be able too see it 
			tooltipLeft = Math.min(tooltipLeft, wrapperWidth - 75); //tooltip.outerWidth());
			
			var tooltipTop = e.pageY - wrapperOffset.top + wrapper.scrollTop() - 40;
			// Move tooltip under the mouse when we are in the higher part of the menu
			if (e.pageY - wrapperOffset.top < wrapperHeight/2){
				tooltipTop += 80;
			}				
			tooltip.css({top: tooltipTop, left: tooltipLeft});				
			
			// Scroll menu
			var top = (e.pageY -  wrapperOffset.top) * (scrollableHeight - wrapperHeight) / wrapperHeight - inactiveMargin;
			if (top < 0){
				top = 0;
			}			
			wrapper.scrollTop(top);
		});
		
		// Setting interval helps solving perfomance problems in IE
		var interval = setInterval(function(){
			if (!lastTarget) return;	
										
			var currentText = tooltip.text();
			
			if (lastTarget.nodeName == 'LI'){					
				// We've attached data to a link, not image
				var newText = $(lastTarget).parent().data('tooltipText');
 
				// Show tooltip with the new text
				if (currentText != newText) {
					tooltip
						.stop(true)
						.css('opacity', 0)	
						.text(newText)
						.animate({opacity: 1}, 1000);
				}					
			}
		}, 200);
		
		// Hide tooltip when leaving menu
		wrapper.mouseleave(function(){
			lastTarget = false;
			tooltip.stop(true).css('opacity', 0).text('');
		});			
		
		/*
		//Usage of hover event resulted in performance problems
		scrollable.find('a').hover(function(){
			tooltip
				.stop()
				.css('opacity', 0)
				.text($(this).data('tooltipText'))
				.animate({opacity: 1}, 1000);
	
		}, function(){
			tooltip
				.stop()
				.animate({opacity: 0}, 300);
		});
		*/			
	}
}