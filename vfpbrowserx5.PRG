LOCAL nVfpTop
nVfpTop = _VFP.TOP
_VFP.TOP = 864

* Generate some temporary html page names
DIME aPages[4]
aPages[1] = SYS(2015)+".htm"
aPages[2] = SYS(2015)+".htm"
aPages[3] = SYS(2015)+".htm"
aPages[4] = SYS(2015)+".htm"

SET TEXTMERGE ON

* Create a frameset html page
SET TEXTMERGE TO (ADDBS(SYS(2023))+aPages[1]) NOSHOW
TEXT
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Frame Page</title>
</head>
<frameset rows="101,*">
  <frame name="banner" scrolling="no" noresize target="contents" src="<<aPages[2]>>">
  <frameset cols="200,*">
    <frame name="contents" target="main" src="<<aPages[3]>>">
    <frame name="main" src="<<aPages[4]>>">
  </frameset>
  <noframes>
  <body>
  <p>This page uses frames, but your browser doesn't support them.</p>
  </body>
  </noframes>
</frameset>
</html>
ENDTEXT

* Top banner page
SET TEXTMERGE TO (ADDBS(SYS(2023))+aPages[2]) NOSHOW
TEXT
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>top banner</title>
<base target="contents">
</head>
<body>
<H1>This is the top level banner</h1>
</body>
</html>
ENDTEXT

* Left navigation page
SET TEXTMERGE TO (ADDBS(SYS(2023))+aPages[3]) NOSHOW
TEXT
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Left navigation</title>
<base target="main">
</head>
<body>
<H1>Left navigation panel</h1>
</body>
</html>
ENDTEXT

* Main target page
SET TEXTMERGE TO (ADDBS(SYS(2023))+aPages[4]) NOSHOW
TEXT
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Main Page</title>
</head>
<body>
  <p><input type="text" name="T1" size="40"></p>
</body>
</html>
ENDTEXT

SET TEXTMERGE TO
SET TEXTMERGE OFF

LOCAL oIe, oFeedBack
oIe = CREATEOBJECT("InternetExplorer.Application")
oIe.WIDTH = 500
oIe.TOP = 20
oIe.LEFT = 10
oIe.navigate((ADDBS(SYS(2023))+aPages[1]))
DO WHILE oIe.busy
ENDDO
oIe.VISIBLE = .T.
oFeedBack = CREATEOBJECT("clsFeedBack")
oFeedBack.SHOW()

* I knew exactly what the object was, but
* you can determine it by its id or tagname
oIe.DOCUMENT.frames(2).DOCUMENT.ALL.ITEM(6).VALUE = "This is the main text box"

MESSAGEBOX("Type some text in the text field on the web page."+CHR(13)+;
    "This little program will grab the data you enter in the web pages' text field."+CHR(13)+;
    CHR(13)+"Enter 'Done' IN the TEXT FIELD TO EXIT"+CHR(13)+CHR(13)+;
    "You'll need to activate the IE window yourself",48,"Instructions")

oIe.DOCUMENT.frames(2).DOCUMENT.ALL.ITEM(6).Focus()

DECLARE INTEGER Sleep IN win32api INTEGER


DO WHILE UPPER(ALLT(oIe.DOCUMENT.frames(2).DOCUMENT.ALL.ITEM(6).VALUE)) <> "DONE"
    oFeedBack.txtOne.VALUE = oIe.DOCUMENT.frames(2).DOCUMENT.ALL.ITEM(6).VALUE
    Sleep(100)
ENDDO

_VFP.TOP = nVfpTop


oIe.QUIT
DELETE FILE ((ADDBS(SYS(2023))+aPages[1]))
DELETE FILE ((ADDBS(SYS(2023))+aPages[2]))
DELETE FILE ((ADDBS(SYS(2023))+aPages[3]))
DELETE FILE ((ADDBS(SYS(2023))+aPages[4]))


DEFINE CLASS clsFeedBack AS FORM
    DOCREATE = .T.
    DESKTOP = .T.
    LEFT = 550
    TOP = 20
    CAPTION = "Changing value of webpage field"

    ADD OBJECT txtOne AS TEXTBOX WITH ;
        HEIGHT = 30, ;
        LEFT = 10, ;
        TOP = THIS.HEIGHT / 2 - 15, ;
        WIDTH = THIS.WIDTH - 20

ENDDEFINE