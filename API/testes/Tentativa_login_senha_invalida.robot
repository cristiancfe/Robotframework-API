*** Settings ***
Documentation		Tentativa de login com email inválido

Library     RequestsLibrary
Library		String
Library		Collections
	

*** Variables ***
${baseUrl}		https://lost.qacoders.dev.br/api
${email_valido}		sysadmin@qacoders.com
${senha_invalida}		51@Test

*** Test Cases ***
Validar tentativa de login com senha invalida
	Senha invalida


*** Keywords ***
Criar sessao
	${headers}		Create Dictionary		accept=application/json		Content-Type=application/json
	Create Session		alias=develop		url=${baseUrl}		headers=${headers}		verify=true

Senha invalida
	${body} 	Create Dictionary
	...		mail=${email_valido}	
	...		password=${senha_invalida}
	
	Criar sessao	
	${resposta}		POST On Session		alias=develop	url=/login		json=${body}  expected_status=400	
	
	Log To Console		${resposta}
	Log To Console		${resposta.json()}
	Log 		${resposta}
	Log 		${resposta.json()['alert']} 

	BuiltIn.Should Be Equal As Strings  ${resposta.json()['alert']}		 E-mail ou senha informados são inválidos.

	# Should Be Equal	 ${resposta.json()['alert']}  E-mail ou senha informados são inválidos.

	#verificando session abertas

	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




