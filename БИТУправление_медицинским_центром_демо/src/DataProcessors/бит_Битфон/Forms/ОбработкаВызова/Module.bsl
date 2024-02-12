&НаКлиенте
Перем бит_фрмКарточкаКлиента;

&НаКлиенте
Процедура ПринятьВызов(Команда)
	Закрыть("принять");
КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьВызов(Команда)
	Закрыть("отклонить");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуКлиента(Команда)
	Клиент = бит_ТелефонияКлиентПереопределяемый.ОткрытьКарточкуКонтрагента(Абонент, НабранныйНомер);
	Если ЗначениеЗаполнено(Клиент) Тогда
		Абонент = Клиент;
	КонецЕсли;
	НастроитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	НастроитьВидимостьДоступность();
	
	Элементы.КонтактноеЛицо.Видимость = ЗначениеЗаполнено(КонтактноеЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВидимостьДоступность()
	
	АбонентОпределен = (ТипЗнч(Абонент) <> Тип("Строка") И ЗначениеЗаполнено(Абонент));
	Если Не АбонентОпределен Тогда
		Если ПустаяСтрока(Абонент) Тогда
			
			Абонент = "Неизвестный абонент";
				
		КонецЕсли; 	
	КонецЕсли;
	
	Элементы.Абонент.Гиперссылка = АбонентОпределен;
	Элементы.ДнейСПоследнегоПосещения.Гиперссылка = АбонентОпределен;
	Элементы.ГруппаПоследнееПосещение.Видимость = АбонентОпределен;
	
	Если АбонентОпределен Тогда 
		НастройкаВидимостиИнформации();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастройкаВидимостиИнформации()
	
	ДнейСПоследнегоПосещения = "";
	ПоследнееПосещение = Неопределено;
	Если ЗначениеЗаполнено(Абонент) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Продажи.Регистратор КАК ДокументПосещения,
		|	Продажи.Период
		|ИЗ
		|	РегистрНакопления.Продажи КАК Продажи
		|ГДЕ
		|	Продажи.Клиент = &Клиент
		|	И НЕ Продажи.Регистратор ССЫЛКА Документ.КорректировкаРегистров
		|
		|УПОРЯДОЧИТЬ ПО
		|	Продажи.Период УБЫВ";
		Запрос.УстановитьПараметр("Клиент", Абонент);
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			ПоследнееПосещение = Выборка.ДокументПосещения;
			
			ТекДата = ТекущаяДата();
			Если ТекДата > Выборка.Период Тогда
				ЧислоДней = Цел((ТекДата - Выборка.Период) / 86400);
				ДнейСПоследнегоПосещения = ?(ЧислоДней <= 365, ЧислоДней, "Более года");
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если бит_фрмКарточкаКлиента <> Неопределено Тогда
		Попытка
			Если бит_фрмКарточкаКлиента.Открыта() Тогда
				бит_фрмКарточкаКлиента.Закрыть();
			КонецЕсли; 
		Исключение
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОткрытаФормаНовогоКлиентаБИТФОН" Тогда
		бит_фрмКарточкаКлиента = Параметр;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДнейСПоследнегоПосещенияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если АбонентОпределен Тогда 
		РаботаСФормамиКлиент.ОткрытьОтчетКлиента("Продажи", Абонент);
	КонецЕсли;
	
КонецПроцедуры
