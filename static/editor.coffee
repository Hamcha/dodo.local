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
				an = if horizontal then {bottom:"50px"} else {right:"10px"}
				$('#edcontainer').animate an
				$("#hide").text("Show preview")
				return
			$('#edcontainer').css { "border-right": "1px solid #ccc" }
		else
			an = if horizontal then {bottom:"51%"} else {right:"55%"}
			$('#edcontainer').animate an, () ->
				$('#result').fadeIn "fast"
				$("#hide").text("Hide preview")
				return
			$('#edcontainer').css { "border-right": "0" }
		return
	$("#switch").click () ->
		return if hidden
		horizontal = !horizontal
		if horizontal
			$("#superwrapper").css { width: "960px", "margin" : "0 auto" }
			$('#result').css { right:"10px", top: "50%", left: "10px" }
			$('#edcontainer').css { right:"10px", bottom: "51%", "border-right" : "1px solid #ccc" }
			$('#previewbox').css { top:"50%" }
		else
			$("#superwrapper").css { width: "auto", "margin" : "0 20px" }
			$('#result').css { width:"auto", top: "60px", left: "45%" }
			$('#edcontainer').css { width:"auto", bottom: "50px", "border-right" : "0" }
			$('#previewbox').css { top:"60px" }

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