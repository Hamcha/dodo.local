window.onerror = (message, url, linenumber) ->
	$(".errorbox").html("<div class=\"error\">"+linenumber+" : "+message+"</div>");
	return false

window.setupeditor = (args) ->
	hidden = false
	horizontal = false
	$("textarea#editor").html "Place your content here"
	$('textarea#editor').on 'change keyup', () ->
		return if hidden
		$(".errorbox").html ""
		html = converter.makeHtml $("#editor").val()
		$("#result").html html
		return
	$('textarea#editor').focus()
	if args[0]?
		$('input#docname').val(args[0])
	if args[1]?
		$("#editor").val(args[1])
	$("#discard").click redirect
	$("#save").click () ->
		data = $("#editor").val()
		name = $('input#docname').val()
		if !name? or name == ""
			name = "Untitled"
		exports = { "data" : data, "title" : name }
		blob = new Blob [JSON.stringify(exports)], {type: 'application/json'}
		downloadLink = document.createElement "a"
		downloadLink.href = window.webkitURL.createObjectURL blob
		downloadLink.download = name + ".dd";
		downloadLink.click()
		return

	$("#hide").click () ->
		hidden = !hidden
		if hidden
			$('#result').fadeOut "fast", () ->
				an = if horizontal then {bottom:"50px"} else {width:"935px"}
				$('#edcontainer').animate an
				$("#hide").text("Show preview")
				return
		else
			an = if horizontal then {bottom:"51%"} else {width:"450px"}
			$('#edcontainer').animate an, () ->
				$('#result').fadeIn "fast"
				$("#hide").text("Hide preview")
				return
		return
	$("#switch").click () ->
		return if hidden
		horizontal = !horizontal
		if horizontal
			$('#result').animate { width:"918px", top: "50%" }
			$('#edcontainer').animate { width:"938px", bottom: "51%" }
		else
			$('#result').animate { width:"460px", top: "60px" }
			$('#edcontainer').animate { width:"450px", bottom: "50px" }

	converter = new Showdown.converter()
	html = converter.makeHtml $("#editor").val()
	$("#result").html html


redirect = (data) ->
	location.href = document.URL.replace(/\/edit(.*)/,"")
	return
throwerror = (data) ->
	alert "Check your console (and logs, if you can)!"
	console.log data
	return

publish = (data) ->
	name = $('input#docname').val()
	if !name? or name == ""
		name = "Untitled"
	formprop = 
		"action" : "http://"+$("#dodourl").val()+"/"+data.name+"/"+$("#dodoname").val()+"/edit"
	newForm = jQuery '<form>', formprop
	input1 = jQuery '<input>', {'name': 'title','value': name,'type': 'hidden'}
	input2 = jQuery '<input>', {'name': 'content','value': $("#editor").val(),'type': 'hidden'}
	newForm.append input1
	newForm.append input2
	newForm.submit()
	return

throwproblem = (data) ->
	alert "You're not logged in or allowed into the specified Dodo service."