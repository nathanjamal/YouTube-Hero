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
            var msg = $(ui.draggable).attr('id');
            cuePlayer1(msg);
            $('#results').attr('class', 'showNone');
            setTimeout("$('#playCue1').addClass('dropped').find('p').html('Drag a video');", 3000);
        }
    });

    $("#playCue2").droppable({
        drop: function(event, ui) {
            $(this).addClass('dropped').find('p').html('Dropped!');
            var msg = $(ui.draggable).attr('id');
            cuePlayer2(msg);
            $('#results').attr('class', 'showNone');
            setTimeout("$('#playCue2').addClass('dropped').find('p').html('Drag a video');", 3000);
        }
    });

    //the wall
    $('#feedbackSubmit').click(function() {
        $(this).html('1 sec');
        var feed = document.getElementById('feedbackField');
        PageMethods.TweetIt(feed.value, sent2, fail2);
    });

    function sent2() { createJSONtweet(); $('#feedbackSubmit').html('Sent'); }
    function fail2() { $('#feedbackSubmit').html('Fail :('); setTimeout("$('#feedbackSubmit').html('Submit');", 2000); }

    function createJSONtweet() {
        var getTweet = document.createElement("script");
        getTweet.src = "http://twitter.com/statuses/user_timeline/YouTube_Hero.json?callback=twitterCallback2& count=1";
        document.getElementById('body').appendChild(getTweet);
    }

    //wall scrolling
    var listItem = $('#twitter_update_list li'); var container = $('#twitterCont');

    $('#twitterCont').mousemove(function(e) {
        //Sidebar Offset, Top value
        var s_top = parseInt($(container).offset().top + 10);
        //Sidebar Offset, Bottom value
        var s_bottom = parseInt($(container).height() + s_top);
        //Roughly calculate the height of the menu by multiply height of a single LI with the total of LIs
        var mheight = parseInt($(listItem).height() * $(listItem).length + 60);

        //Calculate the top value  
        //This equation is not the perfect, but it 's very close      
        var top_value = Math.round(((s_top - e.pageY) / 100) * mheight / 2)

         $('#twitter_update_list').animate({ top: top_value }, { queue: false, duration: 500 });
    });

     $('#twitterCont').mouseout(function() {
         var resetList = setTimeout("$('#twitter_update_list').animate({ top: '0px' }, { queue: false, duration: 500 });", 2000);
         $('#twitterCont').mouseover(function() { clearTimeout(resetList); });
     });


    //close ie warning
    $('#closeIEImg').click(function() {
        // alert('ff');
        $("#eireally").fadeOut();
    });

});