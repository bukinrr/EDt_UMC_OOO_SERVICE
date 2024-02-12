#Область ПрограммныйИнтерфейс

// Найти контактную информацию
//
// Параметры:
//  СсылкаНаОбъект				 - СправочникСсылка - клиент, сотрудник
//  ТипКонтактнойИнформации		 - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип
//  ВидыКонтактнойИнформации	 - СправочникСсылка.ВидыКонтактнойИнформации - вид
//  ВернутьПервое				 - Булево - вернуть первое
//  АнализЗаконногоПредставителя - Булево - анализ законного представителя
// 
// Возвращаемое значение:
//  Строка, Массив - представление данных.
//
Функция НайтиКонтактнуюИнформацию(СсылкаНаОбъект, ТипКонтактнойИнформации = Неопределено, ВидыКонтактнойИнформации = Неопределено, ВернутьПервое = Истина, АнализЗаконногоПредставителя = Истина) Экспорт 
	
	Если ТипКонтактнойИнформации = Неопределено Тогда 
		ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон;
	КонецЕсли;
	
	мсВидыКонтактнойИнформации = Неопределено;
	ТипВидовКИ = ТипЗнч(ВидыКонтактнойИнформации);
	Если ТипВидовКИ = Тип("Массив") Или ТипВидовКИ = Тип("СписокЗначений") Тогда
		мсВидыКонтактнойИнформации = ВидыКонтактнойИнформации;
	ИначеЕсли ТипВидовКИ = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда 
		мсВидыКонтактнойИнформации = Новый Массив;
		мсВидыКонтактнойИнформации.Добавить(ВидыКонтактнойИнформации);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление,
	|	ВЫБОР
	|		КОГДА КонтактнаяИнформация.ЗначениеПоУмолчанию
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ПриоритетОсновнойКИ,	
	|	ВЫБОР
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотовый)
	|			ТОГДА 0
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонРабочий)
	|			ТОГДА 1
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонДомашний)
	|			ТОГДА 2
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресЮридический)
	|			ТОГДА 3
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресФактический)
	|			ТОГДА 4
	|		ИНАЧЕ 5
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(КонтактнаяИнформация.Объект) = &ТипТаблицы
	|	И КонтактнаяИнформация.Объект = &Объект
	|	И КонтактнаяИнформация.Тип = &Тип
	|	И (&НеОтбиратьПоВиду
	|			ИЛИ КонтактнаяИнформация.Вид В (&Вид))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриоритетОсновнойКИ,
	|	Приоритет";
	Запрос.УстановитьПараметр("Объект", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("НеОтбиратьПоВиду", (мсВидыКонтактнойИнформации = Неопределено));
	Запрос.УстановитьПараметр("Вид", мсВидыКонтактнойИнформации);
	Запрос.УстановитьПараметр("Тип", ТипКонтактнойИнформации);
	Запрос.УстановитьПараметр("ТипТаблицы", ТипЗнч(СсылкаНаОбъект));
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		// Если это клиент, получаем КИ его законного представителя
		Если АнализЗаконногоПредставителя
			И ТипЗнч(СсылкаНаОбъект) = Тип("СправочникСсылка.Клиенты")
		Тогда
			Возврат НайтиКонтактнуюИнформациюЗаконогоПредставителя(СсылкаНаОбъект, ТипКонтактнойИнформации, ВидыКонтактнойИнформации, ВернутьПервое);
		Иначе
			Возврат ?(ВернутьПервое, Неопределено, Новый Массив);
		КонецЕсли;
		
	Иначе
		Если ВернутьПервое Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Возврат Выборка.Представление;
		Иначе
			Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Представление");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Возвращаемое значение: Массив или Строка, или Неопределено
Функция НайтиКонтактнуюИнформациюЗаконогоПредставителя(Клиент, ТипКонтактнойИнформации, ВидыКонтактнойИнформации, ВернутьПервое)
	
	Результат = ?(ВернутьПервое, Неопределено, Новый Массив);
	
	ЗаконныйПредставитель = Клиент.ЗаконныйПредставитель;
	Если ЗначениеЗаполнено(ЗаконныйПредставитель) Тогда
		Если ТипЗнч(ЗаконныйПредставитель) = Тип("СправочникСсылка.Клиенты") Тогда
			Результат = НайтиКонтактнуюИнформацию(ЗаконныйПредставитель, ТипКонтактнойИнформации, ВидыКонтактнойИнформации, ВернутьПервое, Ложь);
			
		ИначеЕсли ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			Если ЗначениеЗаполнено(Клиент.ЗаконныйПредставительТелефон) Тогда
				Телефон = Клиент.ЗаконныйПредставительТелефон;
			Иначе
				Телефон = Неопределено;
			КонецЕсли;
				
			Если ВернутьПервое Тогда
				Результат = Телефон;
			Иначе
				Результат = Новый Массив;
				Если ЗначениеЗаполнено(Телефон) Тогда
					Результат.Добавить(Телефон);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Найти объекты по номеру телефона.
//
// Параметры:
//  НомерТелефона		 - Строка - номер телефона 
//  ТипОбъекта			 - Тип - тип объекта
//  ИсключатьПомеченные	 - Булево - исключать помеченные
// 
// Возвращаемое значение:
//  Массив - контакты.
//
Функция НайтиОбъектыПоНомеруТелефона(НомерТелефона, ТипОбъекта = Неопределено, ИсключатьПомеченные = Ложь) Экспорт
	
	Контакты = Новый Массив;
	
	ИмяТаблицы = "";
	Если ТипОбъекта <> Неопределено Тогда 
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипОбъекта);
		Если МетаданныеОбъекта <> Неопределено Тогда 
			ИмяТаблицы = МетаданныеОбъекта.ПолноеИмя();
		КонецЕсли;
	КонецЕсли;
	
	НормализованныйНомер = КонтактнаяИнформацияКлиентСерверПереопределяемый.НормализоватьСотовыйТелефон(НомерТелефона);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Объект,
	|	КонтактнаяИнформация.Представление КАК НомерТелефона
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	//%УсловиеПоТипуОбъекта%
	|	КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|	И (НЕ &ИсключатьПомеченные
	|		ИЛИ НЕ КонтактнаяИнформация.Объект.ПометкаУдаления)
	|	И КонтактнаяИнформация.Представление ПОДОБНО &НомерТелефона";
	Если Не ПустаяСтрока(ИмяТаблицы) Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%УсловиеПоТипуОбъекта%", "КонтактнаяИнформация.Объект ССЫЛКА " + ИмяТаблицы + " И");
	КонецЕсли;
	Запрос.УстановитьПараметр("ИсключатьПомеченные", ИсключатьПомеченные);
	Запрос.УстановитьПараметр("НомерТелефона", "%" + НормализованныйНомер.ДляПоиска + "%");
	
	Результат = Запрос.Выполнить();
	
	Найден = Ложь;
	Если Результат.Пустой() Тогда
		КлиентСсылка = Справочники.Клиенты.ПустаяСсылка();
	Иначе
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НомерЦифр = КонтактнаяИнформацияКлиентСерверПереопределяемый.НормализоватьСотовыйТелефон(Выборка.НомерТелефона, Ложь); 
			Контакты.Добавить(Новый Структура("Объект, Номер, НомерЦифровой", Выборка.Объект, Выборка.НомерТелефона, НомерЦифр));
		КонецЦикла;
	КонецЕсли;
	
	Возврат Контакты;
	
КонецФункции

// Получить виды контактной информации для вида метаданных.
//
// Параметры:
//  ИмяМетаданных			 - Имя - имя справочника.
//  ТипКонтактнойИнформации	 - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип.
// 
// Возвращаемое значение:
//  Массив - виды.
//
Функция ПолучитьВидыКонтактнойИнформацииМетаданных(ИмяМетаданных, ТипКонтактнойИнформации = Неопределено) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НазначениеКонтактнойИнформации.Вид
	|ИЗ
	|	РегистрСведений.НазначениеКонтактнойИнформации КАК НазначениеКонтактнойИнформации
	|ГДЕ
	|	НазначениеКонтактнойИнформации.ИмяМетаданных = &ИмяМетаданных
	|	И (&Тип = НЕОПРЕДЕЛЕНО
	|			ИЛИ НазначениеКонтактнойИнформации.Вид.Тип = &Тип)";
	Запрос.УстановитьПараметр("ИмяМетаданных", ИмяМетаданных);
	Запрос.УстановитьПараметр("Тип", ТипКонтактнойИнформации);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Вид");
	
КонецФункции

// Записать номер телефона
//
// Параметры:
//  СсылкаНаОбъект			 - СправочникСсылка							 - клиент, сотрудник
//  НомерТелефона			 - Строка									 - номер телефона
//  ВидКонтактнойИнформации	 - СправочникСсылка.ВидыКонтактнойИнформации - вид.
//  ВводПоМаске				 - Булево									 - не используется. Параметр оставлен для совместимости с возможными старыми сторонними интеграциями.
//
Процедура ЗаписатьНомерТелефона(СсылкаНаОбъект, НомерТелефона, ВидКонтактнойИнформации = Неопределено, ВводПоМаске = Ложь) Экспорт
	
	запКИ = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
	запКИ.Объект		= СсылкаНаОбъект;
	запКИ.Тип			= Перечисления.ТипыКонтактнойИнформации.Телефон;
	запКИ.Вид			= ?(ВидКонтактнойИнформации = Неопределено, Справочники.ВидыКонтактнойИнформации.ТелефонСотовый, ВидКонтактнойИнформации);
	запКИ.Поле3			= НомерТелефона;
	запКИ.Представление	= НомерТелефона;
	запКИ.Записать();
	
КонецПроцедуры

// Получить все телефоны владельца
//
// Параметры:
//  Владелец - СправочникСсылка - владелец информации.
// 
// Возвращаемое значение:
//  Массив - контактная информация.
//
Функция ПолучитьТелефоныВладельца(Владелец) Экспорт
	
	ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон;
	
	ИмяТаблицы = ОбщегоНазначения.ИмяТаблицыПоСсылке(Владелец);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление,
	|	КонтактнаяИнформация.Вид,
	|	КонтактнаяИнформация.ЗначениеПоУмолчанию
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект ССЫЛКА " + ИмяТаблицы +
	"
	|	И КонтактнаяИнформация.Объект = &Объект
	|	И КонтактнаяИнформация.Тип = &Тип
	|
	|УПОРЯДОЧИТЬ ПО
	|	Вид";
	Запрос.УстановитьПараметр("Объект", Владелец);
	Запрос.УстановитьПараметр("Тип", ТипКонтактнойИнформации);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Новый Массив;
	Иначе
		Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат.Выгрузить());
	КонецЕсли;
	
КонецФункции

// Телефоны владельца со служебными полями.
//
// Параметры:
//  Владелец - СправочникСсылка - владелец информации.
//  Вид		 - СправочникСсылка.ВидыКонтактнойИнформации - вид.
// 
// Возвращаемое значение:
//  ТаблицаЗначений.
//
Функция ПолучитьТелефоныВладельцаСоСлужебнымиПолями(Владелец, Вид = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление,
	|	ВЫБОР
	|		КОГДА КонтактнаяИнформация.ЗначениеПоУмолчанию
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ПриоритетОсновнойКИ,
	|	ВЫБОР
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотовый)
	|			ТОГДА 0
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонРабочий)
	|			ТОГДА 1
	|		КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонДомашний)
	|			ТОГДА 2
	|		ИНАЧЕ 5
	|	КОНЕЦ КАК Приоритет,
	|	КонтактнаяИнформация.Поле1,
	|	КонтактнаяИнформация.Поле2,
	|	КонтактнаяИнформация.Поле3,
	|	КонтактнаяИнформация.Поле4
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект = &Объект
	|	И КонтактнаяИнформация.Тип = &Тип
	|	И (&НеОтбиратьПоВиду
	|			ИЛИ КонтактнаяИнформация.Вид В (&Вид))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриоритетОсновнойКИ,
	|	Приоритет";
	Запрос.УстановитьПараметр("Объект", Владелец);
	Запрос.УстановитьПараметр("НеОтбиратьПоВиду", (Вид = Неопределено));
	Запрос.УстановитьПараметр("Вид", Вид);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Стандартные домены электронной почты по коду страны. Можно расширять.
//
// Параметры:
//  КодСтраны	 - 	 - 
// 
// Возвращаемое значение:
//  Массив - из Строка с именами доменов.
//
Функция СтандартныеДоменыПочты(КодСтраны = Неопределено) Экспорт
	
	Если КодСтраны = Неопределено Тогда
		КодСтраны = ДоменВерхнегоУровняОсновнойСтраны();
	КонецЕсли;
	
	Домены = Новый Массив;
	Домены.Добавить("gmail.com");
	
	Если НРег(КодСтраны) = "ru"
		Или НРег(КодСтраны) = "kz"
	Тогда
		Домены.Добавить("yandex."	 + КодСтраны);
		Домены.Добавить("mail."		 + КодСтраны);
		Домены.Добавить("bk."		 + КодСтраны);
		Домены.Добавить("inbox."	 + КодСтраны);
		Домены.Добавить("list."		 + КодСтраны);
		Домены.Добавить("rambler."	 + КодСтраны);
	КонецЕсли;
	
	Домены.Добавить("yahoo.com");
	Домены.Добавить("outlook.com");
	
	Возврат Домены;
	
КонецФункции

// Домен верхнего уровня основной страны.
// 
// Возвращаемое значение:
//  Строка - домен электронной почты, например "ru", "kz", "com".
//
Функция ДоменВерхнегоУровняОсновнойСтраны() Экспорт
	
	ОсновнаяСтрана = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ОсновнаяСтрана");
	Если ОсновнаяСтрана = Справочники.СтраныМира.Россия Тогда
		Возврат "ru";
	Иначе
		Возврат ОсновнаяСтрана.КодАльфа2;
	КонецЕсли;
	
КонецФункции

// Читает экземплар контактной информации.
//
// Параметры:
//  Объект	 - СправочникСсылка - клиент, сотрудник 
//  Тип		 - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип
//  Вид		 - СправочникСсылка.ВидыКонтактнойИнформации - вид .
// 
// Возвращаемое значение:
//  Структура - структура записи. 
//
Функция ДанныеЗаписиКИ(Объект, Тип, Вид) Экспорт
	
	Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Запись.Тип = Тип;
	Запись.Вид = Вид;
	
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		СтруктураЗаписи = КонтактнаяИнформацияКлиентСерверПереопределяемый.ПолучитьСтруктуруПолейКонтактнойИнформации();
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
		
		Возврат СтруктураЗаписи;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Записывает позицию контактной информации.
//
// Параметры:
//  СтруктураЗаписи	 - Структура	 - Структура с полями для записи в регистр контактной информации.
//
Процедура ЗаписатьКонтактнуюИнформацию(СтруктураЗаписи) Экспорт
	
	Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
	
	ЗаполнитьЗначенияСвойств(Запись, СтруктураЗаписи); 
	
	Запись.Записать();
	
КонецПроцедуры

// Обновить контактную информацию на форме, размещенную в виде таблицы значений.
//
// Параметры:
//  КонтактнаяИнформация - ДанныеФормыКоллекция	 	- Таблица с контактной информацией формы
//  Объект				 - СправочникСсылка.Клиенты	- Объект, для которого обновляется КИ  
//
Процедура ЗаполнитьТаблицуКИОбъекта(КонтактнаяИнформация, Объект) Экспорт
	
	КонтактнаяИнформация.Очистить();
	
	Картинки = КартинкиТиповКИ();
	
	// Заполняем КИ по назначеням видов КИ
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяМетаданных", Объект.Метаданные().Имя);
	Запрос.Текст = "ВЫБРАТЬ
	               |	НазначениеКонтактнойИнформации.Вид.Тип КАК Тип,
	               |	НазначениеКонтактнойИнформации.Вид КАК Вид,
	               |	"""" КАК Представление,
	               |	"""" КАК Комментарий,
	               |	НазначениеКонтактнойИнформации.Вид.Тип.Порядок КАК ТипПорядок,
	               |	ЛОЖЬ КАК ЗначениеПоУмолчанию
	               |ИЗ
	               |	РегистрСведений.НазначениеКонтактнойИнформации КАК НазначениеКонтактнойИнформации
	               |ГДЕ
	               |	НазначениеКонтактнойИнформации.ИмяМетаданных = &ИмяМетаданных";
	
	Если Не Объект.Пустая() Тогда
		
		Запрос.Текст = Запрос.Текст + Символы.ПС + "ОБЪЕДИНИТЬ" + Символы.ПС;
		
		Запрос.Текст = Запрос.Текст + 
		// Заполняем КИ по регистру
		"ВЫБРАТЬ
       |	КонтактнаяИнформация.Тип КАК Тип,
       |	КонтактнаяИнформация.Вид КАК Вид,
       |	КонтактнаяИнформация.Представление КАК Представление,
       |	ПОДСТРОКА(КонтактнаяИнформация.Комментарий,1,1000) КАК Комментарий,
       |	КонтактнаяИнформация.Тип.Порядок КАК ТипПорядок,
	   |	КонтактнаяИнформация.ЗначениеПоУмолчанию КАК ЗначениеПоУмолчанию
       |ИЗ
       |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
       |ГДЕ
       |	КонтактнаяИнформация.Объект = &Объект";
		
		Запрос.УстановитьПараметр("Объект", Объект);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДобавитьСтроку = Ложь;
		СуществующиеСтроки = КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", Выборка.Вид)); 
		
		Если СуществующиеСтроки.Количество() = 0 Тогда
			ДобавитьСтроку = Истина;		
		ИначеЕсли СуществующиеСтроки[0].Представление = "" Тогда
			КонтактнаяИнформация.Удалить(СуществующиеСтроки[0]);
			ДобавитьСтроку = Истина;
		КонецЕсли;
		
		Если ДобавитьСтроку Тогда
			СтрокаКИ = КонтактнаяИнформация.Добавить();
			СтрокаКИ.Тип = Выборка.Тип;
			СтрокаКИ.Вид = Выборка.Вид;
			СтрокаКИ.ЗначениеПоУмолчанию = Выборка.ЗначениеПоУмолчанию;
			СтрокаКИ.МаскаВводаТелефонногоНомера = Выборка.Вид.МаскаВводаТелефонногоНомера;
			СтрокаКИ.РедактируетсяВФормеОбъекта = Выборка.Вид.РедактируетсяВФормеОбъекта;
			СтрокаКИ.Представление = Выборка.Представление;
			СтрокаКИ.Комментарий = Выборка.Комментарий;
			СтрокаКИ.КартинкаТипа = Картинки.Получить(Строка(Выборка.Тип));
			СтрокаКИ.ТипПорядок = Выборка.ТипПорядок;
			СтрокаКИ.Объект = Объект;
		КонецЕсли;
	КонецЦикла;
	
	КонтактнаяИнформация.Сортировать("ТипПорядок, Вид");
	
КонецПроцедуры

// Соответствие типов контактной информации и их картинок.
// 
// Возвращаемое значение:
//  Соответствие - Соответствие, где Ключ - тип - Строка; Значение - Картинка.
//
Функция КартинкиТиповКИ()
	
	Картинки = Новый Соответствие;
	Картинки.Вставить("Адрес", БиблиотекаКартинок.КонтактнаяИнформацияАдрес);
	Картинки.Вставить("Телефон",БиблиотекаКартинок.КонтактнаяИнформацияТелефон);		
	Картинки.Вставить("Номер ICQ",БиблиотекаКартинок.КонтактнаяИнформацияICQ);						
	Картинки.Вставить("E-Mail",БиблиотекаКартинок.КонтактнаяИнформацияЭлектроннаяПочта);										
	Картинки.Вставить("Веб-страница",БиблиотекаКартинок.КонтактнаяИнформацияВебСтраница);
	Картинки.Вставить("Skype",БиблиотекаКартинок.Skype);
	Картинки.Вставить("Другое",БиблиотекаКартинок.КонтактнаяИнформацияДругое);				
	
	Возврат Картинки;
	
КонецФункции

// Преобразует строку в адрес и записывает его в регистр
//
// Параметры:
//  СтрокаАдреса - Строка		 - Адрес
//  Объект		 - СправочникСсылка	 - ссылка на владельца КИ.
//  Вид			 - СправочникСсылка.ВидыКонтактнойИнформации - вид адреса. По умолчанию - АдресЮридический.
//
Процедура РазобратьИЗаписатьАдрес(СтрокаАдреса, Объект, Вид = Неопределено, Филиал = Неопределено) Экспорт

	ПоляАдресаФилиала = ПолучитьПоляАдресаФилиала(Филиал);
	МассивПолейАдреса = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СтрокаАдреса,",");
	ЗаписьКИ = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
	
	Если ПоляАдресаФилиала <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЗаписьКИ,ПоляАдресаФилиала);
	КонецЕсли;
	
	ЗаписьКИ.Объект	= Объект;
	ЗаписьКИ.Тип	= Перечисления.ТипыКонтактнойИнформации.Адрес;
	ЗаписьКИ.Вид	= ?(Вид = Неопределено, Справочники.ВидыКонтактнойИнформации.АдресЮридический, Вид);
	ЗаписьКИ.КраткоеПредставление = Истина;
	
	КоличествоПолей = МассивПолейАдреса.Количество();

	КоличествоНомеров = 0;
	Счетчик = 1;
	Пока Счетчик <= КоличествоПолей И Счетчик <= 3 Цикл
		Если ЭтоНомерВАдресе(МассивПолейАдреса[КоличествоПолей - Счетчик]) Тогда
			КоличествоНомеров = Счетчик;	
		КонецЕсли; 
		Счетчик = Счетчик + 1
	КонецЦикла;
	
	КоличествоПолейДоДома = КоличествоПолей - КоличествоНомеров;
	ОтсутствуетРегион = (КоличествоПолейДоДома <= 2);
	ОтсутствуетРайон = (КоличествоПолейДоДома <= 3);
	ОтсутствуетГород = (КоличествоПолейДоДома <= 1 Или КоличествоПолейДоДома = 3);
	ОтсутствуетНасПункт = (КоличествоПолейДоДома <= 2 Или КоличествоПолейДоДома = 4);
	ОтсутствуетУлица = (КоличествоПолейДоДома = 0);
	ОтсутствуетКорпус = (КоличествоНомеров < 3);	
	
	ДанныеАдреса = Новый Структура();
	Сч = 1;
	Для Каждого ПолеАдреса Из МассивПолейАдреса Цикл	
		Пока Истина Цикл
			Сч = Сч + 1;
			Если Сч = 2 И ОтсутствуетРегион Тогда
				Продолжить;
			ИначеЕсли Сч = 3 И ОтсутствуетРайон Тогда
				Продолжить;
			ИначеЕсли Сч = 4 И ОтсутствуетГород Тогда
				Продолжить;
			ИначеЕсли Сч = 5 И ОтсутствуетНасПункт Тогда
				Продолжить;	
			ИначеЕсли Сч = 6 И ОтсутствуетУлица Тогда
				Продолжить;	
			ИначеЕсли Сч = 8 И ОтсутствуетКорпус Тогда
				Продолжить;		
			КонецЕсли; 
			Прервать;
		КонецЦикла; 
				
		Если ЗначениеЗаполнено(ПолеАдреса) Тогда
			Если Сч = 7 Тогда
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"дом №", "");
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"Дом №", "");
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"дом", ""); 
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"Дом", "");
			ИначеЕсли Сч = 8 Тогда
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"Корпус", "");
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"корпус", "");
			ИначеЕсли Сч = 9 Тогда
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"Квартира", "");
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"квартира", "");
				ПолеАдреса = СтрЗаменить(ПолеАдреса,"кв.", "");	
			КонецЕсли;
			ПолеАдреса = СокрЛП(ПолеАдреса);
			ДанныеАдреса.Вставить("Поле" + Сч,ПолеАдреса);
		КонецЕсли;
	КонецЦикла;
	ЗаполнитьЗначенияСвойств(ЗаписьКИ,ДанныеАдреса);
	ЗаписьКИ.Представление = КонтактнаяИнформацияСервер.ПолучитьПредставлениеАдреса(ЗаписьКИ);
	ЗаписьКИ.Записать();
	КонтактнаяИнформацияСервер.ОбновитьКИПодФорматФИАС(Объект, ЗаписьКИ.Вид);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

Функция ЭтоНомерВАдресе(Поле)
	
	КоличествоЧисел = 0;
	ДлинаСтроки = СтрДлина(Поле);
	КоличествоПробелов = 0;
	Для Сч = 1 По ДлинаСтроки Цикл
		Символ = Сред(Поле, Сч, 1);
		Если Символ = " " Тогда
			КоличествоПробелов = КоличествоПробелов + 1;	
		Иначе
			Попытка
			ЭтоЧисло = Число(Символ);
			КоличествоЧисел = КоличествоЧисел + 1;     
			Исключение
			КонецПопытки;	
		КонецЕсли; 		
	КонецЦикла;  
	
	Возврат КоличествоЧисел >= Цел((ДлинаСтроки-КоличествоПробелов)/2);
	
КонецФункции

Функция ПолучитьПоляАдресаФилиала(Знач Филиал = Неопределено)
	
	Если Филиал = Неопределено Тогда
		Филиал = УправлениеНастройками.ПолучитьФилиалПоУмолчаниюПользователя();
	КонецЕсли;
	
	АдресаФилиалов = ОбщегоНазначенияСервер.ПолучитьАдресаФилиалов();
	Для Каждого АдресФилиала Из АдресаФилиалов Цикл
		Если АдресФилиала.Объект = Филиал Тогда
			Возврат АдресФилиала;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

