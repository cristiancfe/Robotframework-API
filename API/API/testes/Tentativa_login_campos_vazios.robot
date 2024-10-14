*** Settings ***
Documentation		Tentativa de login com campos email e senha vazios

Library     RequestsLibrary
Library		String
Library		Collections
	

*** Variables ***
${baseUrl}		https://lost.qacoders.dev.br/api
${email_vazio}		${EMPTY}
${senha_vazio}		${EMPTY}

*** Test Cases ***
Validar tentativa de login com email e senha vazios
	Campos vazios


*** Keywords ***
Criar sessao
	${headers}		Create Dictionary		accept=application/json		Content-Type=application/json
	Create Session		alias=develop		url=${baseUrl}		headers=${headers}		verify=true

Campos vazios
	${body} 	Create Dictionary
	...		mail=${email_vazio}	
	...		password=${senha_vazio}
	
	Criar sessao	
	${resposta}		POST On Session		alias=develop	url=/login		json=${body}  expected_status=400	
	
	Log To Console		${resposta}
	Log To Console		${resposta.json()['password']} 
	Log To Console		${resposta.json()['mail']} 
	Log 		${resposta}
	Log 		${resposta.json()['password']} 
	Log 		${resposta.json()['mail']} 

	BuiltIn.Should Be Equal As Strings  ${resposta.json()['password']}		O campo senha é obrigatório.
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['mail']}		O campo e-mail é obrigatório.
	# Should Be Equal	 ${resposta.json()['mail']}  O campo e-mail é obrigatório.

	#verificando session abertas

	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




