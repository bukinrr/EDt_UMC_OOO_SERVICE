#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.КнопкаПанельИнформации.Пометка = РаботаСФормамиСервер.ПолучитьНастройкуФормы("ФормаСпискаНоменклатуры", "ОтображатьПанельИнформации", Ложь);
	Элементы.ГруппаПанельИнформации.Видимость = Элементы.КнопкаПанельИнформации.Пометка;
	
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра("Номенклатура",Элементы.Список.ТекущаяСтрока);	
	
	// Настройка видимости панели информации.
	Если Параметры.Свойство("Отбор")
		И Параметры.Отбор.Свойство("ВидНоменклатуры")
		И ТипЗнч(Параметры.Отбор.ВидНоменклатуры) = Тип("ФиксированныйМассив")
		И Параметры.Отбор.ВидНоменклатуры.Найти(Перечисления.ВидыНоменклатуры.Материал) = Неопределено
	Тогда
		Элементы.ГруппаОстатки.Видимость = Ложь;
		Элементы.ЦенаЕдиницаИзмерения.Видимость = Ложь;
	Иначе
		Элементы.ГруппаОстатки.Видимость = ПравоДоступа("Просмотр", Метаданные.РегистрыНакопления.ПартииТоваровНаСкладах);
	КонецЕсли;
	
	Элементы.ЦенаХарактеристикаНоменклатуры.Видимость = УправлениеНастройками.ПараметрУчета("ВестиУчетПоХарактеристикам");
	
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра	("ЕдиницаИзмерения", Неопределено);
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра	("Номенклатура", Неопределено);
	ТабличноеПолеЦена.Параметры.УстановитьЗначениеПараметра		("Номенклатура", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	НастройкиФормы = Новый Структура;
	НастройкиФормы.Вставить("ОтображатьПанельИнформации", Элементы.КнопкаПанельИнформации.Пометка);
	
	РаботаСФормамиСервер.СохранитьНастройкиФормы(НастройкиФормы, "ФормаСпискаНоменклатуры"); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ГруппаПанельИнформации.Видимость Тогда
		// Если панель видна, то обновим её данные.
		ОбновитьОстаткиИЦены();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаПанельИнформацииНажатие(Команда)
	
	Элементы.КнопкаПанельИнформации.Пометка = Не Элементы.КнопкаПанельИнформации.Пометка;
	Элементы.ГруппаПанельИнформации.Видимость = Элементы.КнопкаПанельИнформации.Пометка;	
	Если Элементы.ГруппаПанельИнформации.Видимость Тогда
		ОбновитьОстаткиИЦены();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВАрхив(Команда)

	РаботаСДиалогамиКлиент.ПоместитьВАрхив(Элементы.Список.ВыделенныеСтроки);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоказатьАрхивные(Команда)

	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбновитьОстаткиИЦены()
	
	ЕдиницаИзмерения = ?(Элементы.Список.ТекущиеДанные = Неопределено, Неопределено, Элементы.Список.ТекущиеДанные.ЕдиницаХраненияОстатков);
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра	("ЕдиницаИзмерения", ЕдиницаИзмерения);
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра	("Номенклатура", Элементы.Список.ТекущаяСтрока);
	ТабличноеПолеЦена.Параметры.УстановитьЗначениеПараметра		("Номенклатура", Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти 