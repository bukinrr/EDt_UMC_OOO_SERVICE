#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДобавитьСтрокуРезультата("Регистрация");
	ДобавитьСтрокуРезультата("ДанныеРегистрации");
	ДобавитьСтрокуРезультата("Метаданные");
	ДобавитьСтрокуРезультата("ЗапросДокумента");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтрацицыЗаросыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьТекстыЗапросаИОтвета(ТекущаяСтраница.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьТекстыЗапросаИОтветаРегистрации(Команда)
	
	ПолучитьТекстыРегистрации(Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеРегистрации(Команда)
	
	ПолучитьДанныеРегистрацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекстЗапросаДанныхРегистрации(Команда)
	
	ОбновитьТекстЗапросаДанныхРегистрацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДокумент(Команда)
	
	ПолучитьДокументНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТекстыЗапросаИОтветаПолучениеДокумента(Команда)
	
	ПолучитьТекстыЗапросаДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьМетаописание(Команда)
	
	ПолучитьМетаописаниеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекстЗапросаМетаданные(Команда)
	
	ОбновитьТекстЗапросаМетаданныеНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеТекстовЗапросов

&НаСервере
Процедура ПолучитьТекстыРегистрации(Документ)
	
	ИдентификаторСообщенияРегистрация = "";
	СтруктураРезультата = ПолучитьСтруктуруРезультатаРегистрации(Документ, ИдентификаторСообщенияРегистрация);
	СтрокаРезультата = Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "Регистрация"))[0];
	ЗаполнитьЗначенияСвойств(СтрокаРезультата, СтруктураРезультата);
	ОбновитьТекстыЗапросаИОтвета("Регистрация");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруРезультатаРегистрации(Документ, ИдентификаторСообщенияРегистрация)
	
	СтруктураРезультата = Новый Структура("Статус, ТекстЗапроса, ТекстОтвета", "", "", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СообщенияРЭМД.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СообщенияРЭМД КАК СообщенияРЭМД
		|ГДЕ
		|	СообщенияРЭМД.ПометкаУдаления = ЛОЖЬ
		|	И СообщенияРЭМД.Документ = &Документ
		|
		|УПОРЯДОЧИТЬ ПО
		|	СообщенияРЭМД.ДатаСоздания УБЫВ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Сообщение = Выборка.Ссылка;
	Иначе
		СтруктураРезультата.Статус = НСтр("ru='Документ не отправлялся в РЭМД'");
		Возврат СтруктураРезультата;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнтеграцияЕГИСЗСообщенияРЭМД.УИДСообщения КАК УИДСообщения,
		|	ИнтеграцияЕГИСЗСообщенияРЭМД.ТекстОшибки КАК ТекстОшибки
		|ИЗ
		|	РегистрСведений.ИнтеграцияЕГИСЗСообщенияРЭМД КАК ИнтеграцияЕГИСЗСообщенияРЭМД
		|ГДЕ
		|	ИнтеграцияЕГИСЗСообщенияРЭМД.ИдентификаторДокумента = &ИдентификаторДокумента";
	
	Запрос.УстановитьПараметр("ИдентификаторДокумента", Сообщение.ИдентификаторДокумента);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		СтруктураРезультата.Статус = НСтр("ru='Сообщение для отправки в РЭМД создано, но ещё не отправлено в РЭМД'");
		Возврат СтруктураРезультата;
	Иначе
		ИдентификаторСообщенияРегистрация = Выборка.УИДСообщения;
		Если ЗначениеЗаполнено(Выборка.ТекстОшибки) Тогда
			ПолучитьЛогиПоСообщению(ИдентификаторСообщенияРегистрация, СтруктураРезультата, "registerdocumentrequest", "registerdocumentresult");
			СтруктураРезультата.Статус = СтрШаблон(НСтр("ru='Процесс регистрации ЭМД в РЭМД завершился с ошибкой ""%1""'"), Выборка.ТекстОшибки);
			Возврат СтруктураРезультата;
		ИначеЕсли Не ЗначениеЗаполнено(Сообщение.ИдентификаторРЭМД) Тогда
			СтруктураРезультата.Статус = НСтр("ru='Запрос на регистрацию ЭМД отправлен в РЭМД, но процесс регистрации ещё не завершён'");
			Возврат СтруктураРезультата;
		КонецЕсли;
	КонецЕсли;
	
	ПолучитьЛогиПоСообщению(ИдентификаторСообщенияРегистрация, СтруктураРезультата, "registerdocumentrequest", "registerdocumentresult");
	
	Возврат СтруктураРезультата;
	
КонецФункции

&НаСервере
Процедура ОбновитьТекстЗапросаДанныхРегистрацииНаСервере()
	
	//Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "ДанныеРегистрации"))[0].ТекстЗапроса = ПолучитьПоследнийТекстЗапросаДанныхРегистрации(ИдентификаторРЭМДДанныеРегистрации);
	//ОбновитьТекстыЗапросаИОтвета("ДанныеРегистрации");
	СтруктураРезультата = Новый Структура("Статус, ТекстЗапроса, ТекстОтвета", "", "", "");
	ПолучитьЛогиПоСообщению(ИдентификаторСообщенияДанныеРегистрации, СтруктураРезультата, "getregistryitemrequest", "getregistryitemresponse");
	СтрокаРезультата = Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "ДанныеРегистрации"))[0];
	ЗаполнитьЗначенияСвойств(СтрокаРезультата, СтруктураРезультата);
	ОбновитьТекстыЗапросаИОтвета("ДанныеРегистрации");
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТекстыЗапросаДокумента()
	
	СтруктураРезультата = Новый Структура("Статус, ТекстЗапроса, ТекстОтвета", "", "", "");
	ПолучитьЛогиПоСообщению(ИдентификаторСообщенияЗапросДокумента, СтруктураРезультата, "demandcontentrequest", "senddocumentfilerequest");
	СтрокаРезультата = Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "ЗапросДокумента"))[0];
	ЗаполнитьЗначенияСвойств(СтрокаРезультата, СтруктураРезультата);
	ОбновитьТекстыЗапросаИОтвета("ЗапросДокумента");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстЗапросаМетаданныеНаСервере()
	
	СтруктураРезультата = Новый Структура("Статус, ТекстЗапроса, ТекстОтвета", "", "", "");
	ПолучитьЛогиПоСообщению(ИдентификаторСообщенияМетаданные, СтруктураРезультата, "getmetadatarequest", "getmetadataresponse");
	СтрокаРезультата = Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "Метаданные"))[0];
	ЗаполнитьЗначенияСвойств(СтрокаРезультата, СтруктураРезультата);
	ОбновитьТекстыЗапросаИОтвета("Метаданные");
	
КонецПроцедуры

#КонецОбласти

#Область ОтправкаЗапросовНаПолучениеДанных

&НаСервере
Процедура ПолучитьДанныеРегистрацииНаСервере()
	
	ОчиститьТекстыЗапросовИОтветов("ДанныеРегистрации");
	ИдентификаторСообщенияДанныеРегистрации = Строка(Новый УникальныйИдентификатор);
	ТекстОшибки = "";
	ОтправитьЗапросНаПолучениеДанныхРегистрации(ИдентификаторРЭМДДанныеРегистрации, ИдентификаторСообщенияДанныеРегистрации, ТекстОшибки);
	Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "ДанныеРегистрации"))[0].Статус = ТекстОшибки;
	Статус = ТекстОшибки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтправитьЗапросНаПолучениеДанныхРегистрации(ИдентификаторРЭМД, ИдентификаторСообщенияДанныеРегистрации, ТекстОшибки)
	
	Если Не ЗначениеЗаполнено(ИдентификаторРЭМД) Тогда
		ТекстОшибки = НСтр("ru='Не заполнен идентификатор документа.'");
	КонецЕсли;
	
	Попытка
		ИнтеграцияЕГИСЗ_РЭМД.ПолучитьДанныеОДокументеИзРЭМД(ИдентификаторРЭМД, ИдентификаторСообщенияДанныеРегистрации);
	Исключение
		ТекстОшибки = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьМетаописаниеНаСервере()
	
	ОчиститьТекстыЗапросовИОтветов("Метаданные");
	ИдентификаторСообщенияМетаданные = Строка(Новый УникальныйИдентификатор);
	ТекстОшибки = "";
	ОтправитьЗапросНаПолучениеМетаданных(ИдентификаторРЭМДМетаданные, ИдентификаторСообщенияМетаданные, ТекстОшибки);
	Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "Метаданные"))[0].Статус = ТекстОшибки;
	Статус = ТекстОшибки;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьТекстыЗапросовИОтветов(ТипЗапроса)
	
	СтрокаРезультатов = Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", ТипЗапроса))[0];
	СтрокаРезультатов.ТекстЗапроса = "";
	СтрокаРезультатов.ТекстОтвета = "";
	ТекстЗапроса = "";
	ТекстОтвета = "";
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтправитьЗапросНаПолучениеМетаданных(ИдентификаторРЭМД, ИдентификаторСообщенияМетаданные, ТекстОшибки)
	
	Если Не ЗначениеЗаполнено(ИдентификаторРЭМД) Тогда
		ТекстОшибки = НСтр("ru='Не заполнен идентификатор документа.'");
	КонецЕсли;
	
	Ответ = ИнтеграцияЕГИСЗ_РЭМД.ПолучитьМетаданныеДокументаИзРЭМД(ИдентификаторРЭМД, "", ИдентификаторСообщенияМетаданные);
	
	Если ТипЗнч(Ответ) = Тип("Строка") Тогда
		ТекстОшибки = Ответ;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДокументНаСервере()
	
	ОчиститьТекстыЗапросовИОтветов("ЗапросДокумента");
	ИдентификаторСообщенияЗапросДокумента = Строка(Новый УникальныйИдентификатор);
	Ответ = ИнтеграцияЕГИСЗ_РЭМД.ЗапроситьДокументИзРЭМД(ИдентификаторРЭМДЗапросДокумента,, ИдентификаторСообщенияЗапросДокумента);
	ТекстОшибки = "";
	Если Ответ = Неопределено Тогда
		ТекстОшибки = НСтр("ru='Ошибка при отправке заявки на получение документа из РЭМД.'");
	КонецЕсли;
	Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", "ЗапросДокумента"))[0].Статус = ТекстОшибки;
	Статус = ТекстОшибки;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбновитьТекстыЗапросаИОтвета(ТипЗапроса)
	
	СтрокаРезультата = Результаты.НайтиСтроки(Новый Структура("ТипЗапроса", ТипЗапроса))[0];
	ТекстЗапроса.УстановитьТекст(СтрокаРезультата.ТекстЗапроса);
	ТекстОтвета.УстановитьТекст(СтрокаРезультата.ТекстОтвета);
	Статус = СтрокаРезультата.Статус;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуРезультата(ТипЗапроса)
	
	НоваяСтрока = Результаты.Добавить();
	НоваяСтрока.ТипЗапроса = ТипЗапроса;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьЛогиПоСообщению(ИдентификаторОтправленногоСообщения, СтруктураРезультата, ТипЗапроса, ТипОтвета = "")
	
	АрхивЛогов = ИнтеграцияЕГИСЗСерверПовтИсп.ПолучитьПутьКАрхивуЛогов();
	
	ИмяФайлаЛогов = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(АрхивЛогов, ИдентификаторОтправленногоСообщения + ".zip");
	ФайлЛогов = Новый Файл(ИмяФайлаЛогов);
	Если Не ФайлЛогов.Существует() Тогда
		СтруктураРезультата.Статус = СтрШаблон(НСтр("ru='Архив логов по сообщению не найден: %1'"), ИмяФайлаЛогов);
		Возврат;
	КонецЕсли;
	
	Попытка
		ВременныйКаталогСообщений = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов(), Новый УникальныйИдентификатор());
		СоздатьКаталог(ВременныйКаталогСообщений);
		
		ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяФайлаЛогов, ВременныйКаталогСообщений);
		
		ФайлыЗапросов = НайтиФайлы(ВременныйКаталогСообщений, "*.xml");
		
		ПоследнийФайлЗапроса = "";
		ДатаФайлаЗапроса = Дата(1,1,1);
		
		ПоследнийФайлОтвета = "";
		ДатаФайлаОтвета = Дата(1,1,1);
		
		Для Каждого ФайлЗапроса Из ФайлыЗапросов Цикл
			
			ИмяФайла = ФайлЗапроса.ИмяБезРасширения;
			ТипСообщения = Нрег(СокрЛП(СтрЗаменить(ИмяФайла, Лев(ИмяФайла, 26), "")));
			ДатаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьДатуИзСтроки(Лев(ИмяФайла, 19));
			
			Если СтрНайти(ТипСообщения, ТипЗапроса) > 0 И ДатаСообщения > ДатаФайлаЗапроса Тогда
				ПоследнийФайлЗапроса = ФайлЗапроса.ПолноеИмя;
			ИначеЕсли ЗначениеЗаполнено(ТипОтвета) И СтрНайти(ТипСообщения, ТипОтвета) > 0 И ДатаСообщения > ДатаФайлаОтвета Тогда
				ПоследнийФайлОтвета = ФайлЗапроса.ПолноеИмя;
			КонецЕсли;
		КонецЦикла;
		
		СтруктураРезультата.ТекстЗапроса = ПолучитьТекстФайлаСообщения(ПоследнийФайлЗапроса);
		СтруктураРезультата.ТекстОтвета = ПолучитьТекстФайлаСообщения(ПоследнийФайлОтвета);
		
	Исключение
		СтруктураРезультата.Статус = СтрШаблон(НСтр("ru='Архив логов по сообщению не найден: %1'"), ИмяФайлаЛогов);
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстФайлаСообщения(ФайлСообщения)
	
	Если ЗначениеЗаполнено(ФайлСообщения) Тогда
		ТекстСообшения = Новый ЧтениеТекста;
		ТекстСообшения.Открыть(ФайлСообщения);              
		Возврат ТекстСообшения.Прочитать();
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти