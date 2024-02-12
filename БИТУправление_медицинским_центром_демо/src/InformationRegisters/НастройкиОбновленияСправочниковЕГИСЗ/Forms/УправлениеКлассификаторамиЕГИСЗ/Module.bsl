#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьДоступностьЭлементов();
	ОбновитьТаблицуСправочников();
	ЗаполнитьКлассификаторыТребующиеОчисткиВерсии();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	Для Каждого СтрокаКлассификатора Из СписокКлассификаторов Цикл
		МенеджерЗаписи = РегистрыСведений.НастройкиОбновленияСправочниковЕГИСЗ.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Классификатор			 = СтрокаКлассификатора.OID;
		МенеджерЗаписи.ДатаПоследнегоОбновления	 = СтрокаКлассификатора.Дата;
		МенеджерЗаписи.Версия					 = СтрокаКлассификатора.Версия;
		МенеджерЗаписи.ДатаВерсии				 = СтрокаКлассификатора.ДатаВерсии;
		МенеджерЗаписи.РежимОбновления			 = СтрокаКлассификатора.РежимОбновления;
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьТаблицуСправочников();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегЗаданиеОбновления(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор", ПолучитьИдентификаторРегЗадания());
	ПараметрыФормы.Вставить("Действие",		 "Изменить");
	
	ОткрытьФорму("Обработка.РегламентныеИФоновыеЗадания.Форма.РегламентноеЗадание", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИдентификаторРегЗадания()
	
	Возврат РегламентныеЗадания.НайтиПредопределенное("ИнтеграцияЕГИСЗОбновлениеСправочников").УникальныйИдентификатор;
	
КонецФункции

&НаКлиенте
Процедура ОчиститьВерсию(Команда)
	
	Для Каждого ИдентификаторСтроки Из Элементы.СписокКлассификаторов.ВыделенныеСтроки Цикл
		ТекущаяСтрока = СписокКлассификаторов.НайтиПоИдентификатору(ИдентификаторСтроки);
		ОчиститьВерсиюСтроки(ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьАктуальность(Команда)
	
	Состояние("Анализ версий классификторов ФР НСИ ЕГИСЗ");
	ПолучитьТаблДокументОВерсиях().Показать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКлассификатор(Команда)
	
	ОбновитьТаблицу = Ложь;
	Для Каждого ИдентификаторСтроки Из Элементы.СписокКлассификаторов.ВыделенныеСтроки Цикл
		
		ВыделеннаяСтрока = СписокКлассификаторов.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ВыделеннаяСтрока.РежимОбновления = ПредопределенноеЗначение("Перечисление.РежимыАвтоОбновленияСправочниковЕГИСЗ.Выключено") Тогда
			ПоказатьПредупреждение(,"Для классификатора " + ВыделеннаяСтрока.OID +  " не включено обновление из ФР НСИ ЕГИСЗ." + Символы.ПС + "Включите обновление для возможности загрузки из этой формы", 60);
		Иначе
			Если Модифицированность Тогда
				ЗаписатьНаСервере();
			КонецЕсли;
			
			ИнтеграцияЕГИСЗВызовСервера.ОбновитьСправочник(ВыделеннаяСтрока.OID);
			ОбновитьТаблицу = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбновитьТаблицу Тогда
		ОбновитьТаблицуСправочников();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОбновление(Команда)
	
	Если Модифицированность Тогда
		ПоказатьПредупреждение(,"Изменения настроек не сохранены");
		Возврат
	КонецЕсли;
	
	Ответ = Вопрос("Обновить все автоматически обновляемые классификаторы?", РежимДиалогаВопрос.ОКОтмена, 60);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Состояние("Обновление классификаторов");
		ЗапуститьФоновоеОбновление();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСхемуРЭМД(Команда)
	
	РежимыЗагрузкиПоУмолчаниюСервер(1);
	ОбновитьТаблицуСправочников();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСхемуБезРЭМД(Команда)
	
	РежимыЗагрузкиПоУмолчаниюСервер(0);
	ОбновитьТаблицуСправочников();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокКлассификаторовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.СписокКлассификаторов.ТекущийЭлемент.ТолькоПросмотр Тогда
	
		ПараметрыСправочника = ИнтеграцияЕГИСЗСерверПовтИсп.ПолучитьПараметрыСправочникаЕГИСЗ(Элементы.СписокКлассификаторов.ТекущиеДанные.OID);
		
		ИмяФормыСписка = "Справочник." + ПараметрыСправочника.Наименование + ".ФормаСписка";
		
		Если ПараметрыСправочника.Свойство("ВидКлассификатора") Тогда
			ОткрытьФорму(ИмяФормыСписка, Новый Структура("ВидКлассификатора", ПараметрыСправочника.ВидКлассификатора),,ПараметрыСправочника.ВидКлассификатора);
		Иначе
			ОткрытьФорму(ИмяФормыСписка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКлассификаторовРежимОбновленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элемент.Родитель.ТекущиеДанные;
	Элемент.СписокВыбора.Очистить();
	Для Каждого РежимЗагрузки Из ТекДанные.ВозможныеРежимыЗагрузки Цикл
		Элемент.СписокВыбора.Добавить(РежимЗагрузки.Значение, Строка(РежимЗагрузки.Значение));
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКлассификаторовРежимОбновленияПриИзменении(Элемент)
	
	ТекДанные = Элемент.Родитель.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекДанные.РежимОбновления)
		И ТекДанные.ВозможныеРежимыЗагрузки.Количество() = 1
	Тогда
		ТекДанные.РежимОбновления = ТекДанные.ВозможныеРежимыЗагрузки[0].Значение;
	КонецЕсли;
	ПроверитьНеобходимостьОчисткиВерсии(ТекДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьТаблицуСправочников()
	
	СписокКлассификаторов.Очистить();
	СписокСправочников = ИнтеграцияЕГИСЗСерверПовтИсп.ПолучитьТаблицуСправочниковЕГИСЗ();
	Для Каждого ПараметрыСправочника Из СписокСправочников Цикл
		
		НоваяСтрока = СписокКлассификаторов.Добавить();
		НоваяСтрока.Имя = ПараметрыСправочника.Представление;
		НоваяСтрока.OID = ПараметрыСправочника.oid;
		МенеджерЗаписи = РегистрыСведений.НастройкиОбновленияСправочниковЕГИСЗ.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Классификатор = ПараметрыСправочника.oid;
		МенеджерЗаписи.Прочитать();
		НоваяСтрока.Версия = МенеджерЗаписи.Версия;
		НоваяСтрока.Дата = МенеджерЗаписи.ДатаПоследнегоОбновления;
		НоваяСтрока.РежимОбновления = МенеджерЗаписи.РежимОбновления;
		НоваяСтрока.ДатаВерсии = МенеджерЗаписи.ДатаВерсии;
		НоваяСтрока.ВозможныеРежимыЗагрузки.ЗагрузитьЗначения(ПараметрыСправочника.РежимыЗагрузки);
		
		НоваяСтрока.ВидКлассификатора = ПараметрыСправочника.ВидКлассификатора;
		
		Если Не ЗначениеЗаполнено(НоваяСтрока.РежимОбновления) Тогда
			НоваяСтрока.РежимОбновления = Перечисления.РежимыАвтоОбновленияСправочниковЕГИСЗ.Выключено;
		КонецЕсли;
		
	КонецЦикла;
	
	СписокКлассификаторов.Сортировать("Имя");
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблДокументОВерсиях()
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	ТаблДокумент = Новый ТабличныйДокумент();
	ТаблДокумент.ОтображатьСетку = Ложь;
	ТаблДокумент.ОтображатьЗаголовки = Ложь;
	
	Область = ТаблДокумент.Область(1,1);
	Область.Текст = "Справочник";
	Область.Шрифт = Новый Шрифт(,,Истина);
	Область.ШиринаКолонки = 50;
	
	Область = ТаблДокумент.Область(1,2);
	Область.Текст = "Текущая версия";
	Область.Шрифт = Новый Шрифт(,,Истина);
	Область.ШиринаКолонки = 17;
	Область.ГраницаСлева = Линия;
	Область.ГраницаСправа = Линия;
	
	Область = ТаблДокумент.Область(1,3);
	Область.Текст = "Актуальная версия";
	Область.Шрифт = Новый Шрифт(,,Истина);
	Область.ШиринаКолонки = 17;
	
	Область = ТаблДокумент.Область(1,4);
	Область.Текст = "Автообновление";
	Область.Шрифт = Новый Шрифт(,,Истина);
	Область.ШиринаКолонки = 17;
	
	ЗагружатьВерсии = Истина;
	
	Сч = 1;
	Для Каждого СтрокаКлассификатора Из СписокКлассификаторов Цикл
		
		Если ЗагружатьВерсии Тогда
			Версии = ЗагрузкаКлассификаторовНСИЕГИСЗ.ПолучитьВсеВерсииКлассификатора(СтрокаКлассификатора.OID);
		КонецЕсли;
		
		Если Версии = Неопределено Или Версии.Количество() = 0 Тогда
			ПоследняяВерсия = "Неопределено";
			ДатаВерсии = "Неопределено";
			ЗагружатьВерсии = (Версии <> Неопределено);
		Иначе
			ПоследняяВерсия = Формат(Версии[Версии.Количество()-1].Версия,"ДФ=dd.MM.yyyy");
			ДатаВерсии = Формат(Версии[Версии.Количество()-1].ДатаОбновления,"ДФ=dd.MM.yyyy");
		КонецЕсли;
		
		ОбластьИмя = ТаблДокумент.Область(1+Сч,1);
		ОбластьИмя.Текст = СтрокаКлассификатора.Имя;
		ОбластьИмя.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		Если ЗначениеЗаполнено(СтрокаКлассификатора.Версия) Тогда
			ТаблДокумент.Область(1+Сч,2).Текст = СтрокаКлассификатора.Версия + " от " + Формат(СтрокаКлассификатора.ДатаВерсии,"ДФ=dd.MM.yyyy");
		Иначе
			ТаблДокумент.Область(1+Сч,2).Текст = "";
		КонецЕсли; 
		
		ТаблДокумент.Область(1+Сч,3).Текст = ПоследняяВерсия + " от " + ДатаВерсии;
		ТаблДокумент.Область(1+Сч,4).Текст = СтрокаКлассификатора.РежимОбновления;
		
		Если СтрокаКлассификатора.Версия = ПоследняяВерсия Тогда
			ТаблДокумент.Область(1+Сч,1,1+Сч,3).ЦветФона = WebЦвета.Роса;
		Иначе
			ТаблДокумент.Область(1+Сч,1,1+Сч,3).ЦветФона = WebЦвета.ТусклоРозовый;
		КонецЕсли;
		
		ТаблДокумент.Область(1+Сч,1,1+Сч,4).Обвести(Линия, Линия, Линия, Линия);
		ТаблДокумент.Область(1+Сч,2,1+Сч,2).Обвести(Линия, Линия, Линия, Линия);
		
		Сч = Сч + 1;
	КонецЦикла;
	
	Возврат ТаблДокумент;
	
КонецФункции

&НаСервере
Процедура ЗапуститьФоновоеОбновление()
	
	РегламентныеЗаданияСлужебный.ВыполнитьРегламентноеЗаданиеВручную(РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ИнтеграцияЕГИСЗОбновлениеСправочников));
	
КонецПроцедуры

&НаСервере
Процедура РежимыЗагрузкиПоУмолчаниюСервер(Схема)
	
	РегистрыСведений.НастройкиОбновленияСправочниковЕГИСЗ.ПервоначальноеЗаполнение(Схема);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	Если ДопСерверныеФункцииПовтИсп.ЕстьПравоДоступа("Изменение", "РегистрСведений.НастройкиОбновленияСправочниковЕГИСЗ") Тогда
		Элементы.ФормаЗакрыть.Видимость = Ложь;
	Иначе
		Элементы.ФормаКомандыИзменения.Доступность = Ложь;
		Элементы.ПодменюСхемы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНеобходимостьОчисткиВерсии(ТекДанные)
	
	Если КлассификаторыТребующиеОчисткиВерсииПриВыключенииОбновления.НайтиПоЗначению(ТекДанные.OID) <> Неопределено
		И ТекДанные.РежимОбновления = ПредопределенноеЗначение("Перечисление.РежимыАвтоОбновленияСправочниковЕГИСЗ.Выключено")
	Тогда
		ОчиститьВерсиюСтроки(ТекДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКлассификаторыТребующиеОчисткиВерсии()
	
	КлассификаторыТребующиеОчисткиВерсии = Новый Массив;
	КлассификаторыТребующиеОчисткиВерсии.Добавить(Справочники.Диагнозы.ПолучитьOIDСправочника());
	КлассификаторыТребующиеОчисткиВерсии.Добавить(Справочники.НоменклатураМедицинскихУслуг.ПолучитьOIDСправочника());
	КлассификаторыТребующиеОчисткиВерсииПриВыключенииОбновления.ЗагрузитьЗначения(КлассификаторыТребующиеОчисткиВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВерсиюСтроки(СтрокаКлассификатора)
	
	СтрокаКлассификатора.Версия = "";
	СтрокаКлассификатора.Дата = Дата(1,1,1);
	СтрокаКлассификатора.ДатаВерсии = Дата(1,1,1);
	
КонецПроцедуры

#КонецОбласти