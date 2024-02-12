
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Этаформа.Параметры.Отбор.Свойство("ВидОбработки") Тогда
		ВидОбработки = Этаформа.Параметры.Отбор.ВидОбработки;
		Если ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.ПечатнаяФорма Тогда
			Заголовок = "Дополнительные внешние печатные формы";
		ИначеЕсли ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка Тогда
			Заголовок = "Дополнительные внешние обработки";
		ИначеЕсли ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда
			Заголовок = "Дополнительные внешние отчеты";
		ИначеЕсли ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.ЗаполнениеСпискаСМСРассылки Тогда
			Заголовок = "Дополнительные обработки заполнения списка рассылок СМС";
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СправочникСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ВыбраннаяСтрока = Этаформа.Элементы.СправочникСписок.ТекущиеДанные;
	
	Если Не ВыбраннаяСтрока.ЭтоГруппа Тогда
		                                               
		ЭтоОбработка = ?(ВыбраннаяСтрока.ВидОбработки = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхВнешнихОбработок.Обработка"), Истина, Ложь);
		ЭтоОтчет = ?(ВыбраннаяСтрока.ВидОбработки = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхВнешнихОбработок.Отчет"), Истина, Ложь);
		
		Если НЕ (ЭтоОбработка ИЛИ ЭтоОтчет) Тогда
			Возврат;
		КонецЕсли;
		
		Попытка
			#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда 
				Если ЭтоОбработка Тогда
					
					ИмяФайла = ПолучитьИмяВременногоФайла(".epf");
					ЗаписатьДвоичныеДанные(ИмяФайла);
					
					Результат = ОбработкаОткрытияОбработки(ИмяФайла, ВыбраннаяСтрока.БезопасныйРежим);
					
				Иначе
					
					ИмяФайла = ПолучитьИмяВременногоФайла(".erf");
					ЗаписатьДвоичныеДанные(ИмяФайла);
					
					ПараметрыФормы = Новый Структура("Отчет", ВыбраннаяСтрока.Ссылка);
					Результат = ОбработкаОткрытияОтчета(ИмяФайла, ВыбраннаяСтрока.БезопасныйРежим, ПараметрыФормы);
					
				КонецЕсли;
			#Иначе
				Если ЭтоОбработка Тогда
					
					Адрес = ЗаписатьДвоичныеДанныеВеб();
					
					Результат = ОбработкаОткрытияОбработкиВеб(Адрес);
					
				Иначе
					
					Адрес = ЗаписатьДвоичныеДанныеВеб();
					
					ПараметрыФормы = Новый Структура("Отчет", ВыбраннаяСтрока.Ссылка);
					Результат = ОбработкаОткрытияОтчетаВеб(Адрес, ПараметрыФормы);
					
				КонецЕсли;
			#КонецЕсли	
			Если Не Результат Тогда
				
				Если ЭтоОбработка Тогда
					#Если ТолстыйКлиентУправляемоеПриложение Тогда
						ВнешняяОбработка = ВнешниеОбработки.Создать(ИмяФайла);
					#ИначеЕсли НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
						СоздатьВнешнююОбработку(ИмяФайла);
					#КонецЕсли
				Иначе
					#Если ТолстыйКлиентУправляемоеПриложение Тогда
						ВнешнийОтчет = ВнешниеОтчеты.Создать(ИмяФайла);
					#ИначеЕсли НЕ ВебКлиент И НЕ МобильныйКлиент  Тогда
						СоздатьВнешнийОтчет(ИмяФайла);
					#КонецЕсли
					
				КонецЕсли;
				
			КонецЕсли;
			#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда
				УдалитьФайлы(ИмяФайла);
			#КонецЕсли
			
		Исключение
			
			Если ЭтоОбработка Тогда
				#Если ТолстыйКлиентУправляемоеПриложение Тогда
					ПоказатьПредупреждение(,НСтр("ru='Выбранный файл не является внешней обработкой.
					|Либо, данная обработка не предназначена для
					|запуска в этой конфигурации.'"));
				#Иначе
					ПоказатьПредупреждение(,НСтр("ru='Выбранный файл не является внешней обработкой.
					|Либо данная обработка не предназначена для
					|запуска в этой конфигурации,
					|либо не может быть запущена в тонком клиенте.'"));
				#КонецЕсли
				
			Иначе
				#Если ТолстыйКлиентУправляемоеПриложение Тогда
					ПоказатьПредупреждение(,НСтр("ru='Выбранный файл не является внешним отчетом.
					|Либо, данный отчет не предназначена для
					|запуска в этой конфигурации.'"));
				#Иначе
					ПоказатьПредупреждение(,НСтр("ru='Выбранный файл не является внешним отчетом.
					|Либо данный отчет не предназначена для
					|запуска в этой конфигурации,
					|либо не может быть запущена в тонком клиенте.'"));
				#КонецЕсли
			КонецЕсли;
			
		КонецПопытки;
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОбработкаОткрытияОбработки(ИмяФайла, БезопасныйРежим)
	
	Попытка
		// Помещаем обработку во временном хранилище.
		АдресХранилища = "";
		Попытка
			Результат = ПоместитьФайл(АдресХранилища, ИмяФайла, , Ложь);           
			ИмяОбработки = ОбщегоНазначенияСервер.ПодключитьВнешнююОбработку(АдресХранилища, БезопасныйРежим);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
		
		// Откроем форму подключенной внешней обработки.
		ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма");
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Функция ОбработкаОткрытияОтчета(ИмяФайла, БезопасныйРежим, ПараметрыФормы = Неопределено)
	
	Попытка
		// Помещаем обработку во временном хранилище.
		АдресХранилища = "";
		Результат = ПоместитьФайл(АдресХранилища, ИмяФайла, , Ложь);           
		ИмяОбработки = ПодключитьВнешнийОтчет(АдресХранилища, БезопасныйРежим);
		
		// Откроем форму подключенной внешней обработки
		ОткрытьФорму("ВнешнийОтчет."+ ИмяОбработки +".Форма");//, ПараметрыФормы);
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция ПодключитьВнешнийОтчет(АдресХранилища, БезопасныйРежим)
	Если БезопасныйРежим = Неопределено Тогда
		Возврат ВнешниеОтчеты.Подключить(АдресХранилища);
	Иначе
		Возврат ВнешниеОтчеты.Подключить(АдресХранилища,, БезопасныйРежим);
	КонецЕсли;
КонецФункции  

&НаКлиенте
Процедура ЗаписатьДвоичныеДанные(ИмяФайла)
	
	ВыбраннаяСтрока = этаформа.элементы.СправочникСписок.ТекущаяСтрока;
	ДвоичныеДанные = ПолучитьДвоичныеДанныеВнешнейОбработки(ВыбраннаяСтрока);
	Если ДвоичныеДанные <> Неопределено Тогда
		ДвоичныеДанные.Записать(ИмяФайла);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Данных для записи не найдено'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДвоичныеДанныеВнешнейОбработки(ВнешняяОбработка)
	
	Возврат ВнешняяОбработка.ХранилищеВнешнейОбработки.Получить();
	
КонецФункции

&НаСервере
Процедура СоздатьВнешнююОбработку(ИмяФайла) 
	Попытка
		ВнешняяОбработка = ВнешниеОбработки.Создать(ИмяФайла);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры	

&НаСервере
Процедура СоздатьВнешнийОтчет(ИмяФайла)
	ВнешнийОтчет = ВнешниеОтчеты.Создать(ИмяФайла);
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьДвоичныеДанныеВеб()
	
	ВыбраннаяСтрока = этаформа.элементы.СправочникСписок.ТекущаяСтрока;
	ДвоичныеДанные = ПолучитьДвоичныеДанныеВнешнейОбработки(ВыбраннаяСтрока);
	Если ДвоичныеДанные <> Неопределено Тогда
		Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	Иначе
		Адрес = "";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Данных для записи не найдено'"));
	КонецЕсли;
	Возврат Адрес;
КонецФункции

&НаКлиенте
Функция ОбработкаОткрытияОбработкиВеб(АдресХранилища)
	
	Попытка
		Попытка
			ИмяОбработки = ОбщегоНазначенияСервер.ПодключитьВнешнююОбработку(АдресХранилища);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
		
		// Откроем форму подключенной внешней обработки.
		ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма");
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Функция ОбработкаОткрытияОтчетаВеб(АдресХранилища, ПараметрыФормы = Неопределено)
	
	Попытка
		
		ИмяОбработки = ПодключитьВнешнийОтчет(АдресХранилища, Неопределено);
		
		// Откроем форму подключенной внешней обработки.
		ОткрытьФорму("ВнешнийОтчет."+ ИмяОбработки +".Форма");
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#КонецОбласти
