/**
 Clouvirec addView.js
 Copyright (c) 2011-2013 NickMeessen.nl
 Created by Nick Meessen (http://nickmeessen.nl)
 */

var addView = function() {

    var searchImg = $('<img src="images/search.png" id="searchImage">').click(searchShow);
    var loadingImg = $('<img src="images/loader.gif" id="searchImage">');
    var clearImg = $('<img src="images/clear.png" id="searchImage">').click(function() {
        searchResults.empty();
        searchField.val(" Enter Show Title..");

        clearImg.animate({
            opacity: 0
        }, 'fast', function() {

            clearImg.replaceWith(searchImg);
            searchImg.animate({
                opacity: 1
            }, 'fast');
            searchImg.click(searchShow);
        });

    });

    var view = $('<div>').hide();
    var foundShows = [];

    var searchArray = [];
    var searchField = $('<input>').attr('id', "searchField").val(" Enter Show Title..");
    var searchResults = $('<table>').attr('id', "searchResults").hide();

    this.element = view;

    view.append($('<div>').html("Add Show").attr('class', "viewHeader"));
    view.append($('<div>').attr('id', "addView").append($('<div>').attr('id', "searchView").append(searchField).append(searchImg)).append(searchResults));

    searchField.focusin(function() {
        if (searchField.val() == " Enter Show Title..") {
            searchField.attr('value', "");
        }
    });

    searchField.focusout(function() {
        if (!searchField.val()) {
            searchField.val(" Enter Show Title..");
        }
    });

    searchField.keyup(searchShow);

    this.show = function(event) {

        $('#addShow').fadeOut();
        view.slideDown();
    };

    function addShow(event) {

        var target = event.target || event.srcElement;

        event.preventDefault();

        $(target).html("TRACKING...");

        var sid = target.id;

        $(target).html("TRACKING").toggleClass("trackingLink");
        showView.refresh();
        new Messi('Show is being tracked! :)', {
            modal: true,
            titleClass: 'info',
            buttons: [{
                id: 0,
                label: 'OK',
                val: 'X'
            }]
        });

    }

    function searchShow(event) {

        var target = event.target || event.srcElement;

        if (event.which == 13 || event.keyCode == 13 || target.id == "searchImage") {

            searchResults.fadeOut('fast', function() {
                searchResults.empty();
            });

            if (!searchField.val()) {
                return false;
            }

            searchImg.animate({
                opacity: 0
            }, 'fast', function() {

                searchImg.replaceWith(loadingImg);
                loadingImg.animate({
                    opacity: 1
                }, 'fast');
            });

            $.get("shows/search.json",

                function(data) {

                  data = JSON.parse( JSON.stringify(data) );

                    loadingImg.animate({
                        opacity: 0
                    }, 'fast', function() {

                        loadingImg.replaceWith(clearImg);
                        clearImg.animate({
                            opacity: 1
                        }, 'fast');
                        clearImg.click(function() {
                            searchResults.empty();
                            searchField.val(" Enter Show Title..");

                            clearImg.animate({
                                opacity: 0
                            }, 'fast', function() {

                                clearImg.replaceWith(searchImg);
                                searchImg.animate({
                                    opacity: 1
                                }, 'fast');
                                searchImg.click(searchShow);
                            });

                        });
                    });

                    searchResults.empty();

                    if (data.length === 0) {

                        searchResults.append($('<tr>').append($('<td>').attr('colspan', 3).html("Nothing found..")));

                    } else {

                        searchResults.append($('<tr>').append($('<th>').html("Show Title")).append($('<th>').html("Show Release Date")).append($('<th>')));

                        for (var show in data) {

                            if (showView.checkShow(data[show].tvdbid)) {
                                link = $('<a>').addClass("trackingLink").html("TRACKING");
                            } else {
                                link = $('<a>').attr('id', data[show].tvdbid).html("TRACK SHOW").attr('href', "#").addClass('downloadLink').click(addShow);
                            }

                            searchResults.append(foundShows[data[show].tvdbid] = $('<tr>')
                                .append($('<td>').html(data[show].title))
                                .append($('<td>').html(data[show].first_aired ? data[show].first_aired : "N/A"))
                                .append($('<td>').append(link).css('text-align', "right")));
                        }
                    }

                    searchResults.fadeIn('fast');

                });
        }
    }
};
