dodo = {}
lastdoc = null

dodo.create = (args) ->
	setupeditor(args)
	$("#create").fadeIn "fast"
dodo.edit = (args) ->
	return
dodo.home = (args) ->
	$("#home").fadeIn "fast"
	$(document).filedrop { callback : fileDrop }
	$(document).on "dragenter", dragEnter
	$(document).on "dragleave", dragLeave
	$("#createbtn").click () ->
		$("#home").fadeOut "fast", () ->
			location.hash = "create"
		#dodo.create args

dodo.view = (args) ->
	doc = JSON.parse lastdoc
	converter = new Showdown.converter()
	html = converter.makeHtml doc.data
	$("content").html html
	$("#doctitle").html doc.title
	$("#editdoc").click () ->
		$("#view").fadeOut "fast", () ->
			dodo.create [doc.title, doc.data]
			location.hash = "edit"
	$("#view").fadeIn "fast"
   
dragging = 0

dragEnter = () ->
	dragging += 1
	$("#drophide").animate { "opacity": 0 }, 200
	$("#home container").animate { width:"800px", height:"500px", "font-size" : "3em" }, 200
	return false

dragLeave = () ->
	dragging -= 1
	if dragging <= 0
		dragging = 0
		$("#home container").animate { width:"400px", height:"50px", "font-size" : "1.5em" }, 200
		$("#drophide").animate { "opacity": 1 }, 200
	return false
	
fileDrop = (fileData) ->
	$("#home").fadeOut "fast", () ->
		lastdoc = fileData
		location.hash = "view"

$(document).ready () ->
	$("section").hide()
	args = parse location.hash
	action = (args.splice 0,1)[0]
	if !action? or action == "" or action == "view"
		location.hash = ""
		action = "home"
	dodo[action](args)

$(window).hashchange () ->
	dragLeave()
	args = parse location.hash
	action = (args.splice 0,1)[0]
	if !action? or action == ""
		$("section").hide()
		location.hash = ""
		action = "home"
	dodo[action](args)

	$(document).filedrop { callback : fileDrop }
	$(document).on "dragenter", dragEnter
	$(document).on "dragleave", dragLeave


parse = (loc) ->
	loc = loc.replace "#",""
	return loc.split "/"