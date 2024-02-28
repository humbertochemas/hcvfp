*-- PROGRAMA PARA MOSTRAR VENTANA DE NAVEGADOR EN FORMULARIO DE VFP
m.iframe = .T.
IF m.iframe = .T.
	m.sitioweb = CURDIR()+'HTMLMentum.html' && Código HTML para mostrar una página web en un iframe
ELSE
	m.sitioweb = "http://mentum.group"
ENDIF

DO FORM vfpbrowser