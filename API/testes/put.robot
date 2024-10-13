*** Settings ***
Documentation		Pegar Token

Library     RequestsLibrary
Library		String
Library		Collections
	

*** Variables ***
${baseUrl}			https://lost.qacoders.dev.br/api
${email_admin}		sysadmin@qacoders.com
${senha_admin}		1234@Test
${id_user}			6705652db219fa520523df70
${senha_nova}		5679@Test

*** Test Cases ***
Alterar Status de usuario para false
	Alterar Status false
Alterar Status de usuario para true
	Alterar Status true


*** Keywords ***
Criar sessao
	${headers}		Create Dictionary		accept=application/json		Content-Type=application/json
	Create Session		alias=develop		url=${baseUrl}		headers=${headers}		verify=true

Pegar token
	${body} 	Create Dictionary
	...		mail=${email_admin}	
	...		password=${senha_admin}
	
	Criar sessao	
	${resposta}		POST On Session		alias=develop	url=/login		json=${body}  expected_status=200
	
	Log To Console		${resposta}
	Log To Console		${resposta.json()['token']} 
	Log 		${resposta}
	Log 		${resposta.json()['token']} 
	RETURN   	${resposta.json()['token']}

Alterar Status false	
	${token} 	 Pegar token
	${body}		 Create Dictionary		status=false
	${resposta}  PUT On Session  alias=develop  url=/user/status/${id_user}?token=${token}	json=${body}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['msg']}		Status do usuario atualizado com sucesso para status false.
	
Alterar Status true	
	${token} 	 Pegar token
	${body}		 Create Dictionary		status=true
	${resposta}  PUT On Session  alias=develop  url=/user/status/${id_user}?token=${token}	json=${body}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['msg']}		Status do usuario atualizado com sucesso para status true.


	#verificando session abertas

	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




