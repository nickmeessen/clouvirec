/**
 Clouvirec clouvirec.js
 Copyright (c) 2011-2013 NickMeessen.nl
 Created by Nick Meessen (http://nickmeessen.nl)
 */

var preloader;
var mainView;

var addView;
var recentView;
var upcomingView;
var showView;

/* Initialise */
$(document).ready(function() {

    mainView = $('<div>').attr('id', "mainView");
    var overlay = $('<div>').attr('id', "overlay");

    preloader = new Loader(overlay);

    addView = new addView();
    recentView = new recentView(preloader);
    upcomingView = new upcomingView(preloader);
    showView = new showView(preloader);

    preloader.updateProgress(10, "Initialising Clouvirec..");
    preloader.updateProgress(20, "Loading upcoming episodes..");
    preloader.updateProgress(30, "Loading tracked shows..");
    preloader.updateProgress(40, "Loading show banners..");
    preloader.updateProgress(50, "Updating TV database..");
    preloader.updateProgress(60, "Refreshing shows..");

    recentView.refresh();
    upcomingView.refresh();
    showView.refresh();

    mainView.append(addView.element);
    // mainView.append($('<div>').html("Aired Recently").addClass("viewHeader"))
    // mainView.append(recentView.element)
    mainView.append($('<div>').html("Airing This Week").addClass("viewHeader"));
    mainView.append(upcomingView.element);
    mainView.append($('<div>').html("Your Shows").addClass("viewHeader"));
    mainView.append(showView.element);
    // mainView.append(footahh)

    // $('#vpScroll').tinyscrollbar()

    $('#viewport').append(overlay);
    $('#viewport').append(preloader.element);
    $('#viewport').append(mainView);

    $('#addShow').click(addView.show);

    preloader.finish();

});
