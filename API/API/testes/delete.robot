*** Settings ***
Documentation		Pegar Token

Library     RequestsLibrary
Library		String
Library		Collections
	

*** Variables ***
${baseUrl}			https://lost.qacoders.dev.br/api
${email_admin}		sysadmin@qacoders.com
${senha_admin}		1234@Test
${id_user}			67047e97b219fa520523dcb6
${token_fail}		jgkjgkjgkgkjgk

*** Test Cases ***
Deletar usuario	
	Deletar usuario
Tentar deletar usuario inexistente na base de dados
	Usuario inexistente
Tentar deletar usuario utilizando token invalido
	Token invalido

*** Keywords ***
Deletar usuario 
	${token}		Pegar token
	${resposta}		DELETE On Session		alias=develop	url=/user/${id_user}?token=${token}		expected_status=200

	Log 	${resposta.json()['msg']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['msg']}		Usuário deletado com sucesso!.

Usuario inexistente
	${token}		Pegar token
	${resposta}		DELETE On Session		alias=develop	url=/user/${id_user}?token=${token}		expected_status=400

	Log 	${resposta.json()['alert']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['alert']}		['Esse usuário não existe em nossa base de dados.']

Token invalido
	${token}		Pegar token
	${resposta}		DELETE On Session		alias=develop	url=/user/${id_user}?token=${token_fail}		expected_status=403

	Status Should Be   403   ${resposta} 
	
	Log   ${resposta.json()['errors']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['errors']}		['Failed to authenticate token.']

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

	#verificando session abertas
	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




