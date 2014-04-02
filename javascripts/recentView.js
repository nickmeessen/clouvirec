/**
 Clouvirec recentView.js
 Copyright (c) 2011-2013 NickMeessen.nl
 Created by Nick Meessen (http://nickmeessen.nl)
 */

var recentView = function(loader) {

    this.element = $('<div>').attr('id', "recentView");

    var recentList = $('<table>').attr('id', "recentList");

    this.element.append(recentList);

    this.refresh = function() {

        $.get("shows/recent.json", function(data) {

          data = JSON.parse( JSON.stringify(data) );

            recentList.empty();

            if (data.length === 0) {

                recentList.append($('<tr>').append('<td>').html("Nothing this week.."));

            } else {

                var desc = null;

                for (var show in data) {

                    var row = $('<tr>')
                        .append($('<td>').html(data[show].weekday + " &raquo;").attr('rowspan', 2).addClass('weekday'))
                        .append($('<th>').html(data[show].show))
                        .append($('<th>').html(data[show].title))
                        .append($('<th>').html(data[show].epnumber));

                    desc = $('<tr>')
                        .append($('<td>').attr('colspan', 2).addClass('description').html(data[show].description))
                        .append($('<td>').addClass('button').addClass('description')
                            .append($('<a>').append($('<img src="images/download.png">')).attr('href', "episodes/" + data[show].tvdbid + "/" + data[show].season + "/" + data[show].number)));

                    recentList.append(row).append(desc);
                }

                desc.css('border-bottom', "2px solid #E0E0E0");

                loader.finish();

            }
        });
    };
};
