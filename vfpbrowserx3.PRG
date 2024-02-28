*1* created on 20 of march 2017
*building a youtube player with  playlist of media (video,audio)

publi yform
yform=newObject("youtube")
yform.show
read events

DEFINE CLASS youtube AS form
Height = 539
Width = 946
ShowWindow = 2
ShowTips = .T.
AutoCenter = .T.
Caption = "Youtube PlayList"
Name = "Form1"

ADD OBJECT olecontrol1 AS olecontrol WITH ;
Oleclass="shell.explorer.2",;
Top = 14, ;
Left = 0, ;
Height = 528, ;
Width = 948, ;
Anchor = 15, ;
Name = "Olecontrol1"

ADD OBJECT shape1 AS shape WITH ;
Top = 0, ;
Left = 890, ;
Height = 13, ;
Width = 13, ;
Anchor = 768, ;
Curvature = 99, ;
MousePointer = 15, ;
ToolTipText = "Titlebar on/off", ;
SpecialEffect = 0, ;
BackColor = RGB(255,0,0), ;
Name = "Shape1"

ADD OBJECT  yhelp AS shape with ;
Top = 0,;
Left = 922,;
Height = 13,;
Width = 13,;
Anchor = 768,;
Curvature = 99,;
MousePointer = 15,;
ToolTipText = "Summary Help",;
SpecialEffect = 0,;
BackColor = RGB(0,255,0),;
Name = "yhelp"


PROCEDURE yhelp.Click
local m.myvar
text to m.myvar pretext 7 noshow
The JavaScript API allows users to control embedded YouTube video players and Chromeless via JavaScript.
youtube video can be embed in an iframe with all parameters needed.

< iframe class="youtube-player" id="player" type="text/html" src="http://www.youtube.com/embed/JW5meKfy3fY?wmode=opaque&autohide=1&autoplay=1&enablejsapi=1" frameborder="0" ><br />< / iframe >

that is suffisent to play youtube video with custom parameters.
this code embed on a top level form a vfp IE browser with a player configured with javascript.

Functions can be called to play a video, pause it, reach certain passages, adjust the volume, mute the
sound and use other useful features.
The best refrence for that is here:https://developers.google.com/youtube/js_api_reference?csw=1
this work is adapted from this tutoriel:http://demo.tutorialzine.com/2015/08/how-to-control-youtubes-video-player-with-javascript/
can gather some youtube video IDs in a cursor  and build easily a playlist as we show on youtube.
the left pannel menu of the player is the playlist (here 10 youtub videos with their IDs only no less no more).
if the url captured from any youtube video (right click on and grab url) is for ex: http://youtube-be/Xa0Q0J5tOP0
the videoID is:Xa0Q0J5tOP0 that is what compose the cursor ycurs created(otherwise get errors and video dont play).
All the code is of course javascript overlapped by VFP as builder.
the youtube video resizes with the form,can show/hide form titlebar.
Of course all the video controls are in the video area.
this desserves  also for any youtube audio.
the html file (captured in temp folder) can be exported as static file for ex to a presentation,...(comment the line in form
destroy event for this purpose.)
endtext
*messagebox(m.myvar,0+32+4096,"Summary help")

_cliptext=m.myvar
#define MB_ICONINFORMATION 0x00000040
#define MB_OK 0x00000000
#define MB_APPLMODAL 0x00000000
#define  MB_DEFBUTTON1 0x00000000

DECLARE INTEGER MessageBox IN user32 As MessageBoxA;
INTEGER hwnd,;
STRING  lpText,;
STRING  lpCaption,;
INTEGER wType

*buttons
#define MB_ABORTRETRYIGNORE 0x00000002
#define MB_CANCELTRYCONTINUE 0x00000006
#define MB_HELP 0x00004000

#define MB_OKCANCEL 0x00000001
#define MB_RETRYCANCEL 0x00000005
#define MB_YESNO  0x00000004
#define MB_YESNOCANCEL 0x00000003

*Icons
#define  MB_ICONEXCLAMATION 0x00000030
#define MB_ICONWARNING 0x00000030

#define MB_ICONASTERISK 0x00000040
#define MB_ICONQUESTION 0x00000020
#define MB_ICONSTOP 0x00000010
#define MB_ICONERROR 0x00000010
#define MB_ICONHAND  0x00000010

*To indicate the default button, specify one of the following values.

#define MB_DEFBUTTON2 0x00000100
#define MB_DEFBUTTON3 0x00000200
#define MB_DEFBUTTON4 0x00000300

*To indicate the modality of the dialog box, specify one of the following values.

#define MB_SYSTEMMODAL 0x00001000
#define MB_TASKMODAL 0x00002000

*To specify other options, use one or more of the following values.
#define MB_DEFAULT_DESKTOP_ONLY 0x00020000
#define MB_RIGHT 0x00080000
#define MB_RTLREADING  0x00100000
#define MB_SETFOREGROUND  0x00010000
#define MB_TOPMOST  0x00040000
#define MB_SERVICE_NOTIFICATION 0x00200000

*Return code
#define IDABORT 3
#define IDCANCEL 2
#define IDCONTINUE 11
#define IDIGNORE 5
#define IDNO 7
#define IDOK 1
#define IDRETRY 4
#define IDTRYAGAIN 10
#define IDYES 6
MessageBoxA(_vfp.hwnd,m.myvar,"Summary help (text in clipboard)",MB_APPLMODAL+MB_OK +MB_ICONINFORMATION +MB_DEFBUTTON1 )
ENDPROC

PROCEDURE ybuild
sele ycurs
locate
local pl1,pl
pl1=allt(xmedia)
pl=""
scan for recno()>1
pl=pl+allt(xmedia)+iif(recno()<reccount(),",","")
endscan

local m.myvar,m.xx
text to m.xx textmerge noshow
<script>
var player,
time_update_interval = 0;

function onYouTubeIframeAPIReady() {
player = new YT.Player('video-placeholder', {
width: <<thisform.width>>,
height: <<thisform.height-14>>,
videoId: '<<m.pl1>>',
playerVars: {
	color: 'white',
	enablejsapi:1,
	frameborder:0 ,
	allowfullscreen:1,
	autoplay:1,
	rel:0,	
	playlist: '<<m.pl>>'
},
events: {
	onReady: initialize
}
});
}

function initialize(){

// Update the controls on load
updateTimerDisplay();
updateProgressBar();

// Clear any old interval.
clearInterval(time_update_interval);

// Start interval to update elapsed time display and
// the elapsed part of the progress bar every second.
time_update_interval = setInterval(function () {
updateTimerDisplay();
updateProgressBar();
}, 1000);

$('#volume-input').val(Math.round(player.getVolume()));
}

// This function is called by initialize()
function updateTimerDisplay(){
// Update current time text display.
$('#current-time').text(formatTime( player.getCurrentTime() ));
$('#duration').text(formatTime( player.getDuration() ));
}

// This function is called by initialize()
function updateProgressBar(){
// Update the value of our progress bar accordingly.
$('#progress-bar').val((player.getCurrentTime() / player.getDuration()) * 100);
}

// Progress bar
$('#progress-bar').on('mouseup touchend', function (e) {

// Calculate the new time for the video.
// new time in seconds = total duration in seconds * ( value of range input / 100 )
var newTime = player.getDuration() * (e.target.value / 100);

// Skip video to new time.
player.seekTo(newTime);

});

// Playback

$('#play').on('click', function () {
player.playVideo();
});


$('#pause').on('click', function () {
player.pauseVideo();
});

// Sound volume

$('#mute-toggle').on('click', function() {
var mute_toggle = $(this);

if(player.isMuted()){
player.unMute();
mute_toggle.text('volume_up');
}
else{
player.mute();
mute_toggle.text('volume_off');
}
});

$('#volume-input').on('change', function () {
player.setVolume($(this).val());
});

// Other options

$('#speed').on('change', function () {
player.setPlaybackRate($(this).val());
});

$('#quality').on('change', function () {
player.setPlaybackQuality($(this).val());
});

// Playlist

$('#next').on('click', function () {
player.nextVideo()
});

$('#prev').on('click', function () {
player.previousVideo()
});

// Load video

$('.thumbnail').on('click', function () {

var url = $(this).attr('data-video-id');

player.cueVideoById(url);

});

// Helper Functions

function formatTime(time){
time = Math.round(time);

var minutes = Math.floor(time / 60),
seconds = time - minutes * 60;

seconds = seconds < 10 ? '0' + seconds : seconds;

return minutes + ":" + seconds;
}

$('pre code').each(function(i, block) {
hljs.highlightBlock(block);
});
</script>
endtext

text to m.myvar textmerge noshow
<!DOCTYPE html>
<html>

<head lang="en">
<meta charset="UTF-8">
<title>How to Control YouTube's Video Player with JavaScript</title>
<link rel="stylesheet" href="http://demo.tutorialzine.com/2015/08/how-to-control-youtubes-video-player-with-javascript/demo.css" type="text/css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">

<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.6/styles/default.min.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.6/styles/tomorrow.min.css">

</head>

<body bgcolor=black scroll="no">
<!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
<div id="video-placeholder"></div>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.6/highlight.min.js"></script>
<script src="https://www.youtube.com/iframe_api"></script>

<<m.xx>>

</body>
</html>
endtext
local m.lcdest
m.lcdest=addbs(sys(2023))+"ytemp.html"
strtofile(m.myvar,m.lcdest)
thisform.olecontrol1.navigate(m.lcdest)
thisform.backcolor=0
ENDPROC

PROCEDURE Destroy
erase addbs(sys(2023))+"ytemp.html
clea events
ENDPROC

PROCEDURE Load
_screen.windowstate=1
set safe off
*build your playlist with youtube videoIds here
create cursor ycurs (xmedia c(150))
insert into ycurs values("Xa0Q0J5tOP0")
insert into ycurs values("INLzqh7rZ-U")
insert into ycurs values("0Bmhjf0rKe8")
insert into ycurs values("Gs8lACWtL-A")
insert into ycurs values("YfKfU8rQGKA")
insert into ycurs values("JtHrsXEa7d4")
insert into ycurs values("M6p1_9MR5PQ")
insert into ycurs values("gwinFP8_qIM")
insert into ycurs values("-_9BYSDtwRc")
insert into ycurs values("JpNg8Z75sEs")
ENDPROC

PROCEDURE Init
sele ycurs
thisform.caption=thisform.caption+"["+trans(reccount())+" item(s)]"
thisform.ybuild()
ENDPROC

PROCEDURE Resize
thisform.olecontrol1.resize()
ENDPROC

PROCEDURE olecontrol1.Init
this.silent=.t.
ENDPROC

PROCEDURE olecontrol1.Resize
*the youtube video fills the form area
try
with thisform.olecontrol1.document.getElementById("video-placeholder")
.width=thisform.width
.height=thisform.height-14
endwith
catch
endtry
ENDPROC

PROCEDURE shape1.Click
with thisform
.titlebar=iif(.titlebar=1,0,1)
do case
case .titlebar=0
.height=.height+sysmetric(9)+sysmetric(4)
case .titlebar=0
.heght=.height-sysmetric(9)-sysmetric(4)
endcase
endwith
ENDPROC

ENDDEFINE
*
*-- EndDefine: youtube
