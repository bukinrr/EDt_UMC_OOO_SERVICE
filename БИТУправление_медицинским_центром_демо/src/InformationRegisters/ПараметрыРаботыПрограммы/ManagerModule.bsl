#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет требуется ли обновление или настройка информационной базы
// перед началом использования.
//
// Параметры:
//  НастройкаПодчиненногоУзлаРИБ - Булево - (возвращаемое значение), устанавливается Истина,
//                                 если обновление требуется в связи с настройкой подчиненного узла РИБ.
//
// Возвращаемое значение:
//  Булево - возвращает Истина, если требуется обновление или настройка информационной базы.
//
Функция НеобходимоОбновление(НастройкаПодчиненногоУзлаРИБ = Ложь) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Обновление в модели сервиса.
		Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
				// Заполнение разделенных параметров работы расширений.
				Возврат Истина;
			КонецЕсли;
			
		ИначеЕсли ОбновлениеИнформационнойБазыСлужебный.НеобходимоОбновлениеНеразделенныхДанныхИнформационнойБазы() Тогда
			// Обновление неразделенных параметров работы программы.
			Возврат Истина;
		КонецЕсли;
	Иначе
		// Обновление в локальном режиме.
		Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		
		// При запуске созданного начального образа подчиненного узла РИБ
		// загрузка не требуется, а обновление нужно выполнить.
		Если МодульОбменДаннымиСервер.НастройкаПодчиненногоУзлаРИБ() Тогда
			НастройкаПодчиненногоУзлаРИБ = Истина;
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Вызывает принудительное заполнение всех параметров работы программы.
Процедура ОбновитьВсеПараметрыРаботыПрограммы() Экспорт
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	
	ОбновитьПараметрыРаботыПрограммы();
	
КонецПроцедуры

Функция ИмяПроцедурыФоновогоЗадания() Экспорт
	
	Возврат "РегистрыСведений.ПараметрыРаботыПрограммы.ОбработчикДлительнойОперацииОбновленияПараметровРаботыПрограммы";
	
КонецФункции

// См. СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы.
Функция ПараметрРаботыПрограммы(ИмяПараметра) Экспорт
	
	ОписаниеЗначения = ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра);
	
	Если СтандартныеПодсистемыСервер.ВерсияПрограммыОбновленаДинамически() Тогда
		Возврат ОписаниеЗначения.Значение;
	КонецЕсли;
	
	Если ОписаниеЗначения.Версия <> Метаданные.Версия Тогда
		ПроверитьВозможностьОбновленияВМоделиСервиса();
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОписаниеЗначения.Значение;
	
КонецФункции

// См. СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы.
Процедура УстановитьПараметрРаботыПрограммы(ИмяПараметра, Значение) Экспорт
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	ПроверитьВозможностьОбновленияВМоделиСервиса();
	
	ОписаниеЗначения = Новый Структура;
	ОписаниеЗначения.Вставить("Версия", Метаданные.Версия);
	ОписаниеЗначения.Вставить("Значение", Значение);
	
	УстановитьХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра, ОписаниеЗначения);
	
КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ОбновитьПараметрРаботыПрограммы.
Процедура ОбновитьПараметрРаботыПрограммы(ИмяПараметра, Значение, ЕстьИзменения = Ложь, СтароеЗначение = Неопределено) Экспорт
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	ПроверитьВозможностьОбновленияВМоделиСервиса();
	
	ОписаниеЗначения = ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра);
	СтароеЗначение = ОписаниеЗначения.Значение;
	
	Если Не ОбщегоНазначения.ДанныеСовпадают(Значение, СтароеЗначение) Тогда
		ЕстьИзменения = Истина;
	ИначеЕсли ОписаниеЗначения.Версия = Метаданные.Версия Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрРаботыПрограммы(ИмяПараметра, Значение);
	
КонецПроцедуры


// См. СтандартныеПодсистемыСервер.ИзмененияПараметраРаботыПрограммы.
Функция ИзмененияПараметраРаботыПрограммы(ИмяПараметра) Экспорт
	
	ИмяПараметраХраненияИзменений = ИмяПараметра + ":Изменения";
	ПоследниеИзменения = ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметраХраненияИзменений);
	
	Версия = Метаданные.Версия;
	СледующаяВерсия = СледующаяВерсия(Версия);
	
	Если ОбщегоНазначения.РазделениеВключено()
	   И НЕ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		// План обновления областей строится только для областей,
		// которые имеют версию не ниже версии неразделенных данных.
		// Для остальных областей запускаются все обработчики обновления.
		
		// Версия неразделенных (общих) данных.
		ВерсияИБ = ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ(Метаданные.Имя, Истина);
	Иначе
		ВерсияИБ = ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ(Метаданные.Имя);
	КонецЕсли;
	
	// При начальном заполнении изменение параметров работы программы не определено.
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияИБ, "0.0.0.0") = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбновлениеВнеОбновленияИБ = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияИБ, Версия) = 0;
	
	Если Не ЭтоИзмененияПараметраРаботыПрограммы(ПоследниеИзменения) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для параметра работы программы ""%1"" не найдены изменения.'"), ИмяПараметра)
			+ СтандартныеПодсистемыСервер.УточнениеОшибкиПараметровРаботыПрограммыДляРазработчика();
	КонецЕсли;
	
	// Изменения к более старшим версиям не нужны,
	// кроме случая когда обновление выполняется вне обновления ИБ,
	// т.е. версия ИБ равна версии конфигурации.
	// В этом случае дополнительно выбираются изменения к следующей версии.
	
	Индекс = ПоследниеИзменения.Количество()-1;
	Пока Индекс >= 0 Цикл
		ВерсияИзменения = ПоследниеИзменения[Индекс].ВерсияКонфигурации;
		
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияИБ, ВерсияИзменения) >= 0
		   И НЕ (  ОбновлениеВнеОбновленияИБ
		         И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СледующаяВерсия, ВерсияИзменения) = 0) Тогда
			
			ПоследниеИзменения.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Возврат ПоследниеИзменения.ВыгрузитьКолонку("Изменения");
	
КонецФункции

// См. СтандартныеПодсистемыСервер.ДобавитьИзмененияПараметраРаботыПрограммы.
Процедура ДобавитьИзмененияПараметраРаботыПрограммы(ИмяПараметра, Знач Изменения) Экспорт
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	ПроверитьВозможностьОбновленияВМоделиСервиса();
	
	// Получение версии ИБ или неразделенных данных.
	ВерсияИБ = ОбновлениеИнформационнойБазыСлужебный.ВерсияИБ(Метаданные.Имя);
	
	// При переходе на другую программу используется текущая версия конфигурации.
	Если Не ОбщегоНазначения.РазделениеВключено()
	   И ОбновлениеИнформационнойБазыСлужебный.РежимОбновленияДанных() = "ПереходСДругойПрограммы" Тогда
		
		ВерсияИБ = Метаданные.Версия;
	КонецЕсли;
	
	// При начальном заполнении добавление изменений параметров пропускается.
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияИБ, "0.0.0.0") = 0 Тогда
		Изменения = Неопределено;
	КонецЕсли;
	
	ИмяПараметраХраненияИзменений = ИмяПараметра + ":Изменения";
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыРаботыПрограммы");
	ЭлементБлокировки.УстановитьЗначение("ИмяПараметра", ИмяПараметраХраненияИзменений);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		ОбновитьСоставИзменений = Ложь;
		ПоследниеИзменения = ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметраХраненияИзменений);
		
		Если Не ЭтоИзмененияПараметраРаботыПрограммы(ПоследниеИзменения) Тогда
			ПоследниеИзменения = Неопределено;
		КонецЕсли;
		
		Если ПоследниеИзменения = Неопределено Тогда
			ОбновитьСоставИзменений = Истина;
			ПоследниеИзменения = Новый ТаблицаЗначений;
			ПоследниеИзменения.Колонки.Добавить("ВерсияКонфигурации");
			ПоследниеИзменения.Колонки.Добавить("Изменения");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Изменения) Тогда
			
			// Если производится обновление вне обновления ИБ,
			// тогда требуется добавить изменения к следующей версии,
			// чтобы при переходе на очередную версию, изменения
			// выполненные вне обновления ИБ были учтены.
			Версия = Метаданные.Версия;
			
			ОбновлениеВнеОбновленияИБ =
				ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияИБ , Версия) = 0;
			
			Если ОбновлениеВнеОбновленияИБ Тогда
				Версия = СледующаяВерсия(Версия);
			КонецЕсли;
			
			ОбновитьСоставИзменений = Истина;
			Строка = ПоследниеИзменения.Добавить();
			Строка.Изменения          = Изменения;
			Строка.ВерсияКонфигурации = Версия;
		КонецЕсли;
		//+БИТ
		УстановитьПривилегированныйРежим(Истина);
		МинимальнаяВерсияИБ = Константы.НомерВерсииКонфигурации.Получить();
		УстановитьПривилегированныйРежим(Ложь);
		//-БИТ
		// Удаление изменений для версий ИБ, которые меньше минимальной
		// вместо версий меньше или равных минимальной, чтобы обеспечить
		// возможность обновления вне обновления ИБ.
		Индекс = ПоследниеИзменения.Количество()-1;
		Пока Индекс >=0 Цикл
			ВерсияИзменения = ПоследниеИзменения[Индекс].ВерсияКонфигурации;
			
			Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(МинимальнаяВерсияИБ, ВерсияИзменения) > 0 Тогда
				ПоследниеИзменения.Удалить(Индекс);
				ОбновитьСоставИзменений = Истина;
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
		
		Если ОбновитьСоставИзменений Тогда
			УстановитьХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметраХраненияИзменений,
				ПоследниеИзменения);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры


// Для вызова из процедуры ВыполнитьОбновлениеИнформационнойБазы.
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
	   И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбработатьПараметрыРаботыВерсийРасширений();
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

// Для вызова из формы ИндикацияХодаОбновленияИБ.
Функция ОбработанныйРезультатДлительнойОперации(Результат) Экспорт
	
	КраткоеПредставлениеОшибки   = Неопределено;
	ПодробноеПредставлениеОшибки = Неопределено;
	
	Если Результат = Неопределено Или Результат.Статус = "Отменено" Тогда
		
		КраткоеПредставлениеОшибки =
			НСтр("ru = 'Не удалось обновить параметры работы программы по причине:
			           |Фоновое задание, выполняющее обновление отменено.'");
		
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
			КраткоеПредставлениеОшибки   = РезультатВыполнения.КраткоеПредставлениеОшибки;
			ПодробноеПредставлениеОшибки = РезультатВыполнения.ПодробноеПредставлениеОшибки;
		Иначе
			КраткоеПредставлениеОшибки =
				НСтр("ru = 'Не удалось обновить параметры работы программы по причине:
				           |Фоновое задание, выполняющее обновление не вернуло результат.'");
		КонецЕсли;
	ИначеЕсли Результат.Статус <> "ЗапускНеТребуется" Тогда
		// Ошибка выполнения фонового задания.
		КраткоеПредставлениеОшибки   = Результат.КраткоеПредставлениеОшибки;
		ПодробноеПредставлениеОшибки = Результат.ПодробноеПредставлениеОшибки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПодробноеПредставлениеОшибки)
	   И    ЗначениеЗаполнено(КраткоеПредставлениеОшибки) Тогда
		
		ПодробноеПредставлениеОшибки = КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КраткоеПредставлениеОшибки)
	   И    ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) Тогда
		
		КраткоеПредставлениеОшибки = ПодробноеПредставлениеОшибки;
	КонецЕсли;
	
	ОбработанныйРезультат = Новый Структура;
	ОбработанныйРезультат.Вставить("КраткоеПредставлениеОшибки",   КраткоеПредставлениеОшибки);
	ОбработанныйРезультат.Вставить("ПодробноеПредставлениеОшибки", ПодробноеПредставлениеОшибки);
	
	Если Не ЗначениеЗаполнено(КраткоеПредставлениеОшибки) Тогда
		ОбработатьПараметрыРаботыВерсийРасширений();
	КонецЕсли;
	
	Возврат ОбработанныйРезультат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для вызова из фонового задания без подключенных расширений конфигурации.
Процедура ОбработчикДлительнойОперацииОбновленияПараметровРаботыПрограммы(СообщитьПрогресс, АдресХранилища) Экспорт
	
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("КраткоеПредставлениеОшибки",   Неопределено);
	РезультатВыполнения.Вставить("ПодробноеПредставлениеОшибки", Неопределено);
	
	Попытка
		ОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		РезультатВыполнения.КраткоеПредставлениеОшибки   = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		РезультатВыполнения.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		// Переход в режим открытия формы повторной синхронизации данных перед запуском
		// с двумя вариантами "Синхронизировать и продолжить" и "Продолжить".
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными")
		   И ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
			МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
			МодульОбменДаннымиСервер.ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
		КонецЕсли;
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс)
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	
	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения)
		И Не ВыполнятьОбновлениеБезФоновогоЗадания() Тогда
		ТекстОшибки =
			НСтр("ru = 'Не удалось обновить параметры работы программы по причине:
			           |Найдены подключенные расширения конфигурации.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
	   И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ТекстОшибки =
			НСтр("ru = 'Не удалось обновить параметры работы программы по причине:
			           |Обновление невозможно выполнить в области данных.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	МодульОценкаПроизводительности = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		ВремяНачала = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	// Нет РИБ-обмена данными
	// или обновление в главном узле ИБ
	// или обновление при первом запуске подчиненного узла
	// или обновление после загрузки справочника "Идентификаторы объектов метаданных" из главного узла.
	ОбновитьПараметрыРаботыПрограммы(СообщитьПрогресс);
	
	Если МодульОценкаПроизводительности <> Неопределено Тогда
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени("ВремяОбновленияКэшейМетаданных", ВремяНачала);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьПараметрыРаботыВерсийРасширений()
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Для функции ИзмененияПараметраРаботыПрограммы.
Функция СледующаяВерсия(Версия)
	
	Массив = СтрРазделить(Версия, ".");
	
	Возврат ОбщегоНазначенияКлиентСервер.ВерсияКонфигурацииБезНомераСборки(
		Версия) + "." + Формат(Число(Массив[3]) + 1, "ЧГ=");
	
КонецФункции

// Для процедур ЗагрузитьОбновитьПараметрыРаботыПрограммы, ОбновитьВсеПараметрыРаботыПрограммы.
Процедура ОбновитьПараметрыРаботыПрограммы(СообщитьПрогресс = Ложь)
	
	Если СообщитьПрогресс Тогда
		ДлительныеОперации.СообщитьПрогресс(30);
	КонецЕсли;
	
	Если Не СтандартныеПодсистемыПовтИсп.ОтключитьИдентификаторыОбъектовМетаданных() Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(Ложь, Ложь, Ложь);
	КонецЕсли;
	Если СообщитьПрогресс Тогда
		ДлительныеОперации.СообщитьПрогресс(60);
	КонецЕсли;
	
	// Критичная проверка назначения ролей пользователей.
	ПользователиСлужебный.ПроверитьНазначениеРолей();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		МодульУправлениеДоступомСлужебный.ОбновитьПараметрыОграниченияДоступа();
	КонецЕсли;
	Если СообщитьПрогресс Тогда
		ДлительныеОперации.СообщитьПрогресс(100);
	КонецЕсли;
	
КонецПроцедуры

// Для функции ПараметрРаботыПрограммы и процедуры ОбновитьПараметрРаботыПрограммы.
Функция ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра)
	
	ОписаниеЗначения = ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра);
	
	Если ТипЗнч(ОписаниеЗначения) <> Тип("Структура")
	 Или ОписаниеЗначения.Количество() <> 2
	 Или Не ОписаниеЗначения.Свойство("Версия")
	 Или Не ОписаниеЗначения.Свойство("Значение") Тогда
		
		Если СтандартныеПодсистемыСервер.ВерсияПрограммыОбновленаДинамически() Тогда
			СтандартныеПодсистемыСервер.ПотребоватьПерезапускСеансаПоПричинеДинамическогоОбновленияВерсииПрограммы();
		КонецЕсли;
		ПроверитьВозможностьОбновленияВМоделиСервиса();
		Возврат Новый Структура("Версия,Значение");
	КонецЕсли;
	
	Возврат ОписаниеЗначения;
	
КонецФункции

// Для функций ОписаниеЗначенияПараметраРаботыПрограммы, ИзмененияПараметраРаботыПрограммы и
// процедуры ДобавитьИзмененияПараметраРаботыПрограммы.
//
Функция ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПараметра", ИмяПараметра);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыРаботыПрограммы.ХранилищеПараметра
	|ИЗ
	|	РегистрСведений.ПараметрыРаботыПрограммы КАК ПараметрыРаботыПрограммы
	|ГДЕ
	|	ПараметрыРаботыПрограммы.ИмяПараметра = &ИмяПараметра";
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ХранилищеПараметра.Получить();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
	Возврат Неопределено;
	
КонецФункции

// Для процедур УстановитьПараметрРаботыПрограммы, ДобавитьИзмененияПараметраРаботыПрограммы.
Процедура УстановитьХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра, ХранимыеДанные)
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИмяПараметра.Установить(ИмяПараметра);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.ИмяПараметра       = ИмяПараметра;
	НоваяЗапись.ХранилищеПараметра = Новый ХранилищеЗначения(ХранимыеДанные);
	//+БИТ
	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписей.Записать();
	УстановитьПривилегированныйРежим(Ложь);	
	//-БИТ
КонецПроцедуры

Процедура ПроверитьВозможностьОбновленияВМоделиСервиса()
	
	Если Не ОбщегоНазначения.РазделениеВключено()
	 Или Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки =
		НСтр("ru = 'Параметры работы программы не обновлены в неразделенном режиме.
		           |Обратитесь к администратору сервиса.'");
	
	ВызватьИсключение ТекстОшибки;
	
КонецПроцедуры

Функция ДоступноВыполнениеФоновыхЗаданий()
	
	Если ТекущийРежимЗапуска() = Неопределено
	   И ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Сеанс = ПолучитьТекущийСеансИнформационнойБазы();
		Если Сеанс.ИмяПриложения = "COMConnection"
		 Или Сеанс.ИмяПриложения = "BackgroundJob" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ВыполнятьОбновлениеБезФоновогоЗадания()
	
	Если Не ДоступноВыполнениеФоновыхЗаданий() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭтоИзмененияПараметраРаботыПрограммы(ПоследниеИзменения)
	
	Если ТипЗнч(ПоследниеИзменения)              <> Тип("ТаблицаЗначений")
	 ИЛИ ПоследниеИзменения.Колонки.Количество() <> 2
	 ИЛИ ПоследниеИзменения.Колонки[0].Имя       <> "ВерсияКонфигурации"
	 ИЛИ ПоследниеИзменения.Колонки[1].Имя       <> "Изменения" Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли
