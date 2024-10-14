*** Settings ***
Documentation		Pegar Token

Library     RequestsLibrary
Library		String
Library		Collections
# Library		FakerLibrary
	

*** Variables ***
${baseUrl}		https://lost.qacoders.dev.br/api
${email_admin}		sysadmin@qacoders.com
${senha_admin}		1234@Test
${token_invalido}		hkhlkhljlj
${email_obrigatorio}	${EMPTY}
*** Test Cases ***
Validar Login com Sucesso
	Realizar Login
Criar usuario
	Criar usuario
Tentativa de criar usuario sem token
	Usuario sem token
Tentativa de cadastrar usuario ja cadastrado
	Usuario ja cadastrado
Tentativa de cadastrar usuario sem informar campo obrigatorio
	Campo obrigatorio

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
	
	# Log To Console		${resposta}
	# Log To Console		${resposta.json()['token']} 
	Log 		${resposta}
	Log 		${resposta.json()['token']} 
	Status Should Be   200  ${resposta}
	RETURN  ${resposta.json()['token']}


Criar usuario
	${token}	Realizar Login
	${body} 	Create Dictionary
	...		fullName=Sandra da Silva	
	...		mail=Sandradasilva@gmail.com
	...		password=Cfe@2024
	...		accessProfile=ADMIN
	...		cpf=11137515133
	...		confirmPassword=Cfe@2024
	${resposta}  POST On Session  alias=develop  url=/user/?token=${token}  json=${body} 	expected_status=201
	Status Should Be   201   ${resposta} 

	Log To Console   ${resposta.json()["user"]["_id"]}
	Log To Console   ${resposta.json()["token"]}
	Log   ${resposta.json()["user"]["_id"]}
	Log   ${resposta.json()["user"]["_id"]}

Usuario sem token
    #${token}	${token_invalido} 
	${body} 	Create Dictionary
	...		fullName=Dona das neves	
	...		mail=Donaneves@gmail.com
	...		password=Cfe@2024
	...		accessProfile=ADMIN
	...		cpf=14359514573
	...		confirmPassword=Cfe@2024
	${resposta}  POST On Session  alias=develop  url=/user/?token=${token_invalido}  json=${body} 	expected_status=403
	Status Should Be   403   ${resposta} 
	Log   ${resposta.json()['errors']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['errors']}		['Failed to authenticate token.']

Usuario ja cadastrado
	${token}	Realizar Login
	${body} 	Create Dictionary
	...		fullName=Sandra da Silva	
	...		mail=Sandradasilva@gmail.com
	...		password=Cfe@2024
	...		accessProfile=ADMIN
	...		cpf=11137515133
	...		confirmPassword=Cfe@2024
	${resposta}  POST On Session  alias=develop  url=/user/?token=${token}  json=${body} 	expected_status=409
	Status Should Be   409   ${resposta} 

	Log   ${resposta.json()['alert']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['alert']}		 ['O cpf informado já existe em nossa base de dados.']


Campo obrigatorio	
	${token}	Realizar Login
	${body} 	Create Dictionary
	...		fullName=Franscisco Miguel	
	...		mail=${email_obrigatorio}
	...		password=Cfe@2024
	...		accessProfile=ADMIN
	...		cpf=18404445155
	...		confirmPassword=Cfe@2024
	${resposta}  POST On Session  alias=develop  url=/user/?token=${token}  json=${body} 	expected_status=400
	Status Should Be   400   ${resposta} 

	Log   ${resposta.json()['error']}
	BuiltIn.Should Be Equal As Strings  ${resposta.json()['error']}		['O campo e-mail é obrigatório.']

	#verificando session abertas

	${return}	Session Exists	alias=develop	
	Log 	${return}

	#deletando sessions abertas

	Delete All Sessions

	${return}	Session Exists	alias=develop
	Log 	${return}




