#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("Сотрудник") Тогда
		Если Параметры.Сотрудник.ЭтоГруппа Тогда
			Отказ = Истина;
		КонецЕсли;
		Сотрудник = Параметры.Сотрудник;
	КонецЕсли;     
	
	ОбновитьСписокОборудованияDICOM();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ЗаписатьНаСервере()
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		НаборРС = РегистрыСведений.ОборудованиеСотрудниковDICOM.СоздатьНаборЗаписей();
		НаборРС.Отбор.Сотрудник.Установить(Сотрудник);
		НаборРС.Прочитать();
		НаборРС.Очистить();
		Для Каждого СтрокаОборудование Из ОборудованиеDICOM Цикл
			ЗаписьРС = НаборРС.Добавить();
			ЗаписьРС.Оборудование = СтрокаОборудование.Оборудование;
			ЗаписьРС.Сотрудник = Сотрудник;
		КонецЦикла;
		НаборРС.Записать(Истина);
	КонецЕсли;
	ОбновитьСписокОборудованияDICOM();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьНаСервере(); 
КонецПроцедуры 

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьНаСервере(); 
	ЭтаФорма.Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

&НаСервере
Процедура ОбновитьСписокОборудованияDICOM()
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОборудованиеСотрудниковDICOM.Оборудование
		|ИЗ
		|	РегистрСведений.ОборудованиеСотрудниковDICOM КАК ОборудованиеСотрудниковDICOM
		|ГДЕ
		|	ОборудованиеСотрудниковDICOM.Сотрудник = &Сотрудник";
		
		Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
		ОборудованиеDICOM.Загрузить(Запрос.Выполнить().Выгрузить());
	КонецЕсли;
	
КонецПроцедуры  

#КонецОбласти
