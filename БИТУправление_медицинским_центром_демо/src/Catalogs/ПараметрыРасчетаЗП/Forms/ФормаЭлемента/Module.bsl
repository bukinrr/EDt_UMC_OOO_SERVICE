#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сотрудник		= РаботаСФормамиСервер.ПолучитьНастройкуФормы("ПараметрыРасчетаЗППроверкаАлгоритма", "Сотрудник");
	НачалоПериода	= РаботаСФормамиСервер.ПолучитьНастройкуФормы("ПараметрыРасчетаЗППроверкаАлгоритма", "НачалоПериода");
	КонецПериода	= РаботаСФормамиСервер.ПолучитьНастройкуФормы("ПараметрыРасчетаЗППроверкаАлгоритма", "КонецПериода");
	Документ		= РаботаСФормамиСервер.ПолучитьНастройкуФормы("ПараметрыРасчетаЗППроверкаАлгоритма", "Документ");


КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриИзмененииТипПараметра();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	РаботаСФормамиСервер.СохранитьНастройкиФормы(СтруктураПараметровВыполнения(), "ПараметрыРасчетаЗППроверкаАлгоритма"); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьАлгоритм(Команда)
	
	Если РаботаСДиалогамиКлиент.ПроверитьМодифицированностьВФорме(ЭтаФорма) Тогда
		
		ПарамерыВычисления = СтруктураПараметровВыполнения();
		ПроизошлаОшибка = Ложь;
		
		Результат = ВыполнитьВычисление(Объект.Ссылка, ПарамерыВычисления, ПроизошлаОшибка);
		
		Если ПроизошлаОшибка Тогда
			ПоказатьПредупреждение(,НСтр("ru='Произошла ошибка при выполнении алгоритма'"), 30, НСтр("ru='Выполнено с ошибками'"));
		Иначе
			ПоказатьПредупреждение(,Результат, 30, НСтр("ru='Выполнено успешно'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипПараметраПриИзменении(Элемент)
	ПриИзмененииТипПараметра();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииТипПараметра()
	
	Элементы.ГруппаАлгоритмРасчета.Видимость = Объект.ТипПараметра = ПредопределенноеЗначение("Перечисление.ТипыПараметровРасчетаЗарплаты.ПроизвольныйАлгоритм");
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураПараметровВыполнения()
	
	ПарамерыВычисления = Новый Структура;
	ПарамерыВычисления.Вставить("Сотрудник", Сотрудник);
	ПарамерыВычисления.Вставить("НачалоПериода", НачалоПериода);
	ПарамерыВычисления.Вставить("КонецПериода", КонецДня(КонецПериода));
	ПарамерыВычисления.Вставить("Документ", Документ);
	
	Возврат ПарамерыВычисления;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыполнитьВычисление(ПараметрРасчета, ПарамерыВычисления, ПроизошлаОшибка)
	
	Возврат Справочники.ПараметрыРасчетаЗП.ВыполнитьРасчетАлгоритмаПараметраРасчета(ПараметрРасчета, ПарамерыВычисления, ПроизошлаОшибка);
	
КонецФункции

#КонецОбласти
