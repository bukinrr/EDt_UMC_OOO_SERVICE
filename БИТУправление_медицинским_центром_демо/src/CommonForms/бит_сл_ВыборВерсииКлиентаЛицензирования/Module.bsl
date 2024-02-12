#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьВерсиюИзКонстанты();
	Элементы.ИспользуемаяВерсияСистемыЛицензирования.Доступность = ПравоДоступа("Администрирование",Метаданные);
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86
	Тогда
		Элементы.ИспользуемаяВерсияСистемыЛицензирования.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуСистемыЛицензирования(Команда)
	
	Если ИспользуемаяВерсияСистемыЛицензирования = "2.0" Тогда 
		сл2_клиент.СЛ20ОткрытьФормуКлиентаЛицензирования();
	Иначе 
		бит_сл_клиент.ОткрытьФормуКлиентаЛицензирования();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИспользуемаяВерсияСистемыЛицензированияПриИзменении(Элемент)
	
	ВерсияДоИзменения = ИспользуемаяВерсияСистемыЛицензирования;
	ТекстВопроса = НСтр("ru='Для применения изменений необходимо перезапустить приложение. Перезапустить приложение?'");
	Оповещение = Новый ОписаниеОповещения("Перезапустить_ПослеПодтверждения", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, 60, КодВозвратаДиалога.ОК); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьВерсиюИзКонстанты()
	
	Если Не ЗначениеЗаполнено(Константы.ИспользуемаяВерсияСистемыЛицензирования.Получить()) Тогда
		УстановитьПривилегированныйРежим(Истина);
		Константы.ИспользуемаяВерсияСистемыЛицензирования.Установить("2.0")
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86
	Тогда
		ИспользуемаяВерсияСистемыЛицензирования = "1.6";
	Иначе
		ИспользуемаяВерсияСистемыЛицензирования = Константы.ИспользуемаяВерсияСистемыЛицензирования.Получить();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Перезапустить_ПослеПодтверждения(Ответ, ДополнительныеПараметры) Экспорт
  
	Если Ответ = КодВозвратаДиалога.ОК Тогда 
		ИзменитьВыполняемоеРегламентноеЗадание(ИспользуемаяВерсияСистемыЛицензирования);
		ЗавершитьРаботуСистемы(Истина, Истина);
	Иначе
		Если ИспользуемаяВерсияСистемыЛицензирования = "2.0" Тогда 
			ИспользуемаяВерсияСистемыЛицензирования = "1.6";
		Иначе 
			ИспользуемаяВерсияСистемыЛицензирования = "2.0"	
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ИзменитьВыполняемоеРегламентноеЗадание(ИспользуемаяВерсияСистемыЛицензирования) 
	
	Константы.ИспользуемаяВерсияСистемыЛицензирования.Установить(ИспользуемаяВерсияСистемыЛицензирования);
		
		Если ИспользуемаяВерсияСистемыЛицензирования = "2.0" Тогда 
			ЗаданиеСЛ2 = РегламентныеЗадания.НайтиПредопределенное("сл2_МенеджерСеансов");
			ЗаданиеСЛ2.Использование = Истина;
			ЗаданиеСЛ2.Записать();
			ЗаданиеБитСЛ = РегламентныеЗадания.НайтиПредопределенное("бит_сл_МенеджерСеансов");
			ЗаданиеБитСЛ.Использование = Ложь;
			ЗаданиеБитСЛ.Записать();
		Иначе 
			ЗаданиеСЛ2 = РегламентныеЗадания.НайтиПредопределенное("сл2_МенеджерСеансов");
			ЗаданиеСЛ2.Использование = Ложь;
			ЗаданиеСЛ2.Записать();
			ЗаданиеБитСЛ = РегламентныеЗадания.НайтиПредопределенное("бит_сл_МенеджерСеансов");
			ЗаданиеБитСЛ.Использование = Истина;
			ЗаданиеБитСЛ.Записать();
		КонецЕсли;
		
КонецПроцедуры

#КонецОбласти