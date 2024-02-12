#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая()
		И Объект.Инициатор.Пустая()
	Тогда 
		Объект.Инициатор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
КонецПроцедуры

 &НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда
		Объект.СрокИсполнения = НачалоМинуты(ТекущаяДата());
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.СрокОповещения) Тогда
		Объект.СрокОповещения = НачалоМинуты(ТекущаяДата());
	КонецЕсли;
    ОповещениеПриИзменении(ЭтаФорма.Элементы.Оповещение);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗадачаПриИзменении", Новый Структура("Исполнитель, Задача", Объект.Исполнитель, Объект.Ссылка));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Функция ВыборДатыВремениИзВыпадающегоСписка(Элемент, СтандартнаяОбработка, ОбъектСписка)
	
	СтандартнаяОбработка = ЛОЖЬ;
	СписокВремен = Новый СписокЗначений;
	
	Если НЕ ЗначениеЗаполнено(ОбъектСписка) Тогда
		ОбъектСписка = НачалоМинуты(ТекущаяДата());
	КонецЕсли;
	
	Если ДеньГода(ОбъектСписка) = ДеньГода(ТекущаяДата()) Тогда	
		Если Минута(ТекущаяДата()) > 30 Тогда
			ВремяСписка = НачалоМинуты(КонецЧаса(ТекущаяДата()) + 60);
		Иначе
			ВремяСписка = НачалоМинуты(КонецЧаса(ТекущаяДата()) - 29*60);
		КонецЕсли;
	Иначе
		ВремяСписка = НачалоДня(ОбъектСписка);
	КонецЕсли;
	
	Пока НачалоЧаса(ВремяСписка) < КонецДня(ОбъектСписка) Цикл	
		СписокВремен.Добавить(ВремяСписка, Формат(ВремяСписка,"ДФ='дд.ММ.гггг ЧЧ:мм'"));
		ВремяСписка = ВремяСписка + 30*60;
	КонецЦикла;
	
	ВыбранноеВремя = ЭтаФорма.ВыбратьИзСписка(СписокВремен, Элемент);
	Возврат ВыбранноеВремя;
	
КонецФункции

&НаКлиенте
Процедура СрокИсполненияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ВыбранноеВремя = ВыборДатыВремениИзВыпадающегоСписка(Элемент, СтандартнаяОбработка, Объект.СрокИсполнения);
	Если ВыбранноеВремя <> Неопределено Тогда
		Объект.СрокИсполнения = ВыбранноеВремя.Значение;
		СрокИсполнения = ВыбранноеВремя.Значение;
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СрокОповещенияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ВыбранноеВремя = ВыборДатыВремениИзВыпадающегоСписка(Элемент, СтандартнаяОбработка, Объект.СрокОповещения);
	Если ВыбранноеВремя <> Неопределено Тогда
		Объект.СрокОповещения = ВыбранноеВремя.Значение;
		СрокОповещения = ВыбранноеВремя.Значение;
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПриИзменении(Элемент)
	ЭтаФорма.Элементы.СрокОповещения.Доступность = Объект.Оповещение;
КонецПроцедуры

&НаКлиенте
Процедура ВидЗадачиНапоминанияПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Объект.ВидЗадачиНапоминания;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
