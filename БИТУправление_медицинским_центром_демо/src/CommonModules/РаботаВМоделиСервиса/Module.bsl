#Область ПрограммныйИнтерфейс

// Возвращает имя общего реквизита, который является разделителем основных данных.
//
// Возвращаемое значение:
//   Строка - имя общего реквизита, который является разделителем основных данных.
//
Функция РазделительОсновныхДанных() Экспорт
	
	Возврат Неопределено;
	// Возврат Метаданные.ОбщиеРеквизиты.ОбластьДанныхОсновныеДанные.Имя;
	
КонецФункции

#КонецОбласти

// Возвращает значение разделителя текущей области данных.
// В случае если значение не установлено выдается ошибка.
// 
// Возвращаемое значение: 
// Тип значения разделителя.
// Значение разделителя текущей области данных. 
// 
Функция ЗначениеРазделителяСеанса() Экспорт
	
	Возврат 0;
	
КонецФункции

// Работа с параметрами ИБ

// Добавляет описание параметра по имени константы в таблицу параметров.
// Возвращает добавленный параметр.
//
// Параметры: 
// ТаблицаПараметров - Таблица значений - таблица описания параметров ИБ
// ИмяКонстанты - Строка - имя константы, которую необходимо добавить в
// параметры ИБ
//
// Возвращаемое значение: 
// Строка таблицы значений.
// Строка содержащая описание добавленного параметра. 
// 
Функция ДобавитьКонстантуВТаблицуПараметровИБ(Знач ТаблицаПараметров, Знач ИмяКонстанты) Экспорт
	
	МетаданныеКонстанты = Метаданные.Константы[ИмяКонстанты];
	
	СтрокаПараметра = ТаблицаПараметров.Добавить();
	СтрокаПараметра.Имя = МетаданныеКонстанты.Имя;
	СтрокаПараметра.Описание = МетаданныеКонстанты.Представление();
	СтрокаПараметра.Тип = МетаданныеКонстанты.Тип;
	
	Возврат СтрокаПараметра;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////
// Получение объектов прокси для подключений к Web-сервисам.
//

// Получает объект WSПрокси Web-сервиса передачи файлов.
//
// Параметры:
// ПараметрыПодключения - Структура:
//							- URL - Строка - URL сервиса. Обязательно должно присутствовать и быть заполненным.
//							- UserName - Строка - Имя пользователя сервиса.
//							- Password - Строка - Пароль пользователя сервиса.
// БазовоеИмяСервиса - Строка - Имя базовой версии Web-сервиса. Примеры: "FilesTransfer", "ManageAgent". 
// ВерсияИнтерфейса - Строка - Номер версии сервиса, к которому надо получить доступ.
//
// Возвращаемое значение:
// WSПрокси.
//
Функция ПолучитьПроксиДляПодключенияКСервису(Знач ПараметрыПодключения, Знач БазовоеИмяСервиса, Знач ВерсияИнтерфейса) Экспорт
	
	Если Не ПараметрыПодключения.Свойство("URL") 
		Или Не ЗначениеЗаполнено(ПараметрыПодключения.URL) Тогда
		
		ВызватьИсключение(НСтр("ru = 'Не задан адрес агента сервиса.'"));
	КонецЕсли;
	
	Если ПараметрыПодключения.Свойство("UserName")
		И ЗначениеЗаполнено(ПараметрыПодключения.UserName) Тогда
		
		ИмяПользователя = ПараметрыПодключения.UserName;
		ПарольПользователя = ПараметрыПодключения.Password;
	Иначе
		ИмяПользователя = Неопределено;
		ПарольПользователя = Неопределено;
	КонецЕсли;
	
	Если ВерсияИнтерфейса = Неопределено Или ВерсияИнтерфейса = "1.0.1.1" Тогда // 1-я версия.
		ИмяСервиса = БазовоеИмяСервиса;
	Иначе // Версии 2 и выше.
		ИмяСервиса = БазовоеИмяСервиса + "_" + СтрЗаменить(ВерсияИнтерфейса, ".", "_");
	КонецЕсли;
	
	// Получить прокси работы с файлами.
	
	АдресСервиса = ПараметрыПодключения.URL + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/ws/%1?wsdl", ИмяСервиса);
	
	Возврат ОбщегоНазначенияПовтИсп.ПолучитьWSПрокси(АдресСервиса, 
		"http://www.1c.ru/SaaS/1.0/WS", ИмяСервиса, , ИмяПользователя, ПарольПользователя);
		
КонецФункции

/////////////////////////////////////////////////////////////////////////////////
// Сериализация
//

Функция ЗаписатьЗначениеВСтроку(Знач Значение)
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	
	Если ТипЗнч(Значение) = Тип("ОбъектXDTO") Тогда
		ФабрикаXDTO.ЗаписатьXML(Запись, Значение, , , , НазначениеТипаXML.Явное);
	Иначе
		СериализаторXDTO.ЗаписатьXML(Запись, Значение, НазначениеТипаXML.Явное);
	КонецЕсли;
	
	Возврат Запись.Закрыть();
		
КонецФункции

// Отражает, является ли данный тип сериализуемым.
//
// Параметры:
// СтруктурныйТип - Тип.
//
// Возвращаемое значение:
// Булево.
//
Функция СериализуемыйСтруктурныйТип(СтруктурныйТип);
	
	МассивСериализуемыхТипов = РаботаВМоделиСервисаПовтИсп.СериализуемыеСтруктурныеТипы();
	
	Для Каждого СериализуемыйТип Из МассивСериализуемыхТипов Цикл 
		Если СтруктурныйТип = СериализуемыйТип Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
		
КонецФункции

// Сериализует объект структурного типа.
//
// Параметры:
// ЗначениеСтруктурногоТипа - Массив, Структура, Соответствие или их фиксированные аналоги.
//
// Возвращаемое значение:
// Строка - Сериализованное значение объекта структурного типа.
//
Функция ЗаписатьСтруктурныйОбъектXDTOВСтроку(Знач ЗначениеСтруктурногоТипа) Экспорт
	
	ОбъектXDTO = СтруктурныйОбъектВОбъектXDTO(ЗначениеСтруктурногоТипа);
	
	Возврат ЗаписатьЗначениеВСтроку(ОбъектXDTO);
	
КонецФункции

// Получает XDTO-представление объекта структурного типа.
//
// Параметры:
// ЗначениеСтруктурногоТипа - Массив, Структура, Соответствие или их фиксированные аналоги.
//
// Возвращаемое значение:
// Структурный объект XDTO - XDTO-представление объекта структурного типа.
//
Функция СтруктурныйОбъектВОбъектXDTO(Знач ЗначениеСтруктурногоТипа)
	
	СтруктурныйТип = ТипЗнч(ЗначениеСтруктурногоТипа);
	
	Если Не СериализуемыйСтруктурныйТип(СтруктурныйТип) Тогда
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Тип %1 не является структурным или его сериализация в настоящее время не поддерживается.'"),
			СтруктурныйТип);
		ВызватьИсключение(СообщениеОбОшибке);
	КонецЕсли;
	
	XMLТипЗначения = СериализаторXDTO.XMLТипЗнч(ЗначениеСтруктурногоТипа);
	ТипСтруктура = ФабрикаXDTO.Тип(XMLТипЗначения);
	СтруктураXDTO = ФабрикаXDTO.Создать(ТипСтруктура);
	
	// Перебор допустимых структурных типов.
	
	Если СтруктурныйТип = Тип("Структура") Или СтруктурныйТип = Тип("ФиксированнаяСтруктура") Тогда
		
		ТипСвойство = ТипСтруктура.Свойства.Получить("Property").Тип;
		
		Для Каждого КлючИЗначение Из ЗначениеСтруктурногоТипа Цикл
			Свойство = ФабрикаXDTO.Создать(ТипСвойство);
			Свойство.name = КлючИЗначение.Ключ;
			Свойство.Value = ЗначениеТипаВЗначениеXDTO(КлючИЗначение.Значение);
			СтруктураXDTO.Property.Добавить(Свойство);
		КонецЦикла;
		
	ИначеЕсли СтруктурныйТип = Тип("Массив") Или СтруктурныйТип = Тип("ФиксированныйМассив") Тогда 
		
		Для Каждого ЗначениеЭлемента Из ЗначениеСтруктурногоТипа Цикл
			СтруктураXDTO.Value.Добавить(ЗначениеТипаВЗначениеXDTO(ЗначениеЭлемента));
		КонецЦикла;
		
	ИначеЕсли СтруктурныйТип = Тип("Соответствие") Или СтруктурныйТип = Тип("ФиксированноеСоответствие") Тогда
		
		Для Каждого КлючИЗначение Из ЗначениеСтруктурногоТипа Цикл
			СтруктураXDTO.pair.Добавить(СтруктурныйОбъектВОбъектXDTO(КлючИЗначение));
		КонецЦикла;
	
	ИначеЕсли СтруктурныйТип = Тип("КлючИЗначение")	Тогда	
		
		СтруктураXDTO.key = ЗначениеТипаВЗначениеXDTO(ЗначениеСтруктурногоТипа.Ключ);
		СтруктураXDTO.value = ЗначениеТипаВЗначениеXDTO(ЗначениеСтруктурногоТипа.Значение);
		
	ИначеЕсли СтруктурныйТип = Тип("ТаблицаЗначений") Тогда
		
		XDTOТипКолонкаТЗ = ТипСтруктура.Свойства.Получить("column").Тип;
		
		Для Каждого Колонка Из ЗначениеСтруктурногоТипа.Колонки Цикл
			
			КолонкаXDTO = ФабрикаXDTO.Создать(XDTOТипКолонкаТЗ);
			
			КолонкаXDTO.Name = ЗначениеТипаВЗначениеXDTO(Колонка.Имя);
			КолонкаXDTO.ValueType = СериализаторXDTO.ЗаписатьXDTO(Колонка.ТипЗначения);
			КолонкаXDTO.Title = ЗначениеТипаВЗначениеXDTO(Колонка.Заголовок);
			КолонкаXDTO.Width = ЗначениеТипаВЗначениеXDTO(Колонка.Ширина);
			
			СтруктураXDTO.column.Добавить(КолонкаXDTO);
			
		КонецЦикла;
		
		XDTOТипИндексТЗ = ТипСтруктура.Свойства.Получить("index").Тип;
		
		Для Каждого Индекс Из ЗначениеСтруктурногоТипа.Индексы Цикл
			
			ИндексXDTO = ФабрикаXDTO.Создать(XDTOТипИндексТЗ);
			
			Для Каждого ПолеИндекса Из Индекс Цикл
				ИндексXDTO.column.Добавить(ЗначениеТипаВЗначениеXDTO(ПолеИндекса));
			КонецЦикла;
			
			СтруктураXDTO.index.Добавить(ИндексXDTO);
			
		КонецЦикла;
		
		XDTOТипСтрокаТЗ = ТипСтруктура.Свойства.Получить("row").Тип;
		
		Для Каждого СтрокаТЗ Из ЗначениеСтруктурногоТипа Цикл
			
			СтрокаXDTO = ФабрикаXDTO.Создать(XDTOТипСтрокаТЗ);
			
			Для Каждого ЗначениеКолонки Из СтрокаТЗ Цикл
				СтрокаXDTO.value.Добавить(ЗначениеТипаВЗначениеXDTO(ЗначениеКолонки));
			КонецЦикла;
			
			СтруктураXDTO.row.Добавить(СтрокаXDTO);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтруктураXDTO;
	
КонецФункции

// Получает объект структурного типа из XDTO-объекта.
//
// Параметры:
// ОбъектXDTO - Объект XDTO.
//
// Возвращаемое значение:
// Структурный тип ( Массив, Структура, Соответствие или их фиксированные аналоги) 
//
Функция ОбъектXDTOВСтруктурныйОбъект(ОбъектXDTO)
	
	ТипДанныхXML = Новый ТипДанныхXML(ОбъектXDTO.Тип().Имя, ОбъектXDTO.Тип().UriПространстваИмен);
	Если ВозможностьЧтенияТипаДанныхXML(ТипДанныхXML) Тогда
		СтруктурныйТип = СериализаторXDTO.ИзXMLТипа(ТипДанныхXML);
	Иначе
		Возврат ОбъектXDTO;
	КонецЕсли;
	
	Если СтруктурныйТип = Тип("Строка") Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не СериализуемыйСтруктурныйТип(СтруктурныйТип) Тогда
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Тип %1 не является структурным или его сериализация в настоящее время не поддерживается.'"),
			СтруктурныйТип);
		ВызватьИсключение(СообщениеОбОшибке);
	КонецЕсли;
	
	Если СтруктурныйТип = Тип("Структура")	Или СтруктурныйТип = Тип("ФиксированнаяСтруктура") Тогда
		
		СтруктурныйОбъект = Новый Структура;
		
		Для Каждого Свойство Из ОбъектXDTO.Property Цикл
			СтруктурныйОбъект.Вставить(Свойство.name, ЗначениеXDTOВЗначениеТипа(Свойство.Value));          
		КонецЦикла;
		
		Если СтруктурныйТип = Тип("Структура") Тогда
			Возврат СтруктурныйОбъект;
		Иначе 
			Возврат Новый ФиксированнаяСтруктура(СтруктурныйОбъект);
		КонецЕсли;
		
	ИначеЕсли СтруктурныйТип = Тип("Массив") Или СтруктурныйТип = Тип("ФиксированныйМассив") Тогда 
		
		СтруктурныйОбъект = Новый Массив;
		
		Для Каждого ЭлементМассива Из ОбъектXDTO.Value Цикл
			СтруктурныйОбъект.Добавить(ЗначениеXDTOВЗначениеТипа(ЭлементМассива));          
		КонецЦикла;
		
		Если СтруктурныйТип = Тип("Массив") Тогда
			Возврат СтруктурныйОбъект;
		Иначе 
			Возврат Новый ФиксированныйМассив(СтруктурныйОбъект);
		КонецЕсли;
		
	ИначеЕсли СтруктурныйТип = Тип("Соответствие") Или СтруктурныйТип = Тип("ФиксированноеСоответствие") Тогда
		
		СтруктурныйОбъект = Новый Соответствие;
		
		Для Каждого КлючИЗначениеXDTO Из ОбъектXDTO.pair Цикл
			КлючИЗначение = ОбъектXDTOВСтруктурныйОбъект(КлючИЗначениеXDTO);
			СтруктурныйОбъект.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
		Если СтруктурныйТип = Тип("Соответствие") Тогда
			Возврат СтруктурныйОбъект;
		Иначе 
			Возврат Новый ФиксированноеСоответствие(СтруктурныйОбъект);
		КонецЕсли;
	
	ИначеЕсли СтруктурныйТип = Тип("КлючИЗначение")	Тогда	
		
		СтруктурныйОбъект = Новый Структура("Ключ, Значение");
		СтруктурныйОбъект.Ключ = ЗначениеXDTOВЗначениеТипа(ОбъектXDTO.key);
		СтруктурныйОбъект.Значение = ЗначениеXDTOВЗначениеТипа(ОбъектXDTO.value);
		
		Возврат СтруктурныйОбъект;
		
	ИначеЕсли СтруктурныйТип = Тип("ТаблицаЗначений") Тогда
		
		СтруктурныйОбъект = Новый ТаблицаЗначений;
		
		Для Каждого Колонка Из ОбъектXDTO.column Цикл
			
			СтруктурныйОбъект.Колонки.Добавить(
				ЗначениеXDTOВЗначениеТипа(Колонка.Name), 
				СериализаторXDTO.ПрочитатьXDTO(Колонка.ValueType), 
				ЗначениеXDTOВЗначениеТипа(Колонка.Title), 
				ЗначениеXDTOВЗначениеТипа(Колонка.Width));
				
		КонецЦикла;
		Для Каждого Индекс Из ОбъектXDTO.index Цикл
			
			ИндексСтрокой = "";
			Для Каждого ПолеИндекса Из Индекс.column Цикл
				ИндексСтрокой = ИндексСтрокой + ПолеИндекса + ", ";
			КонецЦикла;
			ИндексСтрокой = СокрЛП(ИндексСтрокой);
			Если СтрДлина(ИндексСтрокой) > 0 Тогда
				ИндексСтрокой = Лев(ИндексСтрокой, СтрДлина(ИндексСтрокой) - 1);
			КонецЕсли;
			
			СтруктурныйОбъект.Индексы.Добавить(ИндексСтрокой);
		КонецЦикла;
		Для Каждого СтрокаXDTO Из ОбъектXDTO.row Цикл
			
			СтрокаТЗ = СтруктурныйОбъект.Добавить();
			
			ЧислоКолонок = СтруктурныйОбъект.Колонки.Количество();
			Для Индекс = 0 По ЧислоКолонок - 1 Цикл 
				СтрокаТЗ[СтруктурныйОбъект.Колонки[Индекс].Имя] = ЗначениеXDTOВЗначениеТипа(СтрокаXDTO.value[Индекс]);
			КонецЦикла;
			
		КонецЦикла;
		
		Возврат СтруктурныйОбъект;
		
	КонецЕсли;
	
КонецФункции

Функция ВозможностьЧтенияТипаДанныхXML(Знач ТипДанныхXML)
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	Запись.ЗаписатьНачалоЭлемента("Dummy");
	Запись.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	Запись.ЗаписатьСоответствиеПространстваИмен("ns1", ТипДанныхXML.URIПространстваИмен);
	Запись.ЗаписатьАтрибут("xsi:type", "ns1:" + ТипДанныхXML.ИмяТипа);
	Запись.ЗаписатьКонецЭлемента();
	
	Строка = Запись.Закрыть();
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Строка);
	Чтение.ПерейтиКСодержимому();
	
	Возврат СериализаторXDTO.ВозможностьЧтенияXML(Чтение);
	
КонецФункции

// Получает значение простейшего типа в контексте XDTO.
//
// Параметры:
// ЗначениеТипа - Значение произвольного типа.
//
// Возвращаемое значение:
// Произвольный тип. 
//
Функция ЗначениеТипаВЗначениеXDTO(Знач ЗначениеТипа)
	
	Если ЗначениеТипа = Неопределено
		Или ТипЗнч(ЗначениеТипа) = Тип("ОбъектXDTO")
		Или ТипЗнч(ЗначениеТипа) = Тип("ЗначениеXDTO") Тогда
		
		Возврат ЗначениеТипа;
		
	Иначе
		
		Если ТипЗнч(ЗначениеТипа) = Тип("Строка") Тогда
			ТипXDTO = ФабрикаXDTO.Тип("http://www.w3.org/2001/XMLSchema", "string")
		Иначе
			ТипXML = СериализаторXDTO.XMLТипЗнч(ЗначениеТипа);
			ТипXDTO = ФабрикаXDTO.Тип(ТипXML);
		КонецЕсли;
		
		Если ТипЗнч(ТипXDTO) = Тип("ТипОбъектаXDTO") Тогда // Значение структурного типа.
			Возврат СтруктурныйОбъектВОбъектXDTO(ЗначениеТипа);
		Иначе
			Возврат ФабрикаXDTO.Создать(ТипXDTO, ЗначениеТипа); // Например, UUID.
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

// Получает платформенный аналог значения XDTO-типа.
//
// Параметры:
// ЗначениеXDTO - Значение произвольного XDTO-типа.
//
// Возвращаемое значение:
// Произвольный тип. 
//
Функция ЗначениеXDTOВЗначениеТипа(ЗначениеXDTO)
	
	Если ТипЗнч(ЗначениеXDTO) = Тип("ЗначениеXDTO") Тогда
		Возврат ЗначениеXDTO.Значение;
	ИначеЕсли ТипЗнч(ЗначениеXDTO) = Тип("ОбъектXDTO") Тогда
		Возврат ОбъектXDTOВСтруктурныйОбъект(ЗначениеXDTO);
	Иначе
		Возврат ЗначениеXDTO;
	КонецЕсли;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////
// Служебные функции и процедуры.
//

// Кодирует строковое значение по алгоритму base64
//
// Параметры:
// Строка - Строка.
//
// Возвращаемое значение:
// Строка - base64-представление.
//
Функция СтрокаВBase64(Знач Строка) Экспорт
	
	Хранилище = Новый ХранилищеЗначения(Строка, Новый СжатиеДанных(9));
	
	Возврат XMLСтрока(Хранилище);
	
КонецФункции

// Декодирует base64-представление строки в исходное значение.
//
// Параметры:
// СтрокаBase64 - Строка.
//
// Возвращаемое значение:
// Строка.
//
Функция Base64ВСтроку(Знач СтрокаBase64) Экспорт
	
	Хранилище = XMLЗначение(Тип("ХранилищеЗначения"), СтрокаBase64);
	
	Возврат Хранилище.Получить();
	
КонецФункции


