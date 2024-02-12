#Область ПрограммныйИнтерфейс

// Добавляет по документу сведения по продажам в регистр сведений "ПараметрыПродажПоСтраховымПрограммам".
//
// Параметры:
//  Документ - ДокументСсылка.ОказаниеУслуг	 - документ продажи по страховому полису.
//
Процедура СформироватьЗаписиПоПараметрамПродажПоСтраховымПрограммам(Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КолонкиТаблицыНовых = "Документ, ИмяТЧ, КлючСтроки, Номенклатура, Сотрудник, Количество, Сумма";
	
	НаборЗаписей = РегистрыСведений.ПараметрыПродажПоСтраховымПрограммам.СоздатьНаборЗаписей();
	ТаблицаНовых = НаборЗаписей.Выгрузить(,КолонкиТаблицыНовых);
	
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Прочитать();
	
	ТаблицаСтарых = НаборЗаписей.Выгрузить();
	
	// Если у документа нет записей параметров и они не должны возникнуть, то не выполняем формирование
	Если НаборЗаписей.Количество() = 0
		И (Не Документ.Проведен Или Не ЗначениеЗаполнено(Документ.Документ) Или Не Документ.Документ.ВидПолиса.РеестрТребуетМедицинскихПараметров)
	Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей.Очистить();

	// Сначала формируем те записи, которые должны быть по документу
	Если ЗначениеЗаполнено(Документ.Документ)
		И Документ.Документ.ВидПолиса.РеестрТребуетМедицинскихПараметров
	Тогда
		// Если страховой полис заполнен.
		мсТЧ = Новый Массив;
		мсТЧ.Добавить("Работы");
		мсТЧ.Добавить("Материалы");
		мсТЧ.Добавить("Товары");
		мсТЧ.Добавить("Сертификаты");
		мсТЧ.Добавить("ПополнениеСертификатов");
		
		Для Каждого ИмяТЧ Из мсТЧ Цикл
			Для Каждого СтрокаТЧ Из Документ[ИмяТЧ] Цикл
				
				Если Не СтрокаТЧ.НеОплачиваетсяПолисом // Если оплачивается полисом
					И СтрокаТЧ.Сумма > СтрокаТЧ.СуммаНеПоПолису // Если хотя бы часть суммы оплачивается полисом
				Тогда
					СтрокаЗаписи = ТаблицаНовых.Добавить();
					СтрокаЗаписи.Документ = Документ;
					СтрокаЗаписи.ИмяТЧ = ИмяТЧ;
					СтрокаЗаписи.КлючСтроки = СтрокаТЧ.КлючСтроки;
					
					СтрокаЗаписи.Сумма = СтрокаТЧ.Сумма - СтрокаТЧ.СуммаНеПоПолису;
					
					СтрокаЗаписи.Сотрудник = ПолучитьСотрудникаСтрокиПродажи(Документ, СтрокаТЧ, ИмяТЧ);
					
					Если ИмяТЧ = "Сертификаты" Или ИмяТЧ = "ПополнениеСертификатов" Тогда
						СтрокаЗаписи.Номенклатура = СтрокаТЧ.Сертификат.ВидСертификата;
						СтрокаЗаписи.Количество = 1;
					Иначе
						СтрокаЗаписи.Номенклатура = СтрокаТЧ.Номенклатура;
						СтрокаЗаписи.Количество = СтрокаТЧ.Количество;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
		
	// Сопоставляем требуемые записи с имеющимися, обновляем старые записи, добавляем новые
	
	// Если ничего не изменилось, не записываем набор записей
	ТаблицаСтарыхКопия = ТаблицаСтарых.Скопировать(,КолонкиТаблицыНовых);
	Если ОбщегоНазначения.СравнитьТаблицыНаборовЗаписей(ТаблицаНовых, ТаблицаСтарыхКопия) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор1 = Новый Структура("Документ, ИмяТЧ, КлючСтроки, Номенклатура");
	Отбор2 = Новый Структура("Документ, ИмяТЧ, КлючСтроки, Сумма");
	
	// Сопоставляем старые и новые строки по отбору №1
	ОтработанныеНовыеСтроки = Новый Массив;
	Для Каждого НоваяСтрока Из ТаблицаНовых Цикл
		
		ЗаполнитьЗначенияСвойств(Отбор1, НоваяСтрока);
		
		СтарыеСтроки = ТаблицаСтарых.НайтиСтроки(Отбор1);
		
		Если СтарыеСтроки.Количество() <> 0 Тогда
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, СтарыеСтроки[0]);
			ЗаполнитьЗначенияСвойств(Запись, НоваяСтрока, "Количество, Сумма, Сотрудник");
			
			ОтработанныеНовыеСтроки.Добавить(НоваяСтрока);
			ТаблицаСтарых.Удалить(СтарыеСтроки[0]);
		КонецЕсли;
		
	КонецЦикла;
	// Сопоставляем оставшиеся старые и новые строки по отбору №2 (могла измениться номенклатура, а сумма - нет)
	Для Каждого НоваяСтрока Из ТаблицаНовых Цикл
		
		Если ОтработанныеНовыеСтроки.Найти(НоваяСтрока) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Отбор2, НоваяСтрока);
		
		СтарыеСтроки = ТаблицаСтарых.НайтиСтроки(Отбор2);
		
		Если СтарыеСтроки.Количество() <> 0 Тогда
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, СтарыеСтроки[0]);
			ЗаполнитьЗначенияСвойств(Запись, НоваяСтрока, "Количество, Номенклатура, Сотрудник");
			
			ОтработанныеНовыеСтроки.Добавить(НоваяСтрока);
			ТаблицаСтарых.Удалить(СтарыеСтроки[0]);
		КонецЕсли;
	КонецЦикла;
	// Оставшиеся новые строки добавляем в набор записей
	Для Каждого НоваяСтрока Из ТаблицаНовых Цикл
		
		Если ОтработанныеНовыеСтроки.Найти(НоваяСтрока) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, НоваяСтрока);
	КонецЦикла;
	
	// Устанавливаем активность записей
	НаборЗаписей.УстановитьАктивность(Документ.Проведен);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Данные полиса ОМС пациента: номер серия и другие поля для возможного вывода на печать.
//
// Параметры:
//  Клиент	 - СправочникСсылка.Клиент	 - пациент.
//  Дата	 - Дата						 - дата актуальности.
// 
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьДанныеПолисаДляМедкарты(Клиент, Дата = Неопределено) Экспорт
	
	Результат = Новый Структура("Полис, НомерПолиса, СерияПолиса, НомерСерияПолиса, 
								|СрокДействияНачало, СрокДействия,	
								|СтраховаяОрганизация, СтраховаяОрганизацияСсылка, КлассификаторВидовПолисовРЭМД");
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Клиент",	 Клиент);
	Запрос.УстановитьПараметр("Дата",	 Дата);
	Запрос.УстановитьПараметр("ОМС",	 Перечисления.ТипыСтраховыхПрограмм.ОМС);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ссылка КАК Полис,
	|	Наименование КАК Наименование,
	|	Номер КАК НомерПолиса,
	|	Серия КАК СерияПолиса,
	|	СрокДействияНачало КАК СрокДействияНачало,
	|	СрокДействия КАК СрокДействия,
	|	КлассификаторВидовПолисовРЭМД КАК КлассификаторВидовПолисовРЭМД,
	|	ВидПолиса КАК ВидПолиса,
	|	ВидПолиса.Контрагент КАК СтраховаяОрганизацияСсылка,
	|	НеДействителен КАК НеДействителен
	|ИЗ
	|	Справочник.СтраховыеПолисы КАК СтраховыеПолисы
	|ГДЕ
	|	Владелец = &Клиент
	|	И Не ПометкаУдаления
	|	И (СрокДействияНачало = ДАТАВРЕМЯ(1,1,1) ИЛИ СрокДействияНачало <= &Дата)
	|	И (СрокДействия		  = ДАТАВРЕМЯ(1,1,1) ИЛИ СрокДействия >= &Дата)
	|	И ВидПолиса.Тип = &ОМС
	|"
	;
	
	ОсновнойПолис = Клиент.умцОсновнойСтраховойПолис;
	
	НайденныеПолисыОМС = Новый ТаблицаЗначений;
	НайденныеПолисыОМС.Колонки.Добавить("Полис");
	НайденныеПолисыОМС.Колонки.Добавить("Основной", Новый ОписаниеТипов("Булево"));
	НайденныеПолисыОМС.Колонки.Добавить("Действует", Новый ОписаниеТипов("Булево"));
	
	Выб = Запрос.Выполнить().Выбрать();
	Пока Выб.Следующий() Цикл
		
		СтрокаПолис = НайденныеПолисыОМС.Добавить();
		СтрокаПолис.Полис = Выб.Полис;
		СтрокаПолис.Основной = Выб.Полис = ОсновнойПолис;
		СтрокаПолис.Действует = Не Выб.НеДействителен;
	КонецЦикла;
	
	Если НайденныеПолисыОМС.Количество() <> 0 Тогда
		
		НайденныеПолисыОМС.Сортировать("Действует Убыв, Основной Убыв");
		Полис = НайденныеПолисыОМС[0].Полис;
		
		Выб.Сбросить();
		Выб.НайтиСледующий(Новый Структура("Полис", Полис));
		
		ЗаполнитьЗначенияСвойств(Результат, Выб);
		
		Результат.НомерСерияПолиса = СокрЛП(Результат.НомерПолиса+" "+Результат.СерияПолиса);
		
		Если ЗначениеЗаполнено(Результат.СтраховаяОрганизацияСсылка) Тогда
			Результат.СтраховаяОрганизация = ?(ЗначениеЗаполнено(Результат.СтраховаяОрганизацияСсылка.НаименованиеПолное),
												Результат.СтраховаяОрганизацияСсылка.НаименованиеПолное,
												Строка(Результат.СтраховаяОрганизацияСсылка));
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Ссылка на полис ОМС пациента.
//
// Параметры:
//  Клиент	 - СправочникСсылка.Клиент	 - пациент.
//  Дата	 - Дата						 - дата актуальности.
// 
// Возвращаемое значение:
//  СправочникСсылка.СтраховыеПолисы.
//
Функция ПолисОМСКлиента(Клиент, Дата = Неопределено) Экспорт
	
	Возврат ПолучитьДанныеПолисаДляМедкарты(Клиент, Дата);
	
КонецФункции

// Проверяет переданный массив номенклатуры на входимость в отбор вида полиса и возвращает массив не прошедших.
//
// Параметры:
//  Полис	 - СправочникСсылка.ВидПолиса, СправочникСсылка.СтраховыеПолисы - вид полиса, чей отбор анализируется.
//  ПроверяемаяНоменклатура - Массив	 - массив из СправочникСсылка.Номенклатура проверяемыми с услугами.
// 
// Возвращаемое значение:
//  Массив - массив из СправочникСсылка.Номенклатура услуг, прошедших отбор вида полиса.
//
Функция НоменклатураИсключаемаяОтборомПолиса(Полис, ПроверяемаяНоменклатура) Экспорт
	
	// Подготовка переменных
	Если ТипЗнч(Полис) = Тип("СправочникСсылка.СтраховыеПолисы") Тогда
		ВидПолиса = Полис.ВидПолиса;
	Иначе
		ВидПолиса = Полис;
	КонецЕсли;
	
	Если ТипЗнч(ПроверяемаяНоменклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		НоменклатураМассив = Новый Массив;
		НоменклатураМассив.Добавить(ПроверяемаяНоменклатура);
	Иначе
		НоменклатураМассив = ПроверяемаяНоменклатура;
	КонецЕсли;
	
	ИсключаемаяНоменклатура = Новый Массив;
	
	// Расчет непопадающих в отбор вида полиса.
	НоменклатураПолиса = ДопустимаяНоменклатураПолиса(ВидПолиса);
	Если НоменклатураПолиса.Количество() <> 0 Тогда
		
		Для Каждого Номенклатура Из НоменклатураМассив Цикл
			
			Если НоменклатураПолиса.Найти(Номенклатура) = Неопределено Тогда
				ИсключаемаяНоменклатура.Добавить(Номенклатура);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат ИсключаемаяНоменклатура;
	
КонецФункции

Функция ОстаткиГарантийныхПоПолису(МоментВремени, Полис) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", ?(ТипЗнч(МоментВремени) = Тип("МоментВремени"), МоментВремени.Дата, МоментВремени));
	Запрос.УстановитьПараметр("ГраницаОстатков", МоментВремени);
	Запрос.УстановитьПараметр("Полис",Полис);
	
	// Остатки по ОстаткиПоГарантийнымПисьмам и ОстаткиПоГарантийнымПисьмамНаУслуги. 
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ГарантийноеПисьмоПоПолису.Ссылка КАК ГарантийноеПисьмо,
		|	ГарантийноеПисьмоПоПолису.ДатаСрок КАК ДатаСрок,
		|	ГарантийноеПисьмоПоПолису.Дата КАК Дата
		|ПОМЕСТИТЬ ГарантийныеПисьма
		|ИЗ
		|	Документ.ГарантийноеПисьмоПоПолису КАК ГарантийноеПисьмоПоПолису
		|ГДЕ
		|	ГарантийноеПисьмоПоПолису.Полис = &Полис
		|	И (ГарантийноеПисьмоПоПолису.ДатаСрок = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ НАЧАЛОПЕРИОДА(&ДатаДокумента, ДЕНЬ) <= ГарантийноеПисьмоПоПолису.ДатаСрок)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Остатки.ГарантийноеПисьмо КАК ГарантийноеПисьмо,
		|	Остатки.СуммаОстаток КАК Сумма,
		|	ВЫБОР
		|		КОГДА Остатки.ГарантийноеПисьмо.ДатаСрок = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ КАК Ограниченное
		|ИЗ
		|	РегистрНакопления.ОстаткиПоГарантийнымПисьмам.Остатки(
		|			&ДатаДокумента,
		|			СтраховойПолис = &Полис
		|				И ГарантийноеПисьмо В
		|					(ВЫБРАТЬ
		|						ГП.ГарантийноеПисьмо
		|					ИЗ
		|						ГарантийныеПисьма КАК ГП)) КАК Остатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ГарантийныеПисьма КАК ГарантийныеПисьма
		|		ПО Остатки.ГарантийноеПисьмо = ГарантийныеПисьма.ГарантийноеПисьмо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ограниченное УБЫВ,
		|	ГарантийныеПисьма.ДатаСрок,
		|	ГарантийныеПисьма.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Остатки.ГарантийноеПисьмо КАК ГарантийноеПисьмо,
		|	Остатки.Номенклатура КАК Номенклатура,
		|	Остатки.КоличествоОстаток КАК Количество,
		|	ВЫБОР
		|		КОГДА Остатки.ГарантийноеПисьмо.ДатаСрок = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ КАК Ограниченное
		|ИЗ
		|	РегистрНакопления.ОстаткиПоГарантийнымПисьмамНаУслуги.Остатки(
		|			&ДатаДокумента,
		|			СтраховойПолис = &Полис
		|				И ГарантийноеПисьмо В
		|					(ВЫБРАТЬ
		|						ГП.ГарантийноеПисьмо
		|					ИЗ
		|						ГарантийныеПисьма КАК ГП)) КАК Остатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ГарантийныеПисьма КАК ГарантийныеПисьма
		|		ПО Остатки.ГарантийноеПисьмо = ГарантийныеПисьма.ГарантийноеПисьмо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ограниченное УБЫВ,
		|	ГарантийныеПисьма.ДатаСрок,
		|	ГарантийныеПисьма.Дата";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Остатки = Новый Структура;
	Остатки.Вставить("НаСумму",	 РезультатыЗапроса[1].Выгрузить());
	Остатки.Вставить("НаУслуги", РезультатыЗапроса[2].Выгрузить());
	
	Возврат Остатки;
	
КонецФункции

// Найти полис клиента по заданному виду полиса.
//
// Параметры:
//  Клиент				 - СправочникСсылка.Клиенты	 - владелец полиса.
//  ВидПолиса			 - СправочникСсылка.ВидыПолисов	 - вид полиса. Можно массив видов полиса.
//  ТолькоДействующий	 - Булево						 - учитывать ли аннулированные и просроченные.
//  ДатаДействия		 - Дата							 - срок действия.
// 
// Возвращаемое значение:
//  СправочникСсылка.СтраховыеПолисы.
//
Функция ПолисПоВиду(Клиент, ВидПолиса, ТолькоДействующий = Истина, Знач ДатаДействия = Неопределено) Экспорт
	
	Если ДатаДействия = Неопределено Тогда
		ДатаДействия = ТекущаяДата();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", Клиент);
	Запрос.УстановитьПараметр("ВидПолиса", ВидПолиса);
	Запрос.УстановитьПараметр("ТолькоДействующий", ТолькоДействующий);
	Запрос.УстановитьПараметр("ДатаДействия", ДатаДействия);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтраховыеПолисы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтраховыеПолисы КАК СтраховыеПолисы
	|ГДЕ
	|	СтраховыеПолисы.Владелец = &Владелец
	|	И СтраховыеПолисы.ВидПолиса В (&ВидПолиса)
	|	И НЕ СтраховыеПолисы.ПометкаУдаления
	|	И (&ТолькоДействующий <> ИСТИНА
	|			ИЛИ НЕ СтраховыеПолисы.НеДействителен
	|				И (СтраховыеПолисы.СрокДействия = ДАТАВРЕМЯ(1, 1, 1)
	|					ИЛИ СтраховыеПолисы.СрокДействия >= &ДатаДействия)
	|				И (СтраховыеПолисы.СрокДействияНачало = ДАТАВРЕМЯ(1, 1, 1)
	|					ИЛИ СтраховыеПолисы.СрокДействияНачало <= &ДатаДействия))"
	;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.СтраховыеПолисы.ПустаяСсылка();
	
КонецФункции

// Найти полис клиента по заданному типу полиса (ОМС, ДМС, Прочее).
//
// Параметры:
//  Клиент				 - СправочникСсылка.Клиенты	 - владелец полиса.
//  ТипПолиса			 - ПеречислениеСсылка.ТипыСтраховыхПрограмм	 - тид полиса.
//  ТолькоДействующий	 - Булево						 - учитывать ли аннулированные и просроченные.
//  ДатаДействия		 - Дата							 - срок действия.
// 
// Возвращаемое значение:
//  СправочникСсылка.СтраховыеПолисы.
//
Функция ПолисПоТипу(Клиент, ТипПолиса, ТолькоДействующий = Истина, Знач ДатаДействия = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Тип", ТипПолиса);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыПолисов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыПолисов КАК ВидыПолисов
	|ГДЕ
	|	ВидыПолисов.Тип = &Тип"
	;
	ВидыПолисов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат ПолисПоВиду(Клиент, ВидыПолисов, ТолькоДействующий, ДатаДействия);
	
КонецФункции

// Разрешенная номенклатура вида полиса.
//
// Параметры:
//  ВидПолиса	 - СправочникСсылка.ВидыПолисов	 - вид полиса.
//  Дата		 - Дата							 - дата анализа цен.
// 
// Возвращаемое значение:
//  Массив - содержащий СправочникСсылка.Номенклатура.
//
Функция ДопустимаяНоменклатураПолиса(ВидПолиса, Знач Дата = '00010101') Экспорт
	
	Перем НоменклатураПолиса;
	
	НельзяВернутьПустойМассив = Истина;
	
	Если ВидПолиса.СоставПолисаОпределяетсяПрейскурантом Тогда
		
		НоменклатураПолиса = Ценообразование.ПолучитьНоменклатуруИмеющуюЦены(ВидПолиса.Прейскурант, Дата);
		
	Иначе // Из табличной части вида полиса.
		
		НоменклатураПолиса = ВидПолиса.Номенклатура.ВыгрузитьКолонку("Номенклатура");
		Если НоменклатураПолиса.Количество() <> 0
			И ВидПолиса.ПроверятьНаличиеЦеныВПрейскуранте
		Тогда
			НоменклатураПолиса = Ценообразование.ПолучитьНоменклатуруИмеющуюЦены(ВидПолиса.Прейскурант, Дата, НоменклатураПолиса);
		Иначе
			НельзяВернутьПустойМассив = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если НоменклатураПолиса.Количество() = 0
		И НельзяВернутьПустойМассив
	Тогда
		// Особенность проверок далее - пустой список = разрешена любая. 
		// Поэтому, если цен в прайсе нет, даем не пустой массив.
		НоменклатураПолиса.Добавить(Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор));
	КонецЕсли;
	
	Возврат НоменклатураПолиса;
	
КонецФункции

// Проверяет, оплачивается ли указанным Полисом указанная Номенклатура.
//
// Параметры:
//  Полис		 - СправочникСсылка.СтраховыеПолисы	 - полис.
//  Номенклатура - СправочникСсылка.Номенклатура	 - номенклатура.
// 
// Возвращаемое значение:
//   Булево.
//
Функция УслугаНеОплачиваетсяПолисом(Полис, Номенклатура) Экспорт
	
	НоменклатураПолиса = МедицинскоеСтрахование.ДопустимаяНоменклатураПолиса(Полис.ВидПолиса);
	Если НоменклатураПолиса.Количество() = 0 Или
		 НоменклатураПолиса.Найти(Номенклатура) <> Неопределено
	Тогда
		Возврат Ложь; // Оплачивается полисом
	Иначе
		Возврат Истина; // Не оплачивается полисом
	КонецЕсли;
	
КонецФункции

// Реквизиты вида полиса по полису.
//
// Параметры:
//  Полис			 - СправочникСсылка.СтраховыеПолисы	 - полис.
//  ИменаРеквизитов	 - Строка							 - имена нужных реквизитов через запятую.
// 
// Возвращаемое значение:
//  Структура - ключевые реквизиты вида полиса
//
Функция ОписаниеПолиса(Полис, Знач Дата = Неопределено) Экспорт 
	
	Описание = Новый Структура("ВидПолиса, Тип, УчетПлатныхМатериаловОбособленноОтУслуг, ОшибкаПолисНеДействителен, ПолисДействителен");
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	
	Описание.ВидПолиса = Полис.ВидПолиса;
	Описание.Тип = Описание.ВидПолиса.Тип;
	Описание.УчетПлатныхМатериаловОбособленноОтУслуг = Описание.ВидПолиса.УчетПлатныхМатериаловОбособленноОтУслуг;
	Описание.ОшибкаПолисНеДействителен = ПроверитьПолисДействителен(Полис, Дата);
	Описание.ПолисДействителен = ПустаяСтрока(Описание.ОшибкаПолисНеДействителен);
	
	Возврат Описание;
	
КонецФункции

// Проверить действителен ли полис.
//
// Параметры:
//  СтраховойПолис	 - СправочникСсылка.СтраховыеПолисы	 - полис
//  ДатаПроверки	 - Дата								 - дата првоерки
// 
// Возвращаемое значение:
//   Булево.
//
Функция ПроверитьПолисДействителен(СтраховойПолис,ДатаПроверки = Неопределено) Экспорт
	
	ТекстСообщенияОбОшибке = ""; // Полис действителен
	
	Если ДатаПроверки = Неопределено Тогда
		ДатаПроверки = ТекущаяДата();
	КонецЕсли;
	
	Если ТипЗнч(СтраховойПолис) = Тип("СправочникСсылка.СтраховыеПолисы") Тогда
		
		Если СтраховойПолис.НеДействителен Тогда
			ТекстСообщенияОбОшибке = "Полис не действителен.";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтраховойПолис.СрокДействия) И 
			 ДатаПроверки > КонецДня(СтраховойПолис.СрокДействия)
		Тогда
			ТекстСообщенияОбОшибке = "Срок действия полиса окончен.";
		КонецЕсли;
		
		Если ДатаПроверки < НачалоДня(СтраховойПолис.СрокДействияНачало) Тогда
			ТекстСообщенияОбОшибке = "Полис еще не начал действовать.";
		КонецЕсли;
				
	КонецЕсли;
	
	Возврат ТекстСообщенияОбОшибке;
	
КонецФункции                                                       

// Действующий договор со страховой на указанную дату.
//
// Параметры:
//  ВидПолиса	 - СправочникСсылка.СтраховыеПолисы, СправочникСсылка.ВидыПолисов - полис или вид полиса.
//  Организация	 - СправочникСсылка.Организация, СправочникСсылка.Филиал - организация или филиал организации.
//  Дата		 - Дата	 - дата действия договора
// 
// Возвращаемое значение:
//  СправочникСсылка.СоглашенияСтрахования - действующий договор.
//
Функция ДоговорСоСтраховойПолиса(ВидПолиса, Организация, Дата = Неопределено) Экспорт 
	
	пВидПолиса	 = ?(ТипЗнч(ВидПолиса) = Тип("СправочникСсылка.СтраховыеПолисы"), ВидПолиса.ВидПолиса, ВидПолиса);
	пОрганизация = ?(ТипЗнч(Организация) = Тип("СправочникСсылка.Филиалы"), Организация.Организация, Организация);
	пДата		 = НачалоДня(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	
	// Перебираем договоры вида полиса
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидПолиса", ВидПолиса);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыПолисовДоговоры.Договор КАК Договор,
	|	ВидыПолисовДоговоры.Договор.Организация КАК Организация,
	|	ВидыПолисовДоговоры.Договор.ДатаНачала КАК ДатаНачала,
	|	ВидыПолисовДоговоры.Договор.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	Справочник.ВидыПолисов.Договоры КАК ВидыПолисовДоговоры
	|ГДЕ
	|	ВидыПолисовДоговоры.Ссылка = &ВидПолиса"
	;
	
	Договоры = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаДоговор Из Договоры Цикл
		
		Если СтрокаДоговор.Организация = пОрганизация // Организация
			И (Не ЗначениеЗаполнено(СтрокаДоговор.ДатаНачала)	 Или СтрокаДоговор.ДатаНачала	 <= пДата) // Дата начала.
			И (Не ЗначениеЗаполнено(СтрокаДоговор.ДатаОкончания) Или СтрокаДоговор.ДатаОкончания >= пДата) // Дата окончания.
		Тогда
			Возврат СтрокаДоговор.Договор;	
		КонецЕсли;
	КонецЦикла;
	
	Возврат Справочники.СоглашенияСтрахования.ПустаяСсылка();
	
КонецФункции

// Сообщает об ошибке нет договора со страховой
//
// Параметры:
//  ВидПолиса	 - СправочникСсылка.ВидыПолисов	 - вид полиса.
//  Организация	 - СправочникСсылка.Организация	 - организация
//  Дата		 - Дата	 - дата актуальности сообщения.
//  Отказ		 - Булево	 - признак отказа.
//
Процедура СообщитьОбОшибкеНетДоговораСоСтраховой(ВидПолиса, Организация, Дата, Отказ = Ложь) Экспорт
	
	ТекстСообщения = "Организация %1 не имеет актуального договора на %3 в виде полиса %2";
	ТекстСообщения = СтрШаблон(ТекстСообщения, Организация, ВидПолиса, Формат(Дата, "ДЛФ=DD"));
	
	ОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(ТекстСообщения); // Не критична для оперативной деятельности, но требует учета.
	// ОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(ТекстСообщения, Отказ);
	
КонецПроцедуры

// Формирует представление полиса для печатых форм.
//
// Параметры:
//  ДанныеПолиса - СправочникСсылка.Полисы - структура с реквизитами полиса.
// 
// Возвращаемое значение:
//  Строка.
//
Функция ПредставлениеПолисаДляПечати(ДанныеПолиса) Экспорт
	
	Перем Представление;
	
	Если ЗначениеЗаполнено(ДанныеПолиса.Серия) Тогда
		Представление = СокрЛП(ДанныеПолиса.Серия);
		Если ЗначениеЗаполнено(ДанныеПолиса.Номер) Тогда
			Представление = Представление + " № " + СокрЛП(ДанныеПолиса.Номер);
		КонецЕсли;
	Иначе
		Представление = ДанныеПолиса.Номер;
	КонецЕсли;
	
	Возврат СокрЛП(Представление);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСотрудникаСтрокиПродажи(Документ, СтрокаТЧ, ИмяТЧ)
	
	Результат = Справочники.Сотрудники.ПустаяСсылка();
	
	ИмяПоляСотрудник = "Сотрудник";
	
	Если ИмяТЧ = "Работы" Или ИмяТЧ = "Товары" Тогда
		ИмяПоляСотрудник = "Сотрудник";
	ИначеЕсли ИмяТЧ = "Материалы" Тогда
		Если ЗначениеЗаполнено(СтрокаТЧ.КлючСтрокиРаботы) Тогда
			СтрокаРаботы = Документ.Работы.Найти(СтрокаТЧ.КлючСтрокиРаботы, "КлючСтроки");
			Если СтрокаРаботы <> Неопределено Тогда
				Возврат ?(ЗначениеЗаполнено(СтрокаРаботы.Сотрудник), СтрокаРаботы.Сотрудник, Документ.Сотрудник);
			Иначе
				Возврат Документ.Сотрудник;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ?(ЗначениеЗаполнено(СтрокаТЧ[ИмяПоляСотрудник]), СтрокаТЧ[ИмяПоляСотрудник], Документ.Сотрудник);
	
КонецФункции

#КонецОбласти