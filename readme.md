pip install robot-framework
pip install python
pip install robotframework-requests --pre

rodando testes com TAGS
roda regressivo 	robot -d results -i regressivo .\post.robot
roda test1 			robot -d results -i test1 .\post.robot
roda test2 			robot -d results -i test2 .\post.robot

exemplo das tags adicionadas nos testes
<pre>*** Test Cases ***
Imprimir nome no terminal
	[Tags]	test1	regressivo
	Imprimir nome

Imprimir nome no terminal2
	[Tags]	test2	regressivo</pre>

	C:\Users\sandr\Downloads\cristian\QACoders\Academy\Robot-API\get.robot

Page Object em Robot Framework
	Arquivos Resources - tem toda programação da automação:
	Settings, variables e Keywords 

	Arquivos Testes - tem os testes que serão executados:
	Settings para importação a programação e Test Cases para os testes que serão executados

	