#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ТонкийКлиент Или ТолстыйКлиентУправляемоеПриложение Или ТолстыйКлиентОбычноеПриложение Тогда
		ЗаблокироватьРаботуПользователя();
	#Иначе
		ПоказатьПредупреждение(,НСтр("ru='Функция доступна только в следующих клиентских приложениях: тонкий клиент, толстый клиент'"));
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти