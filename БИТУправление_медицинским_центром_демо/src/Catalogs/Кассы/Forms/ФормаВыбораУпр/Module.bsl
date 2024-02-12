#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормамиСервер.УстановитьОтборФилиалВФормеСписка(ЭтаФорма,Метаданные.Справочники.Кассы);
	
	ТребуетсяУчетПоФилиалам = УправлениеНастройками.ТребуетсяУчетПоФилиалам();
	Элементы.ОтборФилиал.Видимость = ТребуетсяУчетПоФилиалам;
	Элементы.Филиал.Видимость = ТребуетсяУчетПоФилиалам;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбработкаОтбора();	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	СохранитьНастройкиФормы(ЗначениеЗаполнено(ОтборФилиал));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборФилиалПриИзменении(Элемент)
	ОбработкаОтбора();	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормы(ОтборЗаполнен)
	
	РаботаСФормамиСервер.СохранитьИспользованиеОтбораФилиалВФорме(Метаданные.Справочники.Кассы, ОтборЗаполнен);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтбора() 
	
	Список.Отбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ОтборФилиал) Тогда
		СЗ = Новый СписокЗначений;
		СЗ.Добавить(ОтборФилиал);
		СЗ.Добавить(ПредопределенноеЗначение("Справочник.Филиалы.ПустаяСсылка"));
		РаботаСФормамиКлиент.УстановитьОтборСписка("Филиал", СЗ,  Список);
	Иначе
		РаботаСФормамиКлиент.СнятьОтборСписка("Филиал", Список);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти
