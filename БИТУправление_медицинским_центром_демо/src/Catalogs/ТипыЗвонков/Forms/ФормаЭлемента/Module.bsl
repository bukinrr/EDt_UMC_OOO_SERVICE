#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДопустимыеИсходы, "ТипЗвонка", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДопустимыеИсходы, "ТипЗвонка", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ДопустимыеИсходыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	РаботаСДиалогамиКлиент.ПередНачаломДобавленияВПодчиненныйСписокНаФормеОбъекта(ЭтаФорма, Элемент, Отказ);
КонецПроцедуры

#КонецОбласти