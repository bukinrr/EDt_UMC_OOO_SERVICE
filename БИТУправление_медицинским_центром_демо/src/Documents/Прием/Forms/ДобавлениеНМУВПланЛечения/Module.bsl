#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.МассивПараметровДляЗаменыНоменклатуры.Количество() > 1 Тогда
		Элементы.ГруппаНМУ.Видимость = Ложь;
		Для Каждого ПараметрыДляЗаменыНоменклатуры Из Параметры.МассивПараметровДляЗаменыНоменклатуры Цикл
			СтруктураСтрокиНМУ = ПараметрыДляЗаменыНоменклатуры.СтруктураТекущейСтрокиНМУ;
			СтрокаНМУ = НМУИзСтандартаЛечения.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНМУ, СтруктураСтрокиНМУ);
			ДобавитьВСписокНоменклатурДляДанныхВыбора(ПараметрыДляЗаменыНоменклатуры.МассивНоменклатурДляДанныхВыбора, СтруктураСтрокиНМУ.НМУ);
		КонецЦикла;
	Иначе
		КлючСохраненияПоложенияОкна = 1;
		
		Элементы.НМУИзСтандартаЛечения.Видимость = Ложь;
		ПараметрыДляЗаменыНоменклатуры = Параметры.МассивПараметровДляЗаменыНоменклатуры[0];
		СтруктураСтрокиНМУ = ПараметрыДляЗаменыНоменклатуры.СтруктураТекущейСтрокиНМУ;
		
		НМУ = СтруктураСтрокиНМУ.НМУ;
		Количество = СтруктураСтрокиНМУ.Количество;
		ВидНазначения = СтруктураСтрокиНМУ.ВидНазначения;
		СтруктураСтрокиНМУ.Свойство("Номенклатура", Номенклатура);
		КодНМУ = НМУ.Код;
		
		ДобавитьВСписокНоменклатурДляДанныхВыбора(ПараметрыДляЗаменыНоменклатуры.МассивНоменклатурДляДанныхВыбора, НМУ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	МассивСтрокНМУ = Новый Массив;
	Если Элементы.НМУИзСтандартаЛечения.Видимость Тогда
		ВсеНМУ = НМУИзСтандартаЛечения;
	Иначе
		ВсеНМУ = Новый Массив;
		СтруктураНМУ = Новый Структура;
		СтруктураНМУ.Вставить("НМУ", НМУ);
		СтруктураНМУ.Вставить("ВидНазначения", ВидНазначения);
		СтруктураНМУ.Вставить("Номенклатура", Номенклатура);
		СтруктураНМУ.Вставить("Количество", Количество);
		ВсеНМУ.Добавить(СтруктураНМУ);
	КонецЕсли;
	
	Для Каждого СтрокаНМУ Из ВсеНМУ Цикл
		Если Не ЗначениеЗаполнено(СтрокаНМУ.Номенклатура) Тогда
			ПоказатьПредупреждение(,НСтр("ru='Укажите номенклатуру плана лечения'"));
			Возврат;
		КонецЕсли;
		СтруктураСтрокиНМУ = Новый Структура();
		СтруктураСтрокиНМУ.Вставить("НМУ",			СтрокаНМУ.НМУ);
		СтруктураСтрокиНМУ.Вставить("ВидНазначения",СтрокаНМУ.ВидНазначения);
		СтруктураСтрокиНМУ.Вставить("Номенклатура",	СтрокаНМУ.Номенклатура);
		СтруктураСтрокиНМУ.Вставить("Количество",	СтрокаНМУ.Количество);
		МассивСтрокНМУ.Добавить(СтруктураСтрокиНМУ);
	КонецЦикла;
	
	Закрыть(МассивСтрокНМУ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НоменклатураАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	НоменклатураЭтойНМУ = СписокНоменклатурДляДанныхВыбора.НайтиСтроки(Новый Структура("НМУ", ?(Элемент.Имя = "Номенклатура", НМУ,Элементы.НМУИзСтандартаЛечения.ТекущиеДанные.НМУ)));
	ЕстьНоменклатураНМУ = НоменклатураЭтойНМУ.Количество() > 0;
	
	Если ЕстьНоменклатураНМУ Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		Для Каждого СтрокаНМУ Из НоменклатураЭтойНМУ Цикл
			ДанныеВыбора.Добавить(СтрокаНМУ.Номенклатура);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьВСписокНоменклатурДляДанныхВыбора(МассивНоменклатурДляДанныхВыбора, НМУ)
	Для Каждого НоменклатураДляДанныхВыбора Из МассивНоменклатурДляДанныхВыбора Цикл
		СтрокаТЗ = СписокНоменклатурДляДанныхВыбора.Добавить();
		СтрокаТЗ.Номенклатура = НоменклатураДляДанныхВыбора;
		СтрокаТЗ.НМУ = НМУ;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти