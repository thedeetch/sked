/**
 * @author Nick
 */
function Calendar(element, options, eventSources, resourceSources) {
	var table = $('<table></table>')
	$.getJSON(resourceSources, function(data) {
		$.each(data, function(index, value){
			
		});
	});
	
}

function getCalendarTable(start, end, step) {
	var table = $('<table></table>')
	
	for (var i=start; i <= end; i += step) {
		
	}
}
