
#Область ОбработчикиСобытийЭлементовФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроверитьПулыНомеров();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сдвинуть(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ТекущийНомер = Неопределено; 
	Успех = ВвестиЗначение(ТекущийНомер, НСтр("ru='Введите новый ""Текущий номер"" для выбранной строки: '"), Тип("Число"));
	Если Успех Тогда
		Если ТекущийНомер >= ТекущиеДанные.НачалоДиапазона
			И ТекущийНомер <= ТекущиеДанные.ОкончаниеДиапазона 
		Тогда
			СдвинутьНаСервере(ТекущиеДанные, ТекущийНомер);
			Элементы.Список.Обновить();
		Иначе
			ПоказатьПредупреждение(, НСтр("ru='Введенное число выходит за диапазон номеров'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	УдалитьНаСервере(ТекущиеДанные);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНомера(Команда)
	
	ПараметрыФормы = Новый Структура("Действие","ПолучитьСписокНомеров");
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыОбменаФСС", ЭтотОбъект, "ПолучитьСписокНомеров");
	ОткрытьФорму("Документ.ЛистокНетрудоспособности.Форма.ОбменСФСС",ПараметрыФормы, ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СдвинутьНаСервере(ТекущиеДанные, ТекущийНомер)
	
	МенеджерЗаписи = РегистрыСведений.ПулыНомеровЭЛН.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТекущиеДанные);
	МенеджерЗаписи.ТекущийНомер = ТекущийНомер;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьНаСервере(ТекущиеДанные)
	МенеджерЗаписи = РегистрыСведений.ПулыНомеровЭЛН.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТекущиеДанные);
	МенеджерЗаписи.Удалить();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыОбменаФСС(Результат, ДополнительныеПарамтеры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПулыНомеров()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ПулыНомеровЭЛН.ОГРН КАК ОГРН
	               |ПОМЕСТИТЬ ЗаканчивающиесяПулы
	               |ИЗ
	               |	РегистрСведений.ПулыНомеровЭЛН КАК ПулыНомеровЭЛН
	               |ГДЕ
	               |	(ПулыНомеровЭЛН.Закрыт
	               |			ИЛИ ПулыНомеровЭЛН.ТекущийНомер >= ПулыНомеровЭЛН.НачалоДиапазона + (ПулыНомеровЭЛН.ОкончаниеДиапазона - ПулыНомеровЭЛН.НачалоДиапазона) * 9 / 10)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЗаканчивающиесяПулы.ОГРН КАК ОГРН,
	               |	ВЫБОР
	               |		КОГДА ПулыНомеровЭЛН.Закрыт
	               |				ИЛИ ПулыНомеровЭЛН.ТекущийНомер >= ПулыНомеровЭЛН.НачалоДиапазона + (ПулыНомеровЭЛН.ОкончаниеДиапазона - ПулыНомеровЭЛН.НачалоДиапазона) * 9 / 10
	               |			ТОГДА 0
	               |		ИНАЧЕ 1
	               |	КОНЕЦ КАК ДоступныйПул
	               |ПОМЕСТИТЬ ДоступныеПулы
	               |ИЗ
	               |	ЗаканчивающиесяПулы КАК ЗаканчивающиесяПулы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПулыНомеровЭЛН КАК ПулыНомеровЭЛН
	               |		ПО ЗаканчивающиесяПулы.ОГРН = ПулыНомеровЭЛН.ОГРН
	               |ГДЕ
	               |	ВЫБОР
	               |			КОГДА ПулыНомеровЭЛН.Закрыт
	               |					ИЛИ ПулыНомеровЭЛН.ТекущийНомер >= ПулыНомеровЭЛН.НачалоДиапазона + (ПулыНомеровЭЛН.ОкончаниеДиапазона - ПулыНомеровЭЛН.НачалоДиапазона) * 9 / 10
	               |				ТОГДА 0
	               |			ИНАЧЕ 1
	               |		КОНЕЦ = 1
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЗаканчивающиесяПулы.ОГРН КАК ОГРН
	               |ИЗ
	               |	ЗаканчивающиесяПулы КАК ЗаканчивающиесяПулы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ДоступныеПулы КАК ДоступныеПулы
	               |		ПО ЗаканчивающиесяПулы.ОГРН = ДоступныеПулы.ОГРН
	               |ГДЕ
	               |	ДоступныеПулы.ДоступныйПул ЕСТЬ NULL";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для ОГРН: " + Выборка.ОГРН + " заканчиваются свободные номера!");	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

