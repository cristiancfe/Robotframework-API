*** Settings ***
Documentation		Pegar Token

Library     RequestsLibrary
Library		String
Library		Collections
	

*** Variables ***
${baseUrl}		https://lost.qacoders.dev.br/api
${email_admin}		sysadmin@qacoders.com
${senha_admin}		1234@Test

*** Test Cases ***
Validar Login com Sucesso
	Realizar Login


*** Keywords ***
Criar sessao
	${headers}		Create Dictionary		accept=application/json		Content-Type=application/json
	Create Session		alias=develop		url=${baseUrl}		headers=${headers}		verify=true

Realizar Login
	${body} 	Create Dictionary
	...		mail=${email_admin}	
	...		password=${senha_admin}
	
	Criar sessao	
	${resposta}		POST On Session		alias=develop	url=/login		json=${body}  expected_status=200
	
	Log To Console		${resposta}
	Log To Console		${resposta.json()['token']} 
	Log 		${resposta}
	Log 		${resposta.json()['token']} 

	#verificando session abertas

	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




