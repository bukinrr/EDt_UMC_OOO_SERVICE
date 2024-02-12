
#Область ПрограммныйИнтерфейс

// Функция ПолучитьНастройкиDICOM
//   по пользователю возвращает настройки DICOM.
// Параметры:
//    Пользователь - СправочникСсылка.Пользователи - Пользователь, чьи настройки необходимо получить
//    СписокПолей - Структура - список полей, которые необходимо получить
// Возвращаемое значение:
//    Структура - значения требуемых настроек  
//
Функция ПолучитьНастройкиDICOM(СписокПолей, Пользователь) Экспорт
	
	Если ТипЗнч(СписокПолей) = Тип("Структура") Тогда
		СтруктураРеквизитов = СписокПолей;
	ИначеЕсли ТипЗнч(СписокПолей) = Тип("Строка") И ПустаяСтрока(СписокПолей) Тогда
		СтруктураРеквизитов = Новый Структура("Все");
	ИначеЕсли ТипЗнч(СписокПолей) = Тип("Строка") Тогда
		СтруктураРеквизитов = Новый Структура(СписокПолей);
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверный тип второго параметра ИменаИлиСтруктураРеквизитов: %1'"), 
			Строка(ТипЗнч(СписокПолей)));
	КонецЕсли;
	
	ТекстПолей = "";
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ИмяПоля   = ?(ЗначениеЗаполнено(КлючИЗначение.Значение), СокрЛП(КлючИЗначение.Значение), СокрЛП(КлючИЗначение.Ключ));
		Если ПустаяСтрока(СписокПолей) Тогда
			ТекстПолей  = "*";
		Иначе
			ТекстПолей  = ТекстПолей + ?(ПустаяСтрока(ТекстПолей), "", ",") + "
				|	" + ИмяПоля + " КАК " + ИмяПоля;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|" + ТекстПолей + "
		|ИЗ
		|	РегистрСведений.НастройкиDICOM КАК НастройкиDICOM
		|ГДЕ
		|	НастройкиDICOM.Пользователь = &Пользователь
		|");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();

	Результат = Новый Структура;
	Для Каждого КлючИЗначение Из РезультатЗапроса.Колонки Цикл
		Результат.Вставить(КлючИЗначение.Имя);
	КонецЦикла;
	ЗаполнитьЗначенияСвойств(Результат, Выборка);
	
	Возврат Результат;
	
КонецФункции
#КонецОбласти
