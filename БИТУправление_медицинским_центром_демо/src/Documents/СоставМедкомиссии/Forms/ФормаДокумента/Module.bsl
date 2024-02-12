#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормамиСервер.ФормаДокументаПриОткрытииСервер(ЭтаФорма, Ложь);
	
	Если Объект.Ссылка.Пустая()
		И Объект.Состав.Количество() = 0
	Тогда
		Для Каждого РольИмя Из Метаданные.Справочники.РолиЧленовКомиссии.ПолучитьИменаПредопределенных() Цикл
			Если РольИмя <> "ЧленКомиссии" Тогда
				Объект.Состав.Добавить().Роль = Справочники.РолиЧленовКомиссии[РольИмя];
			КонецЕсли;
	    КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Для Каждого эл Из Объект.Состав Цикл 
		СтруктураПоиска = Новый Структура("Роль, Специализация");
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, эл);
		
		Если Объект.Состав.НайтиСтроки(СтруктураПоиска).Количество() > 1 Тогда
			ТекстПедупреждения = НСтр("ru = 'Сотрудник с такой ролью и специализацией уже добавлен в состав комиссии!'");
			Предупреждение(ТекстПедупреждения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСФормамиСервер.ВывестиЗаголовокФормыДокумента(ТекущийОбъект,,ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура СоставПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекДанные = Элементы.Состав.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		Если ТекДанные.НомерСтроки = 1 Тогда
			ТекДанные.Роль = ПредопределенноеЗначение("Справочник.РолиЧленовКомиссии.Председатель");
		Иначе
			ТекДанные.Роль = ПредопределенноеЗначение("Справочник.РолиЧленовКомиссии.ЧленКомиссии");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставСотрудникПриИзменении(Элемент)
	
	ТекДанные = Элементы.Состав.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.Сотрудник) Тогда
		
		ТекДанные.Специализация = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекДанные.Сотрудник, "Специализация");
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Подключаемый_КнопкаФилиалПриНажатии(Команда)
	РаботаСДиалогамиКлиент.ДиалогКнопкаФилиалПриНажатии(ЭтаФорма);
КонецПроцедуры


#КонецОбласти