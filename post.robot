*** Settings ***
Documentation		Teste Projeto

*** Variables ***
${name}		Cristian Eisenhut

*** Keywords ***
Imprimir nome
	Log To Console		Olá ${name}, seja bem vindo ao dojo Robot
	
*** Test Cases ***
Imprimir nome no terminal
	[Tags]	test1	regressivo
	Imprimir nome

Imprimir nome no terminal2
	[Tags]	test2	regressivo
	Imprimir nome	