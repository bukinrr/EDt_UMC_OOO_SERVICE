#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЦветИзменения = ЦветаСтиля.ЦветФонаПодсказки; 
	КомментарииМеняли = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.Клиент) Тогда
		Клиент = Параметры.Клиент;
	КонецЕсли;
					 
	Если ЗначениеЗаполнено(Параметры.Заявка) Тогда
        Заявка = Параметры.Заявка;
		ПримечаниеЗаявки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заявка,"Примечание");
		
		ТекущийЭлемент = Элементы.ПримечаниеЗаявки;
		
		ЭтаФорма.КлючСохраненияПоложенияОкна = "Клиент+Заявка";
	Иначе
		Элементы.ПримечаниеЗаявки.Видимость = Ложь;
		Элементы.Заявка.Видимость = Ложь;
		
		ТекущийЭлемент = Элементы.КраткийКомментарий;
		
		ЭтаФорма.КлючСохраненияПоложенияОкна = "Заявка";
	КонецЕсли;
	
	РеквизитыКлиента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Клиент, "Комментарий, КраткийКомментарий");
	КомментарийКлиента = РеквизитыКлиента.Комментарий;
	КраткийКомментарий = РеквизитыКлиента.КраткийКомментарий;
	
	Если РаботаСКлиентамиПереопределяемый.ЭтоГрупповаяЗаявка(Клиент) Тогда
		Элементы.КраткийКомментарий.Доступность = Ложь;
		Элементы.КомментарийКлиента.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если КомментарииМеняли Тогда
		ИзмененныеОбъекты = ЗаписатьНаСервере();
		Если ИзмененныеОбъекты.КлиентИзменен Тогда
			Оповестить("КлиентИзменен", Клиент);
		КонецЕсли;
		Если ИзмененныеОбъекты.ЗаявкаИзменена Тогда
			Оповестить("ЗаявкаИзменена", Заявка);
		КонецЕсли;
	КонецЕсли; 
	
	ЭтаФорма.Закрыть(КомментарииМеняли);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПриИзмененииКомментарий(Элемент)
	
	КомментарииМеняли = Истина;
	Элемент.ЦветФона = ЦветИзменения;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Заявка) Тогда
		Элементы.ПримечаниеЗаявки.Доступность = Истина;
		ПримечаниеЗаявки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заявка,"Примечание");
	Иначе
		Элементы.ПримечаниеЗаявки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентНажатие(Элемент, СтандартнаяОбработка)
	ПоказатьЗначение(, Клиент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаписатьНаСервере()
	
	ИзмененныеОбъекты = Новый Структура("КлиентИзменен, ЗаявкаИзменена", Ложь, Ложь);
	
	ТекстОшибкиЗаписи = НСтр("ru='Не удалось записать объект: '");
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Клиент, "Комментарий, КраткийКомментарий");
	Если КраткийКомментарий <> Реквизиты.КраткийКомментарий
		Или КомментарийКлиента <> Реквизиты.Комментарий
	Тогда
		ОбъектКлиент = Клиент.ПолучитьОбъект();
		ОбъектКлиент.КраткийКомментарий = КраткийКомментарий;
		ОбъектКлиент.Комментарий = КомментарийКлиента;
		
		Попытка
			ОбъектКлиент.Записать();
			ИзмененныеОбъекты.КлиентИзменен = Истина;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиЗаписи + Строка(Клиент));
		КонецПопытки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Заявка) Тогда
		ПримечаниеСтарое = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заявка, "Примечание");
		Если ПримечаниеЗаявки <> ПримечаниеСтарое Тогда
			
			ОбъектЗаявка = Заявка.ПолучитьОбъект();
			ОбъектЗаявка.Примечание = ПримечаниеЗаявки;
			ОбъектЗаявка.мНеДелатьПроверокПриЗаписи = Истина;
			
			Попытка
				ОбъектЗаявка.Записать();
				ИзмененныеОбъекты.ЗаявкаИзменена = Истина;
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиЗаписи + Строка(Заявка));
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИзмененныеОбъекты;
	
КонецФункции

#КонецОбласти