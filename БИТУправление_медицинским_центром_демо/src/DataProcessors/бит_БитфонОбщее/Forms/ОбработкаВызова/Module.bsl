
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//
	Если СкрыватьКнопкиОбработкиВызова Тогда
		Элементы.ПринятьВызов.Видимость = Ложь;
		Элементы.ОтклонитьВызов.Видимость = Ложь;
	КонецЕсли;
	//
	Если бит_ТелефонияКлиентПереопределяемый.ПроверкаНовыйИнтерфейсТакси() Тогда
		Элементы.ПринятьВызов.Высота = 0;
		Элементы.ОтклонитьВызов.Высота = 0;
		Элементы.ОткрытьКарточкуКлиента.Высота = 0;
	КонецЕсли;
	//
	Элементы.Абонент.Видимость = КонтрагентНайден;
	Элементы.КонтактноеЛицо.Видимость = КонтрагентНайден И ЗначениеЗаполнено(КонтактноеЛицо);
	Элементы.НабранныйНомер.Видимость = ЗначениеЗаполнено(НабранныйНомер);
	//
	Если КонтрагентНайден
			И (ТипЗнч(Абонент) = Тип("СправочникСсылка." + бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтрагентов())) Тогда
		//
		Элементы.ТипАбонента.Видимость = Истина;
		Элементы.ГруппаДокументыАбонента.Видимость = Истина;
		//
		стрТипАбонента = "";
		//
		Если бит_ТелефонияСерверПереопределяемый.ПроверкаКонтрагентПокупатель(Абонент) Тогда
			стрТипАбонента = "Покупатель";
		КонецЕсли;
		//
		Если бит_ТелефонияСерверПереопределяемый.ПроверкаКонтрагентПоставщик(Абонент) Тогда
			Если ЗначениеЗаполнено(стрТипАбонента) Тогда
				стрТипАбонента = стрТипАбонента + ", Поставщик";
			Иначе
				стрТипАбонента = "Поставщик";
			КонецЕсли;
		КонецЕсли;
		//
		Если НЕ ЗначениеЗаполнено(стрТипАбонента) Тогда
			стрТипАбонента = "не задан";
		КонецЕсли;
		//
		ТипАбонента = стрТипАбонента;
		//
	Иначе
		Элементы.ТипАбонента.Видимость = Ложь;
		Элементы.ГруппаДокументыАбонента.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПродажНажатие(Элемент)
	бит_ТелефонияКлиентПереопределяемый.ОткрытьДокументыПродаж(Абонент);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоступленияНажатие(Элемент)
	бит_ТелефонияКлиентПереопределяемый.ОткрытьДокументыПоступления(Абонент);
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыПокупателяНажатие(Элемент)
	бит_ТелефонияКлиентПереопределяемый.ОткрытьЗаказыПокупателя(Абонент);
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыПоставщикуНажатие(Элемент)
	бит_ТелефонияКлиентПереопределяемый.ОткрытьЗаказыПоставщику(Абонент);
КонецПроцедуры

&НаКлиенте
Процедура СчетаНаОплатуПокупателяНажатие(Элемент)
	бит_ТелефонияКлиентПереопределяемый.ОткрытьСчетаНаОплатуПокупателя(Абонент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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
	Если КонтрагентНайден Тогда
		Если ТипЗнч(Абонент) = Тип("Строка") Тогда
			бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение(Абонент);
		Иначе
			форма = Неопределено;
			типКонтакта = ТипЗнч(Абонент);
			парам = Новый Структура("Ключ", Абонент);
			//
			стрИмяСправочникаКонтрагентов = бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтрагентов();
			Если типКонтакта = Тип("СправочникСсылка." + стрИмяСправочникаКонтрагентов) Тогда
				форма = ПолучитьФорму("Справочник." + стрИмяСправочникаКонтрагентов + ".ФормаОбъекта", парам);
			КонецЕсли;
			//
			Если форма <> Неопределено Тогда
				форма.Открыть();
			Иначе
				бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Тип контакта неизвестен");
			КонецЕсли;
		КонецЕсли;
	Иначе
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Номер неизвестен");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
