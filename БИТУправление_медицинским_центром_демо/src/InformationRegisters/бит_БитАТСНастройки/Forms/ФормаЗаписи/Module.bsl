
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СкрыватьПараметрыПанели Тогда
		Элементы.СоздаватьСобытиеПриВходящемЗвонке.Видимость	= Ложь;
		Элементы.СоздаватьСобытиеПриИсходящемЗвонке.Видимость	= Ложь;
		Элементы.СоздаватьСобытияПриВнутреннихЗвонках.Видимость	= Ложь;
		Элементы.АвтозапускПриСтартеСистемы.Видимость			= Ложь;
		Элементы.РазворачиватьОкноПриВходящемЗвонке.Видимость	= Ложь;
		Элементы.ОткрыватьКартуЯндексПриВходящемЗвонке.Видимость= Ложь;
		Элементы.ПоискДублей.Видимость							= Ложь;
		Элементы.ЗагрузкаЗвонков.Видимость						= Ложь;
		Элементы.ОткрыватьФормуВходящегоЗвонка.Видимость		= Ложь;
	КонецЕсли;
	ОбновитьДоступность();
	
	Элементы.ВерсияТелефонии.Заголовок = "Версия подсистемы телефонии " + бит_ТелефонияСервер.ПолучитьВерсиюПодсистемы();
	
	//+Переопределенное
	Элементы.НеИскатьКонтрагента.Заголовок = НСтр("ru='Не искать клиента'");
	Элементы.ПоискДублей.Заголовок = НСтр("ru='Поиск дублей клиентов'");
	//-Переопределенное
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПрямойНаборПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьСобытиеПриВходящемЗвонкеПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьСобытиеПриИсходящемЗвонкеПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура НомерСвязанногоТелефонаПриИзменении(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДоступность()
	Элементы.ПрефиксВыходаНаВнешнююЛинию.Доступность = НЕ Запись.ИспользоватьПрямойНабор;
	Элементы.СоздаватьСобытияПриВнутреннихЗвонках.Доступность = (Запись.СоздаватьСобытиеПриВходящемЗвонке ИЛИ Запись.СоздаватьСобытиеПриИсходящемЗвонке);
	Элементы.НомерСвязанногоТелефонаДоп.Доступность = ЗначениеЗаполнено(Запись.НомерСвязанногоТелефона);
КонецПроцедуры

#КонецОбласти
