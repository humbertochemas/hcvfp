*-- PROGRAMA PARA MOSTRAR VENTANA DE NAVEGADOR EN FORMULARIO DE VFP
m.iframe = .T.
IF m.iframe = .T.
	m.sitioweb = CURDIR()+'HTMLMentum.html' && C�digo HTML para mostrar una p�gina web en un iframe
ELSE
	m.sitioweb = "http://mentum.group"
ENDIF

DO FORM vfpbrowser