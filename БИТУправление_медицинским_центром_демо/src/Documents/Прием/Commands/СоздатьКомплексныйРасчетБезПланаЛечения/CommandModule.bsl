#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораВидаРасчета", ЭтотОбъект, Новый Структура("Прием", ПараметрКоманды));
	
	ВладелецФормы = ?(ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения"), ПараметрыВыполненияКоманды.Источник, Неопределено);
	
	ОткрытьФорму("Справочник.ВидыКомплексныхРасчетовКлиентов.ФормаВыбора",,ВладелецФормы, ПараметрКоманды,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораВидаРасчета(Вид, Основание) Экспорт
	
	Если ЗначениеЗаполнено(Вид) Тогда
		
		ЗначенияЗаполнения = Новый Структура("Вид, ДокументОснование", Вид, Основание.Прием);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.КомплексныйРасчетКлиента.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти