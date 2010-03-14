<%@ Page Language="VB" AutoEventWireup="false" CodeFile="mobile.aspx.vb" Inherits="_Default" %>

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

             if (BrowserDetect.browser == "Explorer") {
                 $("#eireally").show();
             }


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
                                 $('#list').append("<li title='" + file + "' ><img src='" + thumb + "' height='40px' alt='" + altTag + "'/><p>" + title + "</p></li>");
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

             $('#feedbackSubmit').click(function() {
                 $(this).html('Sending...');
                 var feed = document.getElementById('feedbackArea');

                 //Call server side function
                 PageMethods.sendMail(feed.value, sent2, fail2);
             });
             function sent2() { $('#feedbackSubmit').html('Sent'); }
             function fail2() { $('#feedbackSubmit').html('Sorry, it broke :('); setTimeout("$('#feedbackSubmit').html('Submit');", 2000); }

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
<body style="text-align: -moz-center;">
  
  
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
    swfobject.embedSWF("http://www.youtube.com/v/3Ii8m1jgn_M?enablejsapi=1&playerapiid=ytplayer",
                       "ytapiplayer", "45%", "100%", "8", null, null, params, atts);

//player2
    var params = { allowScriptAccess: "always", "wmode": "transparent" };
    var atts = { id: "myytplayer2", "wmode": "opaque" };
    swfobject.embedSWF("http://www.youtube.com/v/hdWxo3e3Kzk?enablejsapi=1&playerapiid=ytplayer",
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
    <div id="feedbackTab"><a title="0" href="#">Feedback</a></div>
    <textarea id="feedbackArea">Let me know what you think e.g. "haha u r gay"</textarea>
    <a href="#" id="feedbackSubmit">Submit</a>
    
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

<a id="diggButt" class="DiggThisButton" href="http://digg.com/submit">('<img src="http://digg.com/img/diggThisCompact.png" height="18" width="120" alt="DiggThis" />’)</a>

  
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


<script src="http://digg.com/tools/diggthis.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/ui.core.js"></script>
    <script type="text/javascript" src="js/ui.slider.js"></script>
    <script type="text/javascript" src="js/ui.draggable.js"></script>
    <script type="text/javascript" src="js/ui.droppable.js"></script>
<script src="js/someFunctions.js" type="text/javascript"></script>
</html>
