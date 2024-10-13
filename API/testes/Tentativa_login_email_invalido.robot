*** Settings ***
Documentation		Tentativa de login com email inválido

Library     RequestsLibrary
Library		String
Library		Collections
	

*** Variables ***
${baseUrl}		https://lost.qacoders.dev.br/api
${email_invalido}		sys@qacoders.com
${senha_admin}		1234@Test

*** Test Cases ***
Validar tentativa de login com email invalido
	Email invalido


*** Keywords ***
Criar sessao
	${headers}		Create Dictionary		accept=application/json		Content-Type=application/json
	Create Session		alias=develop		url=${baseUrl}		headers=${headers}		verify=true

Email invalido
	${body} 	Create Dictionary
	...		mail=${email_invalido}	
	...		password=${senha_admin}
	
	Criar sessao	
	${resposta}		POST On Session		alias=develop	url=/login		json=${body}  expected_status=400	
	
	Log To Console		${resposta}
	Log To Console		${resposta.json()} 
	Log 		${resposta}
	Log 		${resposta.json()} 

	BuiltIn.Should Be Equal As Strings  ${resposta.json()['alert']}		E-mail ou senha informados são inválidos.

	# Should Be Equal	 ${resposta.json()['alert']}  E-mail ou senha informados são inválidos.

	#verificando session abertas

	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




