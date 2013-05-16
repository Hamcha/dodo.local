// Generated by CoffeeScript 1.4.0
(function() {
  var dodo, dragEnter, dragLeave, dragging, fileDrop, lastdoc, parse;

  dodo = {};

  lastdoc = null;

  dodo.create = function(args) {
    setupeditor(args);
    return $("#create").fadeIn("fast");
  };

  dodo.edit = function(args) {};

  dodo.publish = function(args) {
    $("#create").fadeIn("fast");
    return $("#publish").fadeIn("fast");
  };

  dodo.home = function(args) {
    $("#home").fadeIn("fast");
    $(document).filedrop({
      callback: fileDrop
    });
    $(document).on("dragenter", dragEnter);
    $(document).on("dragleave", dragLeave);
    return $("#createbtn").click(function() {
      return $("#home").fadeOut("fast", function() {
        return location.hash = "create";
      });
    });
  };

  dodo.view = function(args) {
    var converter, doc, html;
    doc = JSON.parse(lastdoc);
    converter = new Showdown.converter();
    html = converter.makeHtml(doc.data);
    $("content").html(html);
    $("#doctitle").html(doc.title);
    $("#editdoc").click(function() {
      return $("#view").fadeOut("fast", function() {
        dodo.create([doc.title, doc.data]);
        return location.hash = "edit";
      });
    });
    return $("#view").fadeIn("fast");
  };

  dragging = 0;

  dragEnter = function() {
    dragging += 1;
    $("#drophide").animate({
      "opacity": 0
    }, 200);
    $("#home container").animate({
      width: "800px",
      height: "500px",
      "font-size": "3em"
    }, 200);
    return false;
  };

  dragLeave = function() {
    dragging -= 1;
    if (dragging <= 0) {
      dragging = 0;
      $("#home container").animate({
        width: "400px",
        height: "50px",
        "font-size": "1.5em"
      }, 200);
      $("#drophide").animate({
        "opacity": 1
      }, 200);
    }
    return false;
  };

  fileDrop = function(fileData) {
    return $("#home").fadeOut("fast", function() {
      lastdoc = fileData;
      return location.hash = "view";
    });
  };

  $(document).ready(function() {
    var action, args;
    $("section").hide();
    args = parse(location.hash);
    action = (args.splice(0, 1))[0];
    if (!(action != null) || action === "" || action === "view") {
      location.hash = "";
      action = "home";
    }
    return dodo[action](args);
  });

  $(window).hashchange(function() {
    var action, args;
    dragLeave();
    args = parse(location.hash);
    action = (args.splice(0, 1))[0];
    if (!(action != null) || action === "") {
      $("section").hide();
      location.hash = "";
      action = "home";
    }
    dodo[action](args);
    $(document).filedrop({
      callback: fileDrop
    });
    $(document).on("dragenter", dragEnter);
    return $(document).on("dragleave", dragLeave);
  });

  parse = function(loc) {
    loc = loc.replace("#", "");
    return loc.split("/");
  };

}).call(this);