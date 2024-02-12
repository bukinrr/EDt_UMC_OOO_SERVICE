
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДополнительныеСвойства = Новый Структура;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		Если Не ЗначениеЗаполнено(Запись.Клиент2) Тогда
			Запись.Клиент2 = ПредопределенноеЗначение("Справочник.Клиенты.ПустаяСсылка");
		КонецЕсли;
		Если ЗначениеЗаполнено(Запись.Клиент) Тогда
			Если Не ЗначениеЗаполнено(Запись.Клиент2) Тогда
				ЭтаФорма.ТекущийЭлемент = Элементы.Клиент2;
			Иначе
				ЭтаФорма.ТекущийЭлемент = Элементы.ТипСвязи;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Запись.Клиент2) = Тип("СправочникСсылка.Клиенты") Тогда		
		ВыборТипа = 1
	Иначе
		ВыборТипа = 2;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбратнаяСвязь = РаботаСКлиентами.ПолучитьОтветнуюРодственнуюСвязь(Запись.ТипСвязи,Запись.Клиент.Пол);
	
	МенеджерЗаписи = РегистрыСведений.СвязиМеждуКлиентами.СоздатьМенеджерЗаписи();	
	МенеджерЗаписи.Клиент = Запись.Клиент2;
	МенеджерЗаписи.Клиент2 = Запись.Клиент;
	МенеджерЗаписи.Прочитать();
	
	Если Не МенеджерЗаписи.Выбран()
		Или МенеджерЗаписи.ТипСвязи <> ОбратнаяСвязь
	Тогда
		МенеджерЗаписи = РегистрыСведений.СвязиМеждуКлиентами.СоздатьМенеджерЗаписи();	
		МенеджерЗаписи.Клиент = Запись.Клиент2;
		МенеджерЗаписи.Клиент2 = Запись.Клиент;
		МенеджерЗаписи.ТипСвязи = ОбратнаяСвязь;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("РодственныеСвязиИзменение", Запись.Клиент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВыборТипаПриИзменении(Элемент)
	
	Если ВыборТипа = 1 Тогда
		Запись.Клиент2 = ПредопределенноеЗначение("Справочник.Клиенты.ПустаяСсылка");	
	Иначе
		Запись.Клиент2 = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти