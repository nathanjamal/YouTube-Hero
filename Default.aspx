﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Youtube Hero | Mix youtube videos with a crossfader</title>
    
    <link href="css/madstylz.css" rel="stylesheet" type="text/css" />
    <link type="text/css" href="css/vader/vader.css" rel="stylesheet" />
      <link href="css/colorbox.css" rel="stylesheet" type="text/css" />
      
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>
    <script src="js/jquery.colorbox-min.js" type="text/javascript"></script>
    <script src="browserDetect.js" type="text/javascript"></script>
    
     <script type="text/javascript">
         $(document).ready(function() {

           //  if (BrowserDetect.browser == "Explorer") {
           //      $("#eireally").show();
           //  }

             //randon string
             function random() {

                 var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
                 var string_length = 8;
                 var randomstring = '';
                 for (var i = 0; i < string_length; i++) {
                     var rnum = Math.floor(Math.random() * chars.length);
                     randomstring += chars.substring(rnum, rnum + 1);
                 }
                 return randomstring;
             }

             //Ajax search ***************************
             $('#searchField').keydown(function(e) {
                 if (e.keyCode == 13) {
                     searchtheTube(); return false;
                 }
             });

             $('#searchButton').click(function() {
                 searchtheTube();
             });

             function searchtheTube() {
                 $('#searchButton').attr('src', 'img/loader.gif'); //show load bar
                 $('#list').html("");
                 var term = document.getElementById('searchField');
                 //Call server side function
                 //  alert(term.value);
                 PageMethods.searchYT(term.value, sent, fail);
                 var term = "";
             }

             function sent() {
                 var listSize = 10; var i = 0;
                 var fileName = $('#hiddenDiv').find('input').val();
                 $('#results').attr('class', 'results');

                 $.ajax({
                     type: "GET",
                     url: "xml/" + fileName + ".xml?randNum=" + new Date().getTime(),
                     dataType: "xml",
                     success: function(addfromComp) {

                         $(addfromComp).find('item').each(function() {
                             if (i <= listSize) {
                                 var title = $(this).find('title').text();
                                 var thumb = $(this).find('thumb').text();
                                 var file = $(this).find('vidurl').text();
                                 var altTag = $(this).find('altTag').text();
                                 $('#list').append("<li title='" + title + "' id='" + file + "'><img src='" + thumb + "' height='40px' alt='" + altTag + "'/><p>" + title + "</p></li>");
                                 $('li').draggable({ cursor: 'crosshair', revert: 'invalid', cursorAt: { top: 20, left: 165} });
                                 i++;
                             }
                         });
                     }
                 });
                 $('#searchButton').attr('src', 'img/search.gif'); //show mag
             }

             function fail() {
                 //alert(' :( SORRY FAM... this app is still in beta and sometimes it wont find what what you want. You can try SWAPPING THE SEARCH WORDS AROUND sometimes that works.');
                 $('#list').append("<li>Shizzle no results!</li>");
                 $('#searchButton').attr('src', 'img/search.gif'); //show mag
             }

             //list buttons
             $('#more').click(function() { searchtheTube(12); $(this).hide(); });
             $('#close').click(function() { $('#results').attr('class', 'showNone'); });


             //feedback
             $('#feedbackTab').click(function() {
                 var state = $('a', '#feedbackTab').attr('title');
                 if (state == 0) {
                     $('#feedback').animate({ 'bottom': '0px' });
                     $('a', '#feedbackTab').attr('title', '1');
                 } else {
                     $('#feedback').animate({ 'bottom': '-240px' });
                     $('a', '#feedbackTab').attr('title', '0');
                 }
             });


             fieldClick = 0;

             $('#searchField').click(function() {// clear field on click
                 if (fieldClick == 0) {
                     $(this).attr({ 'value': '', 'class': 'secondText' });
                     fieldClick = 1;
                 }
             });

         });
     </script>
</head>
<body id="body" style="text-align: -moz-center;">
  
  
    <form id="form1" runat="server" >
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <div>
   
    <div id="topRow" class="aRow">
    
    <div id="playCue1" class="ui-widget-header dropBox inlineBlock">
    <p>Drag a video</p>
    </div>
    
    <div id="searchBox" class="inlineBlock">
    <input id="searchField" type="text" value="Search the Tube" /><img id="searchButton" src="img/search.gif" width="48px" height="48px" alt="search the tube" />
        <p class="lilMsg">or type @ followed buy an authors name for vids by that person.</p>
    <div class="showNone" id="results"> 
        <ul id="list">
        </ul>
        <a class="listButtons" href="#" id="close">CLOSE</a>
       <!-- <a class="listButtons" id="more">MORE</a>-->
    </div>
    </div>

    
     <div id="playCue2" class="dropBox inlineBlock ui-widget-header">
   <p>Drag a video</p>
    </div>
    
    </div>
    
    
    <div id="vidRow" class="aRow">
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.1/swfobject.js"></script>    
  <div class="playerWindow" id="ytapiplayer">
    You need Flash player 8+ and JavaScript enabled to view this video.
  </div>
  
  <div class="playerWindow" id="ytapiplayer2">
    You need Flash player 8+ and JavaScript enabled to view this video.
  </div>

  <script type="text/javascript">
//player1
      var params = { allowScriptAccess: "always", "wmode": "transparent" };
    var atts = { id: "myytplayer", "wmode":"transparent" };
    swfobject.embedSWF("http://www.youtube.com/v/_15fQIYgIaE?enablejsapi=1&playerapiid=ytplayer",
                       "ytapiplayer", "45%", "100%", "8", null, null, params, atts);

//player2
    var params = { allowScriptAccess: "always", "wmode": "transparent" };
    var atts = { id: "myytplayer2", "wmode": "opaque" };
    swfobject.embedSWF("http://www.youtube.com/v/tDZy6-fMCw4?enablejsapi=1&playerapiid=ytplayer",
                       "ytapiplayer2", "45%", "100%", "8", null, null, params, atts);
                       
      
  //  function xFader(vol) {
 //ytplayer1.setVolume(volume:vol);
  //  }                 

    function onYouTubePlayerReady(playerId) {
        ytplayer1 = document.getElementById("myytplayer");
        ytplayer2 = document.getElementById("myytplayer2");
      //  ytplayer1.loadVideoByUrl("http://www.youtube.com/v/K69tgnEhUw8", parseInt(0));
    }

    function cuePlayer1(urlG) {
        ytplayer1.cueVideoByUrl(urlG, parseInt(0)); 
    }

    function cuePlayer2(urlG) {
        ytplayer2.cueVideoByUrl(urlG, parseInt(0));
    } 
  </script>
  </div>
    
  <div class="aRow">  
    
    <div id="crossFader" class="inlineBlock">
    <div id="slider"></div>
    </div>
    
    </div>
    
    </div>
    <div id="hiddenDiv">
    <asp:HiddenField ID="HiddenField1" runat="server" />
    </div>
    
    
    <div id="feedback" class="feedback">
    <div id="feedbackTab"><a title="0" href="#">The Wall</a></div>
    
    <div id="twitterCont">
    <ul id="twitter_update_list">
    <li>aw snap! some fool broke the wall. I'll try get it fixed soon</li>
    </ul>
    </div>
    <!--<textarea id="feedbackArea">Let me know what you think e.g. "haha u r gay"</textarea>-->
    <input id="feedbackField" type="text" maxlength="140" /><a href="#" id="feedbackSubmit">Submit</a>
    
    </div>
    
    <div style="display: none;"><!--for debuging-->
    <asp:TextBox ID="TextBox1" Text="" runat="server"></asp:TextBox>
    <asp:Button ID="Button1" runat="server" Text="Button" />
    </div>

  <div id="eireally">
  <img id="closeIEImg" class="closeIEImg" src="img/closebox.gif" title="close" alt="" />  
  <p><strong>IE... &nbsp;&nbsp;Really?<br /> I thought you were better then that</strong></p>
  <p>Oh well i guess no ones perfect.<br />But seriously you should go and get a real browser like:</p>
  <p><a id="crome" target="_blank" href="http://www.google.co.uk/chrome">Chrome</a>, <a id="firefox" target="_blank" href="http://www.getfirefox.com">FireFox</a> or <a id="safari" target="_blank" href="http://www.apple.com/safari/">Safari</a>.</p>
  </div>

<!-- AddThis Button BEGIN -->
<div style="position:absolute;left:43%;bottom:4px;" class="addthis_toolbox addthis_default_style">
<a href="http://www.addthis.com/bookmark.php?v=250&amp;username=nathanjamal" class="addthis_button_compact">Share</a>
<span class="addthis_separator">|</span>
<a class="addthis_button_facebook"></a>
<a class="addthis_button_digg"></a>
<a class="addthis_button_google"></a>
<a class="addthis_button_twitter"></a>
</div>
<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=nathanjamal"></script>
<!-- AddThis Button END -->

  
   <a id="waih" href="http://weareinternethipsters.tumblr.com/" target="_blank">
  <img src="img/internethipsters.png" alt="We are Internet Hipsters" />
  <span>GO HERE</span>
  </a>
    
    </form>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-12217895-3");
pageTracker._trackPageview();
} catch(err) {}</script>


</body>

<script type="text/javascript" src="http://twitter.com/javascripts/blogger.js"></script>
<script type="text/javascript" src="http://twitter.com/statuses/user_timeline/YouTube_Hero.json?callback=twitterCallback2"></script>
    <script type="text/javascript" src="js/ui.core.js"></script>
    <script type="text/javascript" src="js/ui.slider.js"></script>
    <script type="text/javascript" src="js/ui.draggable.js"></script>
    <script type="text/javascript" src="js/ui.droppable.js"></script>
      <script src="js/jquery.mousescroller.js" type="text/javascript"></script>
<script src="js/someFunctions.js" type="text/javascript"></script>



</html>
