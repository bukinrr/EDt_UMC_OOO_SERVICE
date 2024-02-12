#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Попытка
		Если Параметры.Свойство("СозданиеНового") Тогда
			СозданиеНового = Истина;
		Иначе
			РедактированиеНесохраненного = Параметры.Свойство("РедактированиеНесохраненного");
			ИндексСтроки = Параметры.ИндексСтроки;
			Клиент = Параметры.Клиент;
			Профессия = Параметры.Профессия;
			ТипМедосмотра = Параметры.ТипМедосмотра;
			ФИОКлиента = Параметры.ФИОКлиента;
			ЦехУчасток = Параметры.ЦехУчасток;
			СПМОСсылка = Параметры.СПМОСсылка;
		КонецЕсли;
	Исключение
		Отказ = Истина;
		ВызватьИсключение "Неверно заданы параметры формы";
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолеФормыПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если Элемент.Имя = "Клиент" Тогда
		ФИОКлиента = ОбщегоНазначения.ФИОФизЛица(Клиент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофессияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	МедосмотрыКлиент.ОбработкаВыбораПрофессии(ЭтаФорма, СтандартнаяОбработка, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПрофессияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	МедосмотрыСервер.ПрофессияОкончаниеВводаТекстаНаСервере(Текст, СтандартнаяОбработка, ДанныеВыбора);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если ЭтаФорма.Модифицированность Тогда
		ВозвращаемыеДанные = Новый Структура;
		ВозвращаемыеДанные.Вставить("Клиент", Клиент);
		ВозвращаемыеДанные.Вставить("Профессия", Профессия);
		ВозвращаемыеДанные.Вставить("ТипМедосмотра", ТипМедосмотра);
		ВозвращаемыеДанные.Вставить("ФИОКлиента", ФИОКлиента);
		ВозвращаемыеДанные.Вставить("ЦехУчасток", ЦехУчасток);
		Если СозданиеНового Или РедактированиеНесохраненного Тогда
			Закрыть(ВозвращаемыеДанные);
		Иначе
			ВозвращаемыеДанные.Вставить("ИндексСтроки", ИндексСтроки);
			ВозвращаемыеДанные.Вставить("СПМОСсылка", СПМОСсылка);
			ТекстОшибки = "";
			СписокИзмененыхПМО = Новый Массив;
			ЗаписатьНовыеДанныеПМОИСПМО(ВозвращаемыеДанные, ТекстОшибки, СписокИзмененыхПМО);
			Если ЗначениеЗаполнено(ТекстОшибки) Тогда
				ПоказатьПредупреждение(, ТекстОшибки);
			Иначе
				Оповестить("СписокНаПрохождениеИзменен", СПМОСсылка); 
				Для Каждого Эл Из СписокИзмененыхПМО Цикл
					Оповестить("ПрохождениеМедосмотраИзменено", Эл);
				КонецЦикла;
				Закрыть();
			КонецЕсли;
		КонецЕсли;
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗаписатьНовыеДанныеПМОИСПМО(ДанныеДляЗаписи, ТекстОшибки, СписокИзмененыхПМО)
	
	НачатьТранзакцию();
	
	ТекущаяСтрока = ДанныеДляЗаписи.СПМОСсылка.Клиенты.Получить(ДанныеДляЗаписи.ИндексСтроки);
	КлиентДоИзменения = ТекущаяСтрока.Клиент;
	ПрофессияДоИзменения = ТекущаяСтрока.Профессия;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПрохождениеМедосмотра.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ПрохождениеМедосмотра КАК ПрохождениеМедосмотра
		|ГДЕ
		|	ПрохождениеМедосмотра.СписокНаПрохождениеМедосмотра = &СписокНаПрохождениеМедосмотра
		|	И ПрохождениеМедосмотра.Клиент = &Клиент
		|	И ПрохождениеМедосмотра.ПометкаУдаления = ЛОЖЬ
		|	И ПрохождениеМедосмотра.Профессия = &Профессия";
	
	Запрос.УстановитьПараметр("Клиент", КлиентДоИзменения);
	Запрос.УстановитьПараметр("Профессия", ПрофессияДоИзменения); 
	Запрос.УстановитьПараметр("СписокНаПрохождениеМедосмотра", ДанныеДляЗаписи.СПМОСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Ссылка.ПодписанЭП Тогда
			ОтменитьТранзакцию();
			ТекстОшибки = "У данного клиента существуют подписанные документы прохождения медосмотра, изменение клиента не возможно!";
			Возврат;
		КонецЕсли;
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(ДокументОбъект, ДанныеДляЗаписи);
		ДокументОбъект.Записать();
		СписокИзмененыхПМО.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	СПМООбъект = ДанныеДляЗаписи.СПМОСсылка.ПолучитьОбъект();;
	ИзменяемаяСтрока = СПМООбъект.Клиенты.Получить(ДанныеДляЗаписи.ИндексСтроки);
	ЗаполнитьЗначенияСвойств(ИзменяемаяСтрока, ДанныеДляЗаписи);
	МедосмотрыКлиентСервер.ЗаполнитьДанныеПоЧислуРаботниковПодлежащихПереодМедосмотру(СПМООбъект);
	СПМООбъект.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

