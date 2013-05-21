# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateResource = (resource, element) =>
	$(element).empty()
	$(element).append(
		$('<span/>', text: resource.name, class: 'resource-name')
		.add($('<br>'))
		.add($('<small/>', text: "Today: " + resource.hours.total_day + 'h', class: 'resource-detail'))
		.add($('<br>'))
		.add($('<small/>', text: "Week: " + resource.hours.total_week + 'h', class: 'resource-detail'))
	)

updateShift = (event) ->
	$.ajax "/shifts/" + event.id + ".json",
		type: "PUT"
		data: eventToShift(event)
		success: -> 
			$(calendar).fullCalendar('refetchResources')
			$(calendar).fullCalendar('rerenderEvents')
			$(calendar).fullCalendar('render')


deleteShift = (event) ->
	$.ajax "/shifts/" + event.id + ".json",
		type: "DELETE"
		success: -> 
			$(calendar).fullCalendar('refetchResources')
			$(calendar).fullCalendar('removeEvents', event.id)
			$(calendar).fullCalendar('render')

createShift = (event) ->
	$(calendar).fullCalendar('unselect')
	$('.fc-cell-overlay').hide()
	$.ajax "/shifts.json",
		type: "POST"
		data: eventToShift(event)
		success: (data) ->
			$(calendar).fullCalendar('refetchResources')
			$(calendar).fullCalendar('renderEvent', shiftToEvent(data), true)
			$(calendar).fullCalendar('render')
			
eventToShift = (event) ->
	return shift:
		id: event.id
		employee_id: if event.resource instanceof Array then event.resource[0] else event.resource
		start: $.fullCalendar.parseDate(event.start).toUTCString()
		end: $.fullCalendar.parseDate(event.end).toUTCString()
		department_id: department.id
		category: event.category ?= 'shift'

shiftToEvent = (shift) ->
	shift.resource = shift.employee_id
	shift.title = if shift.category is 'shift' then shift.department_name else shift.category ?= 'shift'
	shift

$ ->
	return false if page_tab isnt 'shifts'
	calendar = $('#calendar')
	date = $('#date')

	date.datepicker
		onSelect: (date, e) -> $(calendar).fullCalendar('gotoDate', $(this).datepicker("getDate"))

	options =
		header:
			left: ''
			center: ''
			right: ''
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
		selectHelper: false
		refetchResources: true
		columnFormat: "HH<br>mm"
		resources: "/shifts/resources/" + department.id + ".json"
		events: "/shifts/" + department.id + ".json"
		ignoreTimezone: false
		selectable: true
		height: null
		contentHeight: null
		eventDataTransform: (eventData) -> shiftToEvent(eventData)
		select: (start, end, allDay, jsEvent, view, resource) ->
			createShift
				start: start
				end: end
				resource: resource.id
		eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) -> updateShift(event)
		eventResize: (event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) -> updateShift(event)
		eventRender: (event, element, view) ->
			element = $(element)
			classes = 'lunch shift timeoff'
			innerdiv = element.find('.fc-event-inner')
			innerdiv.contents().filter(-> return this.nodeType is 3)[0].nodeValue = " "
			
			# Set title
			innerdiv.find('.fc-event-title').text(if event.category is 'shift' then event.department_name else event.category ?= 'shift')

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
			return true
		resourceRender: (resource, element, view) -> updateResource(resource, element)
		viewDisplay: (view) ->
			$('div.fc-content table').addClass('table table-striped table-bordered table-condensed')
			$(date).datepicker('setDate', $(calendar).fullCalendar('getDate'))

	$(calendar).fullCalendar(options)
	# Need to reset date to fix a bug in fullCalendar on inital load
	# when events are updated, their placing would get messed up.
	$(calendar).fullCalendar('gotoDate', date.datepicker("getDate"))