#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ВидОперации = Перечисления.ВидыОперацийИзмененияСоставаСтрахуемых.ДобавлениеВСписок;
	КонецЕсли;
	УстановитьПодменюВыбораТипаДокумента();
	Заголовок = Объект.ВидОперации;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ДействияФормыДействиеУстановитьОперацию(Команда)
	Если Команда <> Неопределено Тогда
		ДействияФормыДействиеУстановитьОперациюСервер(Команда.Имя);
	КонецЕсли;	
КонецПроцедуры
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура УстановитьПодменюВыбораТипаДокумента()
	
	МассивТипов = Перечисления.ВидыОперацийИзмененияСоставаСтрахуемых.ПустаяСсылка().Метаданные().ЗначенияПеречисления;
	РаботаСДиалогамиСервер.УстановитьПодменюОперации(МассивТипов, ЭтаФорма);
				
КонецПроцедуры

&НаСервере
Процедура ДействияФормыДействиеУстановитьОперациюСервер(КомандаИмя)
	
	Если ЗначениеЗаполнено(КомандаИмя) Тогда // найти новое значение вида операции
		Объект.ВидОперации = Перечисления.ВидыОперацийИзмененияСоставаСтрахуемых[КомандаИмя];
	КонецЕсли;

	Заголовок = Объект.ВидОперации;
КонецПроцедуры

&НаКлиенте
Процедура СтрахуемыеКлиентПриИзменении(Элемент)
	Клиент = Элементы.Страхуемые.ТекущиеДанные.Клиент;
	Если ЗначениеЗаполнено(Объект.ВидПолиса) И ЗначениеЗаполнено(Клиент) Тогда
		СтруктураВозврата = НайтиИЗаполнитьПоТекущемуВидуПолиса(Клиент, Объект.ВидПолиса);
		ЗаполнитьЗначенияСвойств(Элементы.Страхуемые.ТекущиеДанные,СтруктураВозврата);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиИЗаполнитьПоТекущемуВидуПолиса(Клиент, ВидПолиса)
	
	СтруктураВозврата = Новый Структура("Полис,НомерПолиса,СерияПолиса");
	Если Клиент.умцОсновнойСтраховойПолис.ВидПолиса = ВидПолиса Тогда
		
		СтруктураВозврата.Полис = Клиент.умцОсновнойСтраховойПолис;
		СтруктураВозврата.НомерПолиса = Клиент.умцОсновнойСтраховойПолис.Номер;
		СтруктураВозврата.СерияПолиса = Клиент.умцОсновнойСтраховойПолис.Серия;
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 2
		               |	СтраховыеПолисы.Ссылка,
		               |	СтраховыеПолисы.Номер,
		               |	СтраховыеПолисы.Серия
		               |ИЗ
		               |	Справочник.СтраховыеПолисы КАК СтраховыеПолисы
		               |ГДЕ
		               |	СтраховыеПолисы.Владелец = &Владелец
		               |	И СтраховыеПолисы.ВидПолиса = &ВидПолиса
		               |	И НЕ СтраховыеПолисы.НеДействителен
		               |	И НЕ СтраховыеПолисы.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("Владелец", Клиент);
		Запрос.УстановитьПараметр("ВидПолиса", ВидПолиса);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выгрузить();
		
		Если Выборка.Количество() = 1 Тогда
			
			СтруктураВозврата.Полис = Выборка[0].Ссылка;					
			СтруктураВозврата.НомерПолиса = Выборка[0].Номер;
			СтруктураВозврата.СерияПолиса = Выборка[0].Серия;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураВозврата;
КонецФункции

&НаСервереБезКонтекста
Функция НайтиНомерИСериюПоПолису(Полис)
	
	СтруктураВозврата = Новый Структура("НомерПолиса,СерияПолиса,Клиент");
	
	СтруктураВозврата.СерияПолиса = Полис.Серия;
	СтруктураВозврата.НомерПолиса = Полис.Номер;
	СтруктураВозврата.Клиент	  = Полис.Владелец;
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура СтрахуемыеПолисПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Страхуемые.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Полис) Тогда
		СтруктураВозврата = НайтиНомерИСериюПоПолису(ТекущиеДанные.Полис);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные,СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрахуемыеПолисНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.ВидПолиса) Тогда
		СтандартнаяОбработка = Ложь;
		Предупреждение("Вид полиса не указан", 30);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Страхуемые.ТекущиеДанные;
	
	Отбор = Новый Массив;
	Отбор.Добавить(Новый ПараметрВыбора("Отбор.ВидПолиса", Объект.ВидПолиса));
	Если ЗначениеЗаполнено(ТекущиеДанные.Клиент) Тогда
		Отбор.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ТекущиеДанные.Клиент));
	КонецЕсли;
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(Отбор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПолисаПриИзменении(Элемент)
	
	Спросить = Ложь;
	Для каждого Строка из Объект.Страхуемые Цикл
		Если ЗначениеЗаполнено(Строка.Полис) Тогда
			Спросить = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если Спросить Тогда
		Если Вопрос("Имеются заполненые полисы, очистить полисы?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			Для каждого Строка из Объект.Страхуемые Цикл
					Строка.Полис = ПредопределенноеЗначение("Справочник.СтраховыеПолисы.ПустаяСсылка");
				КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
