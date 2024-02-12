#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтактнаяИнформация.Параметры.УстановитьЗначениеПараметра("Объект"		 ,Параметры.Клиент);
	КонтактнаяИнформация.Параметры.УстановитьЗначениеПараметра("ИмяМетаданных","Клиенты");
	
	Элементы.КонтактнаяИнформацияЗаконногоПредставителя.Видимость = Ложь;
	Элементы.ЗаконныйПредставитель.Видимость = Ложь;
	Если ТипЗнч(Параметры.Клиент) = Тип("СправочникСсылка.Клиенты")
		И ЗначениеЗаполнено(Параметры.Клиент.ЗаконныйПредставитель)
	Тогда
		Если ТипЗнч(Параметры.Клиент.ЗаконныйПредставитель) = Тип("СправочникСсылка.Клиенты") Тогда
			
			ЗаконныйПредставитель = Параметры.Клиент.ЗаконныйПредставитель;
			Если ЗначениеЗаполнено(ЗаконныйПредставитель) Тогда
				КонтактнаяИнформацияЗаконногоПредставителя.Параметры.УстановитьЗначениеПараметра("ИмяМетаданных","Клиенты");
				КонтактнаяИнформацияЗаконногоПредставителя.Параметры.УстановитьЗначениеПараметра("Объект", ЗаконныйПредставитель);
				Элементы.КонтактнаяИнформацияЗаконногоПредставителя.Видимость = Истина;
			КонецЕсли;
		Иначе
			Если Параметры.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон
				И Не ПустаяСтрока(Параметры.Клиент.ЗаконныйПредставительТелефон)
			Тогда
				Элементы.ЗаконныйПредставитель.Видимость = Истина;
				Элементы.НомерТелефонаЗаконногоПредставителя.Заголовок = Параметры.Клиент.ЗаконныйПредставительТелефон;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РаботаСФормамиКлиент.УстановитьОтборСписка("Тип",   Параметры.ТипКИ, КонтактнаяИнформация);	
	РаботаСФормамиКлиент.УстановитьОтборСписка("Тип",   Параметры.ТипКИ, КонтактнаяИнформацияЗаконногоПредставителя);	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "КонтактнаяИнформацияИзменение" Тогда
		Элементы.КонтактнаяИнформация.Обновить();
		Если Элементы.КонтактнаяИнформацияЗаконногоПредставителя.Видимость Тогда
			Элементы.КонтактнаяИнформацияЗаконногоПредставителя.Обновить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура КонтактнаяИнформацияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТД = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	Если ТД <> Неопределено Тогда
		Закрыть(ТД.Представление);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияСписокПередНачаломИзменения(Элемент, Отказ)
	
	КонтактнаяИнформацияКлиент.КонтактнаяИнформацияСписокПередНачаломИзменения(Элементы.КонтактнаяИнформация, ЭтаФорма, Параметры.Клиент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	КонтактнаяИнформацияКлиент.СозданиеНовойКИ(Параметры.Клиент);
	Элементы.КонтактнаяИнформация.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияЗаконногоПредставителяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТД = Элементы.КонтактнаяИнформацияЗаконногоПредставителя.ТекущиеДанные;
	Если ТД <> Неопределено Тогда
		Закрыть(ТД.Представление);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияЗаконныйСписокПередНачаломИзменения(Элемент, Отказ)
	
	КонтактнаяИнформацияКлиент.КонтактнаяИнформацияСписокПередНачаломИзменения(Элементы.КонтактнаяИнформацияЗаконногоПредставителя, ЭтаФорма, ЗаконныйПредставитель);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияЗаконныйСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	КонтактнаяИнформацияКлиент.СозданиеНовойКИ(ЗаконныйПредставитель);
	Элементы.КонтактнаяИнформацияЗаконногоПредставителя.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВСписке(Команда)
	
	ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	Если ТекущиеДанные<> Неопределено Тогда
		Закрыть(ТекущиеДанные.Представление);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КИСоздать(Команда)
	КонтактнаяИнформацияСписокПередНачаломДобавления(Неопределено, Неопределено, Неопределено, Неопределено, Неопределено, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура КИИзменить(Команда)
	КонтактнаяИнформацияСписокПередНачаломИзменения(Неопределено,Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВСпискеЗаконный(Команда)
	
	ТекущиеДанные = Элементы.КонтактнаяИнформацияЗаконногоПредставителя.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Представление);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КИСоздатьЗаконный(Команда)
	КонтактнаяИнформацияЗаконныйСписокПередНачаломДобавления(Неопределено, Неопределено, Неопределено, Неопределено, Неопределено, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура КИИзменитьЗаконный(Команда)
	КонтактнаяИнформацияЗаконныйСписокПередНачаломИзменения(Неопределено,Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Элементы.НомерТелефонаЗаконногоПредставителя.Заголовок);
КонецПроцедуры

#КонецОбласти