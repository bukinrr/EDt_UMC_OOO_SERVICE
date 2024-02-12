#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтборДоступностьСоставныеФразы(); 
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьОтборДоступностьСоставныеФразы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура КомандаСоздать(Команда)
	
	Если РаботаСДиалогамиКлиент.ПроверитьМодифицированностьВФорме(ЭтаФорма) Тогда
		ЗначенияЗаполнения = Новый Структура("Параметр, Родитель",Объект.Ссылка, Элементы.Фразы.ТекущаяСтрока);
		ОткрытьФорму("Справочник.СоставныеФразы.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), Элементы.Фразы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкопироватьГФИзДругогоПараметра(Команда)
	
	РаботаСШаблонамиHTMLКлиент.СкопироватьСоставныеФразы(Объект.Ссылка, Элементы.Фразы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура УстановитьОтборДоступностьСоставныеФразы()
	
		Фразы.Параметры.УстановитьЗначениеПараметра("ПараметрШаблона", Объект.Ссылка);
		Фразы.Параметры.УстановитьЗначениеПараметра("Пользователь", Справочники.Пользователи.ПустаяСсылка());
		
КонецПроцедуры

#КонецОбласти