*** Settings ***
Documentation		Pegar token

Library     RequestsLibrary
Library		String
Library		Collections	
# Resource	../resource/resource.robot
	
*** Variables ***
${baseUrl}			https://lost.qacoders.dev.br/api
${email_admin}		sysadmin@qacoders.com
${senha_admin}		1234@Test
${id_user}			67041315b219fa520523d872
${id_user_inexistente}   67047e97b219fa520523dcb6
${token_fail}		jgkjgkjgkgkjgk

*** Test Cases ***
Listar usuarios
	Listar usuarios
Contar usuarios
	Count users

Pegar usuario por id
	Get users id
Tentar listar usuario inexistente
	Tentar listar usuario inexistente
Tentar listar usuarios com token invalido
	Tentar listar usuarios com token invalido

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

Listar usuarios
	${token}	Pegar token
	${resposta}		GET On Session		alias=develop	url=/user/?token=${token}		expected_status=200
	
	Log  ${resposta.json()}
	Log To Console  ${resposta.json()}

Count users
	${token}	Pegar token
	${resposta}		GET On Session		alias=develop	url=/user/count?token=${token}		expected_status=200
	
	Log To Console		${resposta.json()['count']}
	Log 	${resposta.json()['count']}
	
	
Get users id
	${token}			Pegar token
	${resposta}			GET On Session		alias=develop	url=/user/${id_user}?token=${token}		expected_status=200

	Log 	${resposta.json()}
	Log To Console 	${resposta.json()['_id'][0]}
	
Tentar listar usuario inexistente
	${token}			Pegar token
	${resposta}			GET On Session		alias=develop	url=/user/${id_user_inexistente}?token=${token}		expected_status=404

	Log 	${resposta.json()['alert']}
	Log To Console   ${resposta.json()['alert']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['alert']}		['Esse usuário não existe em nossa base de dados.']
	
Tentar listar usuarios com token invalido
	${token}			Pegar token
	${resposta}			GET On Session		alias=develop	url=/user/${id_user}?token=${token_fail}		expected_status=403

	Log   ${resposta.json()['errors']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['errors']}		['Failed to authenticate token.']
	#verificando session abertas

	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




