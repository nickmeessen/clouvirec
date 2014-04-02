/**
 Clouvirec upcomingView.js
 Copyright (c) 2011-2013 NickMeessen.nl
 Created by Nick Meessen (http://nickmeessen.nl)
 */

var upcomingView = function(loader) {

    this.element = $('<div>').attr('id', "upcomingView");

    var upcomingList = $('<table>').attr('id', "upcomingList");

    this.element.append(upcomingList);

    this.refresh = function() {

        var uv = $.get("shows/upcoming.json", function(data) {

            data = JSON.parse(data);

            upcomingList.empty();

            if (data.length === 0) {

                upcomingList.append($('<tr>').append('<td>').html("Nothing this week.."));

            } else {

                var desc = null;

                for (var show in data) {

                    var row = $('<tr>')
                        .append($('<td>').html(data[show].weekday + " &raquo;").attr('rowspan', 2).addClass('weekday'))
                        .append($('<th>').html(data[show].title))
                        .append($('<th>').html(data[show].eptitle))
                        .append($('<th>').html(data[show].epnumber));

                    desc = $('<tr>').append($('<td>')
                        .attr('colspan', 3).addClass('description').html(data[show].epdesc));

                    upcomingList.append(row).append(desc);
                }

                desc.css('border-bottom', "2px solid #E0E0E0");

                loader.finish();

            }
        });

    };
};
