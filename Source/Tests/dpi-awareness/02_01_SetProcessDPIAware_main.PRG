? Program()
_Screen.Move (100,100)
on Shutdown Quit

Declare Long SetProcessDPIAware in win32api
SetProcessDPIAware ()

DO FORM ShowHtml WITH "https://github.com/cwollenhaupt/fpCefSharp"
