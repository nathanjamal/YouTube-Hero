$(document).ready(function() {


    $("#slider").slider({ max: 100, min: 0, value: 50 });

    $('#slider').bind('slide', function(event, ui) {
        var vol = $(this).slider('value');

        if (vol == 50) {
            var volume = 100;
            ytplayer1.setVolume(volume);
            ytplayer2.setVolume(volume);
        } else if (vol >= 51) {
            var volume = (100 - vol) * 2;
            ytplayer1.setVolume(volume);
            ytplayer2.setVolume(100);
        }
        else if (vol <= 49) {
            var volume = vol * 2;
            ytplayer2.setVolume(volume);
            ytplayer1.setVolume(100);
        }
    });

    $('#slider').bind('slidestop', function(event, ui) {
        var vol = $(this).slider('value');

        if (vol == 50) {
            var volume = 100;
            ytplayer1.setVolume(volume);
            ytplayer2.setVolume(volume);
        } else if (vol >= 51) {
            var volume = (100 - vol) * 2;
            ytplayer1.setVolume(volume);
            ytplayer2.setVolume(100);
        }
        else if (vol <= 49) {
            var volume = vol * 2;
            ytplayer2.setVolume(volume);
            ytplayer1.setVolume(100);
        }
    });



    //Drag and drop ******************
    $("#playCue1").droppable({
        drop: function(event, ui) {
            $(this).addClass('dropped').find('p').html('Dropped!');
            var msg = $(ui.draggable).attr('title');
            cuePlayer1(msg);
            $('#results').attr('class', 'showNone');
            setTimeout("$('#playCue1').addClass('dropped').find('p').html('Drag a video');", 3000);
        }
    });

    $("#playCue2").droppable({
        drop: function(event, ui) {
            $(this).addClass('dropped').find('p').html('Dropped!');
            var msg = $(ui.draggable).attr('title');
            cuePlayer2(msg);
            $('#results').attr('class', 'showNone');
            setTimeout("$('#playCue2').addClass('dropped').find('p').html('Drag a video');", 3000);
        }
    });

    //close ie warning
    $('#closeIEImg').click(function() {
       // alert('ff');
        $("#eireally").fadeOut();
    });

});