# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateShift = (event) ->
	$.ajax "/shift/" + event.id + ".json"
		type: "PUT"
		data: eventToShift(event)

eventToShift = (event) ->
	if event.resource instanceof Array
		event.resource = event.resource[0]

	return shift:
			id: event.id
			employee_id: event.resource
			start: $.fullCalendar.parseDate(event.start).toUTCString()
			end: $.fullCalendar.parseDate(event.end).toUTCString()
			department_id: department.id

shiftToEvent = (shift) ->
	return {
		id: shift.id
		resource: shift.employee_id
		title: shift.department_name
		start: shift.start
		end: shift.end
	}

$ ->
	calendar = $('#calendar')
	date = $('#date')

	date.datepicker({
		onSelect: (date, e) ->
			calendar.fullCalendar('gotoDate', $(this).datepicker("getDate"))
	})

	options =
		header:
			left: 'title'
			center: 'today prev,next'
			right: 'resourceWeek resourceDay'
		year: date.datepicker("getDate").getFullYear()
		month: date.datepicker("getDate").getMonth()
		date: date.datepicker("getDate").getDate()
		allDayDefault: false
		defaultView: 'resourceDay'
		firstDay: 0
		editable: true
		selectable: true
		minTime: 4
		maxTime: 22
		selectHelper: true
		columnFormat: "HH<br>mm"
		resources: "/shift/resources/" + department.id + "/" + date_format
		events: "/shift/" + department.id + ".json"
		ignoreTimezone: false
		viewDisplay: (view) ->
			# alert($('#calendar').fullCalendar.options.editable)
			# $('#calendar').fullCalendar.editable = false
		eventDataTransform: (eventData) -> return shiftToEvent(eventData)
		select: (start, end, allDay, jsEvent, view, resource) ->
			event = 
				{
					start: start
					end: end
					resource: resource.id
				}
				
			$.ajax "/shift.json",
				{
					type: "POST"
					data: eventToShift(event)
					success: (data) -> calendar.fullCalendar('renderEvent', shiftToEvent(data))
				}

			calendar.fullCalendar('unselect')
		eventMouseover: ( event, jsEvent, view ) ->
			close = $('<div/>',
				{
					id: 'deleteEvent'
					href: '#'
				})
				.append($('<i/>', 
					{
						class: 'icon-remove'
					}))
				.click(->
					$.ajax "/shift/" + event.id + ".json",
						{
							type: "DELETE"
						}
					calendar.fullCalendar('refetchEvents')
				)

			$(this).find('.fc-event-inner').append(close)
		eventMouseout: ( event, jsEvent, view ) -> $('#deleteEvent').remove()
		eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) -> updateShift(event)
		eventResize: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) -> updateShift(event)
	#calendar.fullCalendar(options)

# $('.fc-grid table').addClass("table table-striped table-bordered table-condensed");