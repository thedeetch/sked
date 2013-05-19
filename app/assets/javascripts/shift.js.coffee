# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateResource = (resource) ->
	date = $.fullCalendar.formatDate($(calendar).fullCalendar('getDate'), 'yyyyMMdd')
	$.ajax "/employees/" + resource + "/hours/" + date + ".json",
		type: "GET"
		success: (data) ->
			alert(data.total_hours)

updateShift = (event) ->
	$.ajax "/shift/" + event.id + ".json",
		type: "PUT"
		data: eventToShift(event)
		success: -> 
			updateResource(event.resource)
			$(calendar).fullCalendar('rerenderEvents')

deleteShift = (event) ->
	$.ajax "/shift/" + event.id + ".json",
		type: "DELETE"
		success: -> 
			updateResource(event.resource)
			$(calendar).fullCalendar('removeEvents', event.id)

createShift = (event) ->
	$(calendar).fullCalendar('unselect')
	$('.fc-cell-overlay').hide()
	$.ajax "/shift.json",
		type: "POST"
		data: eventToShift(event)
		success: (data) ->
			updateResource(data.employee_id)
			$(calendar).fullCalendar('renderEvent', shiftToEvent(data), true)
			
eventToShift = (event) ->
	return shift:
		id: event.id
		employee_id: if event.resource instanceof Array then event.resource[0] else event.resource
		start: $.fullCalendar.parseDate(event.start).toUTCString()
		end: $.fullCalendar.parseDate(event.end).toUTCString()
		department_id: department.id
		category: event.category ?= 'shift'

shiftToEvent = (shift) ->
	id: shift.id
	resource: shift.employee_id
	title: shift.department_name
	start: shift.start
	end: shift.end
	category: shift.category ?= 'shift'

$ ->
	#alert(page_tab)
	return false if page_tab isnt 'shifts'
	calendar = $('#calendar')
	date = $('#date')

	date.datepicker
		onSelect: (date, e) -> $(calendar).fullCalendar('gotoDate', $(this).datepicker("getDate"))

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
		selectable: true
		eventDataTransform: (eventData) -> shiftToEvent(eventData)
		select: (start, end, allDay, jsEvent, view, resource) ->
			createShift
				start: start
				end: end
				resource: resource.id
		eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) -> updateShift(event)
		eventResize: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) -> updateShift(event)
		eventAfterRender: (event, element, view) ->
			element = $(element)
			classes = 'lunch shift timeoff'

			# Set event style
			element.removeClass(classes).addClass(event.category).attr('title', event.category)

			# Build the event controls
			controldiv = $('<div/>', class: 'eventOptions')

			# Shift
			controldiv.append(
				$('<span/>', class: 'eventOption')
				.append($('<i/>', class: 'icon-time', title: 'shift'))
				.click(->
					event.category = 'shift'
					updateShift(event)
				)
			)

			# TimeOff
			controldiv.append(
				$('<span/>', class: 'eventOption')
				.append($('<i/>', class: 'icon-suitcase', title: 'timeoff'))
				.click(->
					event.category = 'timeoff'
					updateShift(event)
				)
			)

			# Lunch
			controldiv.append(
				$('<span/>', class: 'eventOption')
				.append($('<i/>', class: 'icon-food', title: 'lunch'))
				.click(->
					event.category = 'lunch'
					updateShift(event)
				)
			)

			# Delete
			controldiv.append(
				$('<span/>', class: 'eventOption')
				.append($('<i/>', class: 'icon-trash', title: 'delete'))
				.click(-> deleteShift(event))
			)

			element.find('.fc-event-inner').append(controldiv)

	$(calendar).fullCalendar(options)
	$('div.fc-content table').addClass('table table-striped table-bordered table-condensed')